-- Задайте Tarantool'у начальную конфигурацию таким образом, 
-- чтобы значение memtx_memory было больше, чем физической памяти на вашей машине. 
-- Что произойдёт? Воспользуйтесь опцией -e для быстрой проверки.

-- tarantool -e 'box.cfg{ memtx_memory = 32 * 1024 * 1024 * 1024 * 1024 }'
-- Tarantool не запускается с ошибкой

-- ER_CFG: Incorrect value for option 'memtx_memory': must be >= 0 and <= 4398046510080, but it is 35184372088832
-- fatal error, exiting the event loop