-- Удалить все приборы у какого-нибудь пользователя.

local one_user = box.space.devices.index.user:select({'user_10'})

for _, device in pairs(one_user) do
    box.space.devices:delete(device[1])
end
