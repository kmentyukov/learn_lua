-- Что произойдет, если удалить только пользователя, без удаления его приборов? Какая будет ошибка?

-- tarantool> box.space.users:delete('user_10')
-- ---
-- - error: 'Foreign key ''users'' integrity check failed: tuple is referenced'
-- ...

-- Ошибка проверки целостности, на кортеж есть ссылка
