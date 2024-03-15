-- У одного из пользователей сменить состояние всех приборов.

local one_user = box.space.devices.index.user:select({'user_10'})

for _, device in pairs(one_user) do
    box.space.devices:update(device[1], {{'=', 'state', 0}})
end
