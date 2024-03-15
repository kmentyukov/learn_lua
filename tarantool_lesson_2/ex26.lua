-- В чём разница между box.space.<space>:put(...) и box.space.<space>:replace()? 
-- Продемонстрировать с помощью программы.

-- Разницы нет, работают одинаково. Но box.space...:put()) иногда используется как противоположность 
-- box.space...:get() - разница разве что в читаемости кода.

-- tarantool> box.space.devices:get('94:67:88:88:21:21')
-- ---
-- - ['94:67:88:88:21:21', 'model3', '', 3, 'user_10', {'note': 'Please, write something'}]
-- ...

-- tarantool> box.space.devices:put({'94:67:88:88:21:21', 'New model', '', 0, 'user_11', {note = 'something'}})
-- ---
-- - ['94:67:88:88:21:21', 'New model', '', 0, 'user_11', {'note': 'something'}]
-- ...

-- tarantool> box.space.devices:get('94:67:88:88:21:21')
-- ---
-- - ['94:67:88:88:21:21', 'New model', '', 0, 'user_11', {'note': 'something'}]
-- ...

-- tarantool> box.space.devices:replace({'94:67:88:88:21:21', 'Very new model', '', 0, 'user_11', {note = 'something'}})
-- ---
-- - ['94:67:88:88:21:21', 'Very new model', '', 0, 'user_11', {'note': 'something'}]
-- ...

-- tarantool> box.space.devices:get('94:67:88:88:21:21')
-- ---
-- - ['94:67:88:88:21:21', 'Very new model', '', 0, 'user_11', {'note': 'something'}]
-- ...
