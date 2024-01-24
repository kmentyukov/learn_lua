-- Как узнать версию tarantool, установленную на машине? 
-- Как узнать, с какими флагами компиляции была собрана эта версия?

-- 1) tarantool -v / tarantool --version

-- 2) Через модуль tarantool
--    tarantool> tarantool = require('tarantool')
--    ---
--    ...
--    tarantool> tarantool
