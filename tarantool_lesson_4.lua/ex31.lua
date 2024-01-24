-- Создать спейс person с двумя полями:
--   key, тип string 
--   value, тип any
-- Создать индекс c именем pk на поле key.
-- Вставить в спейс несколько разных записей.
--   Как прочитать все записи?
--   Как взять одну запись по ключу?

box.cfg{
    listen = '127.0.0.1:3301'
}

box.schema.space.create('person', {
    format = {
        {name = 'key', type = 'string'},
        {name = 'value', type = 'any'}
    }
})

box.space.person:create_index('pk', {
    parts = {'key'}
})

-- box.space.person:select()
-- - - ['Ivan', [1, 2, 3]]
--   - ['Kirill', 'Mentiukov']
--   - ['Oleg', -100]
-- box.space.person:get('Ivan')
