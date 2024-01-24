-- Имеется файл one.lua c одной строкой: print(2, ...). Запустим следующую команду: tarantool one.lua -e 'print(1)' . 
-- Что выведется и в каком порядке? Почему?

-- 2       -e      print(1)
-- Тут мне надо подкачать теорию. Три точки (...) в списке параметров указывают на то, что эта функция является вариадической. 
-- При вызове этой функции Lua внутренним образом собирает все ее аргументы; мы называем эти собранные аргументы 
-- дополнительными аргументами функции.
-- Соответственно tarantool восприниммет -e 'print(1)' как дополнительные аргументы функции print(). Почему? 
-- Я так понимаю, это связано с stdin.