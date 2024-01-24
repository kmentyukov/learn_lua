-- Есть некоторая конфигурация Tarantool и задана следующая схема данных - спейс dictionary 
-- с полями key (строка) и value (произвольный тип).
-- Можно повторно создать этот спейс? Что будет происходить, если будет повторно вызвана 
-- функция создания спейса с этим же именем?
-- За что отвечает опция if_not_exists?

box.cfg{
    listen = '127.0.0.1:3301'
}

box.schema.space.create('dictionary', {
    format = {
        {name = 'key', type = 'string'},
        {name = 'value', type = '*'}
    }
})

box.space.dictionary:create_index('pk', {
    parts = {'key'}
})

-- Нет, нельзя. Будет ошибка: Space 'dictionary' already exists
-- Опция if_not_exists = true - Если спейс с таким именем еще не создан - создаст его. 
-- Если создан - ничего не будет происходить
