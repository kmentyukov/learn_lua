-- Что обозначает тип scalar и как его можно применить? Продемонстрируйте программой, 
-- которая конфигурирует Тарантул, создаёт спейс с полями, одно из которых типа scalar и 
-- приведите примеры использования.

box.cfg{
    listen = '127.0.0.1:3301'
}

box.schema.space.create('types', {
    format = {
        {name = 'key', type = 'string'},
        {name = 'value', type = 'scalar'}
    }
})

box.space.types:create_index('pk', {
    parts = {'key'}
})

-- Values in a scalar field can be boolean, integer, unsigned, double, number, decimal, 
-- string, uuid, or varbinary; but not array, map, or tuple.

-- - - ['boolean', true]
--   - ['integer', -100]
--   - ['string', 'string']
--   - ['unsigned', 100]

-- tarantool> box.space.types:insert({'tuple', {1, 2, 3}})
-- ---
-- - error: 'Tuple field 2 (value) type does not match one required by operation: expected
--     scalar, got array'
