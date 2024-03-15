-- Как посчитать объём спейса в байтах? Сравнить с ручным подсчётом через размер кортежей.

local size = box.space.devices:bsize()
print('Объем спейса в байтах через bsize = ' .. tonumber(size))

size = 0
for _, device in box.space.devices:pairs() do
    local t_size = device:bsize()
    size = size + tonumber(t_size)
end
print('Объем спейса в байтах через подсчет кортежей = ' .. size)
