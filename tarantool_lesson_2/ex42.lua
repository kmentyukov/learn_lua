-- Всем документам в спейсе, выставить статус, который обозначает "В обработке". Поскольку записей в спейсе много, это 
-- может повлиять на работу Tarantool. Как обойти эту проблему?

local batch = 10
local time_to_yield = batch
for _, tuple in box.space.documents:pairs() do
    box.space.documents:update({tuple[2], tuple[1]}, {
        {'=', 'status', 1}
    })
    time_to_yield = time_to_yield - 1
    if time_to_yield == 0 then
        require('fiber').yield()
        time_to_yield = batch
    end
end

-- Делать прерывание раз в заданный период.
