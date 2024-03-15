-- Что произойдёт, если попытаться сменить у прибора пользователя на несуществующего?

-- tarantool> box.space.devices:update('99:99:20:32:32:50', {{'=', 'user', 'user_101'}})
-- ---
-- - error: 'Foreign key constraint ''users'' failed for field ''5 (user)'': foreign
--     tuple was not found'
