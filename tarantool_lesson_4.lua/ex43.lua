-- Исправить ошибки в программе:

box.cfg {
    listen = '3301'
}
--    :   ,    NULL - Это артефакт копирования?
box.schema.space.create('key_value', {
    format = {
        {name = 'key', type = 'string'},
        {name = 'value', type = 'string', is_nullable = true}
    },
    if_not_exists = true
})
