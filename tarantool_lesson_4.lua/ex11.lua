-- Как узнать текущие значения конфигурации при уже запущенном Tarantool? 
-- Написать программу на Lua, которая конфигурирует Tarantool, затем выводит 
-- на экран текущие значения конфигурации.
-- Ввыести параметры listen, work_dir, memtx_dir, wal_dir.

box.cfg{
    listen = '127.0.0.1:3301',
    work_dir = '.',
    memtx_dir = '.',
    wal_dir = '.',
}

print(
    box.cfg.listen,
    box.cfg.work_dir,
    box.cfg.memtx_dir,
    box.cfg.wal_dir
)
