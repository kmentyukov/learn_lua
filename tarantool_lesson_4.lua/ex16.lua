-- Что произойдёт, если просто запустить в командной строке Tarantool (без конфигурирования), 
-- а потом в его консоли ввести Lua-выражение box.space ?

-- Ошибка. 
-- error: "builtin/box/load_cfg.lua:974: Please call box.cfg{} first\nstack traceback:\n\tbuiltin/box/load_cfg.lua:974:
--     in function '__index'\n\t[string \"return box.space\"]:1: in main chunk\n\t[C]:
--     in function 'pcall'\n\tbuiltin/box/console.lua:415: in function 'eval'\n\tbuiltin/box/console.lua:750:
--     in function 'repl'\n\tbuiltin/box/console.lua:801: in function <builtin/box/console.lua:789>"
