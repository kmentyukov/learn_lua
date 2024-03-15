-- Получить список пользователей, зарегистрированных за последние 10 дней.

local datetime = require('datetime')

local iv = datetime.interval.new({day = 10})
local dt = datetime.now()

return box.space.users.index.registered:select({dt:sub(iv)}, {iterator = 'GE'})
