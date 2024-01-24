-- Чем отличается тип number от типов integer, unsigned, decimal и double? 
-- Напишите программу, которая демонстрирует различия

-- number - может быть как целым числом, так и числом с плавающей запятой. 
-- integer - целые числа от -9223372036854775808 до 18446744073709551615
-- unsigned - целые неотрицательные числа от 0 до 18446744073709551615
-- decimal - используется при работе с точными числами. Дает более точный результат, чем числа с плавающей запятой
-- double - это числовые значения, которые содержат десятичную точку (например, 0.5) или представлены в экспоненциальной 
--   форме записи (например, 5E-1).

local decimal = require('decimal')

box.cfg {
    listen = 3301,
    work_dir = 'data'
}

box.schema.space.create('numbers', {
    format = {
        {name = 'key', type = 'string'},
        {name = 'number', type = 'number', is_nullable = true},
        {name = 'integer', type = 'integer', is_nullable = true},
        {name = 'unsigned', type = 'unsigned', is_nullable = true},
        {name = 'decimal', type = 'decimal', is_nullable = true},
        {name = 'double', type = 'double', is_nullable = true}
    },
    if_not_exists = true
})

box.space.numbers:create_index('pk', {
    parts = {'key'},
    if_not_exists = true
})

local TYPES = {
    'Вставка вариантов в поле number',
    'Вставка вариантов в поле integer',
    'Вставка вариантов в поле unsigned',
    'Вставка вариантов в поле decimal',
    'Вставка вариантов в поле double'}

local NUMS = {
    int_num_negative = -44,
    int_num_positive = 44,
    fl_point_num = 0.16666666666667 * 6,
    dec_num = decimal.new(0.16666666666667 * 6)
}

for i, t in ipairs(TYPES) do
    print('\n', '-- ' .. t .. ' --', '\n')
    for k, v in pairs(NUMS) do
        local pattern = {k, 0, 0, 0, 0, 0}
        pattern[i + 1] = v

        print(k, v, type(v))
        local res, err = pcall(box.space.numbers.insert, box.space.numbers, pattern)
        if err ~= nil then
            print('Error', err, '\n')
        else
            print('Result', res)
        end
        box.space.numbers:delete({k})
    end
end

-- Не понял, как работает поле decimal. Похоже что-то делаю не так.
-- pcall не возвращает положительный результат. Похоже опять что-то делаю не так.
