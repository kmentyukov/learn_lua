-- Можно ли создать спейс с полями, у которых повторяется имя? Продемонстрируйте на примере.

box.cfg{
    listen = '127.0.0.1:3301'
}

box.schema.space.create('person', {
    format = {
        {name = 'key', type = 'string'},
        {name = 'value', type = 'any'},
        {name = 'value', type = 'string'}
    }
})

box.space.person:create_index('pk', {
    parts = {'key'}
})

-- Нельзя: ER_SPACE_FIELD_IS_DUPLICATE: Space field 'value' is duplicate
