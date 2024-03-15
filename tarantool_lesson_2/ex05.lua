-- Выражение box.tuple.new({uuid.new(), 'Ivan', 'Ivanov', 'Ivanovich', 43}):tomap({names_only = true}) 
-- выполняется без ошибок, но возвращает пустую таблицу. Почему? В каком случае будет возвращена непустая
-- таблица, с полями? Написать программу, иллюстрирующую поведение.

-- options (table) – единственный доступный параметр – names_only. Если names_only принимает значение false
-- или не указан (по умолчанию), то все поля появятся дважды: сначала с числовыми заголовками, а затем с именными
-- заголовками. Если же names_only = true, то все поля будут выведены один раз с именными заголовками.

-- Т.к. мы спейс не был форматирован, то при names_only = true выводит пустую таблицу
-- 1) Можно указать параметр false 

-- tarantool> box.tuple.new({uuid.new(), 'Ivan', 'Ivanov', 'Ivanovich', 43}):tomap() 
-- ---
-- - - 88e23068-3a90-4789-8bab-34cab14d8090
--   - Ivan
--   - Ivanov
--   - Ivanovich
--   - 43
-- ...

-- 2) Предварительно форматировать спейс

local uuid = require('uuid')

box.cfg{}

local format = {
    {name = 'uuid', type = 'uuid'},
    {name = 'name', type = 'string'},
    {name = 'middlename', type = 'string'},
    {name = 'surname', type = 'string'},
    {name = 'age', type = 'unsigned'}
}

box.schema.space.create('test', {format = format})
box.space.test:create_index('pk', {parts = {'uuid'}})
