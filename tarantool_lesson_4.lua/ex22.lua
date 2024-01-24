-- Имеется следующая конфигурация Tarantool:
-- {
--     work_dir = 'data',
--     wal_dir = '/tmp/wal',
--     memtx_dir = '/tmp/snap'
-- }
-- Директория data создана там же, гда запускается Tarantool с такой конфигурацией, директории /tmp/wal и /tmp/snap созданы.
-- Где действительно будут располагаться снимки состояния и журналы?

-- Снимки состояния и журналы будут располагаться в /tmp/wal и /tmp/snap соответственно, а не в рабочей директории.