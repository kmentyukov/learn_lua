-- Сколько можно указать опций -l?

-- Максимальное количествно не нашел, но допускается указание нескольких опций подряд
-- tarantool -l json -l fiber ex05.lua

local json = json.encode{ test = 'Ok', time = fiber.time() }
print(json)
