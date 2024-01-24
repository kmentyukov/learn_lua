-- Имеется следующая программа для Tarantool:
-- Lua-программа
-- box.cfg({
--     listen = 3301
-- })
-- box.schema.space_create('person')
-- Исправить ошибку.

box.cfg{
    listen = '3301'
}

box.schema.space.create('person')
