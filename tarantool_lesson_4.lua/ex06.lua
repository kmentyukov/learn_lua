-- В чём разница между выполнением команды
-- tarantool -e 'box.cfg{listen=3301}'
-- и команды
-- tarantool -e 'box.cfg{listen=3301}' -i
-- ?

-- Во втором случае после конфигурирования тарантула мы останемся в интерактивном режиме, 
-- будем иметь возможность продолжать вводить код
