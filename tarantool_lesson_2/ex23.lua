-- Удалить всех пользователей и все приборы.

box.space.devices:truncate()

for _, user in box.space.users:pairs() do
    box.space.users:delete(user[1])
end
