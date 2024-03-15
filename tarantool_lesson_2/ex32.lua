-- Получить список пользователей, зарегистрировавшихся за неделю до текущей даты и ранее.

local datetime = require('datetime')

local iv = datetime.interval.new({day = 7})
local dt = datetime.now()

return box.space.users.index.registered:select({dt:sub(iv)}, {iterator = 'LE'})
