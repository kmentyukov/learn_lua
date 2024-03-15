-- Добавить поле со временем последнего изменения содержимого стека и обновлять его при каждой операции. Добавить поле с номером версии. 
--   Добавить в каждый метод (кроме dict_new) аргумент "номер версии" и обновлять только тогда, когда номера версий совпадают. Каждая операция 
--   увеличивает номер версии на 1.

local datetime = require('datetime')

box.cfg{
    listen = 3301,
    work_dir = 'data'
}

box.schema.user.grant('guest', 'super', nil, nil, {if_not_exists = true})

box.schema.space.create('stacks', {
    if_not_exists = true,
    format = {
        {'id', 'string'},
        {'changed', 'datetime'},
        {'version', 'unsigned'},
        {'data', is_nullable = true}
    },
    engine = 'memtx'
})

box.space.stacks:create_index('pk', {if_not_exists = true})

function stack_new(id)
    box.space.stacks:insert({tostring(id), datetime.now(), 0})
end

function check_version(id, version)
    if box.space.stacks:get(tostring(id))[3] == version then
        return true
    end
    return false
end

function stack_push(id, data, version)
    if check_version(id, version) then
        local res = box.space.stacks:update(tostring(id), {
            {'=', 'changed', datetime.now()},
            {'+', 'version', 1},
            {'!', 'data', data}
        })
        if res ~= nil then
            return true
        end
    end
    return false
end

function stack_pop(id, version)
    if check_version(id, version) then
        local res = box.space.stacks:get(tostring(id))[4]
        box.space.stacks:update(tostring(id), {
            {'=', 'changed', datetime.now()},
            {'+', 'version', 1},
            {'#', 'data', 1}
        })
        return res
    end
end

function stack_delete(id, version)
    if check_version(id, version) then
        box.space.stacks:delete(tostring(id))
    end
end

-- Функции глобальные, т.к. тестировал через подключение к инстансу
