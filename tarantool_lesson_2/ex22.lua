-- Удалить выбранного пользователя и все его приборы.

local expel_user = 'user_11'

local expel_tuples = box.space.devices.index.user:select({expel_user})

for _, device in pairs(expel_tuples) do
    box.space.devices:delete(device[1])
end

box.space.users:delete(expel_user)
