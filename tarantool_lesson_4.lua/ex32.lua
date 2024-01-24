-- Преобразовать таблицу, которая передается в функцию :format(t) или в опции format в 
-- функции box. schema.space.create() к единому, читаемому виду:
-- {
--     {'key', 'number'},
--     {type = 'unsigned', 'rank'},
--     {name = 'name', type = 'string'},
--     {'value', '*', is_nullable = true}
-- }

{
    {name = 'key', type = 'number'},
    {name = 'rank', type = 'unsigned'},
    {name = 'name', type = 'string'},
    {name = 'value', type = '*', is_nullable = true}
}

-- Нигде не встречал запись '*' (ни в учебнике, ни в доке). 
-- В python это распоковка, это и есть аналог 'any'?
