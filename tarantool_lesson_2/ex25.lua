-- В чём разница между box.space.<space>:len() и box.space.<space>:count()? Продемонстрировать с помощью программы.

-- И то, и то - возврат количества кортежей. Но count - обходит весь спейс и сравнивает с заданным условием.
-- Поэтому работает медленнее.

local clock = require('clock')

local start_time
local stop_time

start_time = clock.monotonic64()
box.space.users:len()
stop_time = clock.monotonic64()
print('Функция len():', stop_time - start_time)

start_time = clock.monotonic64()
box.space.users:count()
stop_time = clock.monotonic64()
print('Функция count():', stop_time - start_time)
