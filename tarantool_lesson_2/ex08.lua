-- Что работает быстрее: вставка с использованием box.tuple.new или напрямую c использованием Lua-таблицы? 
-- Напишите программу, которая демонстрирует разницу в производительности, объясните почему.

local clock = require('clock')

box.cfg{
    listen = 3301
}

box.schema.space.create('people', {
    format = {
        {name = 'key', type = 'unsigned'},
        {name = 'name', type = 'string'},
        {name = 'surname', type = 'string'},
        {name = 'age', type = 'unsigned'}
    },
    if_not_exists = true
})

box.space.people:create_index('pk', {
    parts = {'key'},
    if_not_exists = true
})

local start_time
local stop_time
local tab = {1, 'Ivan', 'Ivanov', 43}

start_time = clock.monotonic64()
box.space.people:insert(box.tuple.new(tab))
stop_time = clock.monotonic64()
print(stop_time - start_time)

box.space.people:delete(1)

start_time = clock.monotonic64()
box.space.people:insert(tab)
stop_time = clock.monotonic64()
print(stop_time - start_time)

-- Быстрее работает через box.tuple.new, сделал несколько замеров, но через функцию всегда быстрее.
-- Предположу, что Луа-таблица - более тяжелая структура данных, а функция box.tuple.new написана на С. Т.е. она быстро
-- преобразует Луа-таблицу в простой кортеж, с которым работать быстрее.
