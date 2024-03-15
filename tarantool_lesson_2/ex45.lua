-- Можно ли применять операцию update по частичному ключу? Например, чтобы обновить сразу несколько записей. 
-- Напишите программу, иллюстрирующую действительное поведение.

-- Нельзя. Для операции update нужен уникальный ключ. Если ключ составной, то требуются все поля ключа

local batch = 10
local time_to_yield = batch
for _, tuple in box.space.documents:pairs() do
    box.space.documents:update({tuple[1]}, {
        {'=', 'status', 1}
    })
    time_to_yield = time_to_yield - 1
    if time_to_yield == 0 then
        require('fiber').yield()
        time_to_yield = batch
    end
end

-- ---
-- - error: Invalid key part count in an exact match (expected 2, got 1)
-- ...
