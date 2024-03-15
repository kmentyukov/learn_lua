-- Определить следующие функции:
-- queue_new(id) - создаёт запись в спейсе со строковым идентификатором <id>.
-- queue_push(id, data) - принимает первым аргументом идентификатор стека, вторым аргументом данные, которые нужно положить в очередь. 
--   Возвращает true, если удалось положить данные в очередь, или false, если в стек больше данные не получится положить. Размещение 
--   нового элемента расширяет кортеж (добавляет поле). 
-- queue_pop(id) - принимает первым аргументом идентификатор очереди, снимает значение с конца очереди и возвращает его. Удаление элемента 
--   урезает кортеж (удаляет поле).
-- queue_delete(id) - удаляет микроочередь из спейса.
-- Очередь должна быть типизированной (типами данных Tarantool).
-- Добавить поле с временем последнего изменения содержимого стека и обновлять его при каждой операции. Добавить поле с номером версии. 
--   Добавить в каждый метод (кроме queue_new) аргумент "номер версии" и обновлять только тогда, когда номера версий совпадают. 
--   Каждая операция увеличивает номер версии на 1.

local datetime = require('datetime')

box.cfg{
    listen = 3301,
    work_dir = 'data'
}

box.schema.user.grant('guest', 'super', nil, nil, {if_not_exists = true})

box.schema.space.create('queues', {
    if_not_exists = true,
    format = {
        {'id', 'string'},
        {'changed', 'datetime'},
        {'version', 'unsigned'},
        {'data', 'number', is_nullable = true}
    },
    engine = 'memtx'
})

box.space.queues:create_index('pk', {if_not_exists = true})

function queue_new(id)
    box.space.queues:insert({tostring(id), datetime.now(), 0})
end

function check_version(id, version)
    if box.space.queues:get(tostring(id))[3] == version then
        return true
    end
    return false
end

function queue_push(id, data, version)
    if check_version(id, version) then
        local res = box.space.queues:update(tostring(id), {
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

function queue_pop(id, version)
    if check_version(id, version) then
        local res = box.space.queues:get(tostring(id))
        res = res[#res]
        box.space.queues:update(tostring(id), {
            {'=', 'changed', datetime.now()},
            {'+', 'version', 1},
            {'#', -1, 1}
        })
        return res
    end
end

function queue_delete(id, version)
    if check_version(id, version) then
        box.space.queues:delete(tostring(id))
    end
end
