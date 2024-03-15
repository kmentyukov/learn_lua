-- Что произойдёт, если попытаться создать прибор для несуществующего пользователя?

-- Ошибка
-- tarantool> box.space.devices:insert({'00:00:00:00:00:00', 'Model', 'Cool_model', 1, 'user_101', {note = 'Very cool model'}})
-- ---
-- - error: 'Foreign key constraint ''users'' failed for field ''5 (user)'': foreign
--     tuple was not found'
