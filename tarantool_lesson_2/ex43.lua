-- Как получить полную выборку всех документов? Как избежать блокировки Tarantool в случаях больших выборок?

local batch = 10
local time_to_yield = batch
for _, tuple in box.space.documents:pairs() do
    box.space.documents:get({tuple[2], tuple[1]})
    time_to_yield = time_to_yield - 1
    if time_to_yield == 0 then
        print('pause')
        require('fiber').yield()
        time_to_yield = batch
    end
end
