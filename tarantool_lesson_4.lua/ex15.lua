-- Команда tarantool -e 'box.cfg{work_dir = "dir_a"}' -i падает с ошибкой can't chdir to
-- `dir_a': No such file or directory. Как можно исправить? Предложите варианты.

-- Экземпляр сервера переключается на work_dir с помощью chdir(2) после запуска. Если такой директории не существует, 
-- tarantool падает с ошибкой.
-- 1) Создать директорию средствами операционной системы перед конфигрурированием tarantool
-- 2) Создать директорию средствами tarantool
--    tarantool -l fio -e 'fio.mkdir("./dir_a")' -e 'box.cfg{work_dir = "dir_a"}' -i
