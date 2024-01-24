-- Какими способами можно добавить новые поля в спейс? Приведите 2 варианта.

-- 1) При отсутсвии данных можно добавить поле в раздел format и перезапустить инстанс.
-- 2) При наличии данных на запущенном инстансе можно добавить поле только в конец спейса:

local users = box.space.users
local fmt = users:format()

table.insert(fmt, { name = 'age', type = 'number', is_nullable = true })
users:format(fmt)
