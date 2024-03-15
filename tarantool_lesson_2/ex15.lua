-- Выполнить операцию, которая вставляет новый прибор, если нет в таблице, или же заменить 
-- поля "модель", "пользовательское наименование" и "состояние".

box.space.devices:upsert({'00:00:00:00:00:02', 'Model', 'Cool_model', 1, 'user_11', {note = 'Very cool model'}}, {})

-- tarantool> box.space.devices:upsert({'00:00:00:00:00:02', 'Model', 'Cool_model', 1, 'user_11', {note = 'Very cool model'}}, {})
-- ---
-- ...

-- tarantool> box.space.devices:get({'00:00:00:00:00:02'})
-- ---
-- - ['00:00:00:00:00:02', 'Model', 'Cool_model', 1, 'user_11', {'note': 'Very cool model'}]
-- ...

box.space.devices:upsert(
    {'00:00:00:00:00:02', 'Model', 'Cool_model', 1, 'user_11', {note = 'Very cool model'}},
    {
        {'=', 'model', 'New_Model'},
        {'=', 'name', 'Cool_new_model'},
        {'=', 'state', 2}
    }
)

-- tarantool> box.space.devices:upsert(
--     {'00:00:00:00:00:02', 'Model', 'Cool_model', 1, 'user_11', {note = 'Very cool model'}},
--     {
--         {'=', 'model', 'New_Model'},
--         {'=', 'name', 'Cool_new_model'},
--         {'=', 'state', 2}
--     }
-- )
-- ---
-- ...

-- tarantool> box.space.devices:get({'00:00:00:00:00:02'})
-- ---
-- - ['00:00:00:00:00:02', 'New_Model', 'Cool_new_model', 2, 'user_11', {'note': 'Very
--       cool model'}]

-- Или это надо выполнить в одну команду?
