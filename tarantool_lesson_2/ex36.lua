-- Определить следующие функции:
--   dict_new(id) - создает запись в спейсе со строковым идентификатором <id>
--   dict_set(id, key, value) - добавляет ключ <key> со значением <value> в словарь <id>.
--   dict_unset(id, key) - удаляет ключ <key> из словаря <id>
--   dict_increment(id, key, value) - если значение по ключу key числовое, то увеличить его на value. 
--   dict_decrement(id, key, value) - если значение по ключу key числовое, то уменьшить его на value. 
--   dict_delete(id) - удаляет словарь из спейса.
--   Добавить поле с временем последнего изменения содержимого стека и обновлять его при каждой операции. Добавить поле с номером версии. 
--     Добавить в каждый метод (кроме dict_new) аргумент "номер версии" и обновлять только тогда, когда номера версий совпадают. 
--     Каждая операция увеличивает номер версии на 1.
-- Подобрать наиболее эффективные реализации.

local datetime = require('datetime')

box.cfg{
    listen = 3301,
    work_dir = 'data'
}

box.schema.user.grant('guest', 'super', nil, nil, {if_not_exists = true})

box.schema.space.create('dicts', {
    if_not_exists = true,
    format = {
        {'id', 'string'},
        {'changed', 'datetime'},
        {'version', 'unsigned'},
        {'data', 'map', is_nullable = true}
    },
    engine = 'memtx'
})

box.space.dicts:create_index('pk', {if_not_exists = true})

function dict_new(id)
    box.space.dicts:insert({tostring(id), datetime.now(), 0})
end

local function check_version(id, version)
    if box.space.dicts:get(tostring(id))[3] == version then
        return true
    end
    return false
end

local function get_key(key)
    return 'data' .. '.' .. tostring(key)
end


function dict_set(id, key, value, version)
    if check_version(id, version) then
        -- Предполагается, что ключ уникальный. Иначе необходимо делать проверку на уникальность ключа.
        local res = box.space.dicts:get(tostring(id))['data']
        if res == nil then
            res = {}
        end
        res[key] = value
        return box.space.dicts:update(tostring(id), {
            {'=', 'changed', datetime.now()},
            {'+', 'version', 1},
            {'=', 'data', res}
        })
    end
end

function dict_unset(id, key, version)
    if check_version(id, version) then
        return box.space.dicts:update(tostring(id), {
            {'=', 'changed', datetime.now()},
            {'+', 'version', 1},
            {'#', get_key(key), 1}
        })
    end
end

function dict_increment(id, key, value, version)
    if check_version(id, version) then
        local res = box.space.dicts:get(tostring(id))['data'][tostring(key)]
        if type(res) == 'number' then
            return box.space.dicts:update(tostring(id), {
                {'=', 'changed', datetime.now()},
                {'+', 'version', 1},
                {'+', get_key(key), value}
            })
        end
    end
end

function dict_decrement(id, key, value, version)
    if check_version(id, version) then
        local res = box.space.dicts:get(tostring(id))['data'][tostring(key)]
        if type(res) == 'number' then
            return box.space.dicts:update(tostring(id), {
                {'=', 'changed', datetime.now()},
                {'+', 'version', 1},
                {'-', get_key(key), value}
            })
        end
    end
end

function dict_delete(id, version)
    if check_version(id, version) then
        return box.space.dicts:delete(tostring(id))
    end
end
