-- Создать спейс person с двумя полями:
--   key, тип string 
--   value, тип any
-- Создать индекс c именем pk на поле key.
--   Как еще можно обозначить тип any?
--   Как можно создать спейс с полями за один вызов? 
--   Какие записи можно вставить?
--   Как можно прочитать эти записи?

box.cfg{
    listen = '127.0.0.1:3301'
}

box.schema.space.create('person', {
    format = {
        {name = 'key', type = 'string'},
        {name = 'value', type = nil}
    }
})

box.space.person:create_index('pk', {
    parts = {'key'}
})

-- any - Values in a field of this type can be boolean, integer, unsigned, double, number, decimal, 
--   string, uuid, varbinary, array, map, or tuple.
--   type = nil, вообще не указывать тип поля.
-- Создать спейс за один вызов - не понятно, что имеется ввиду? То, как сделано выше?
-- Можно вставить записи, состоящие из двух и более полей, первое - обязательно строка.
-- box.space.person:select()
