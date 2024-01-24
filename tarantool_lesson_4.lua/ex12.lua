-- Tarantool запущен с помощью команды tarantool -e 'box.cfg{}'. 
-- Будет ли он принимать входящие подключения? 
-- Как это проверить? Изучите команду ss или netstat и продемонстрируйте.

-- netstat -a | grep -i "listen"
-- Не будет, т.к. тарантулу не назначен по умолчанию порт для прослушивания.

-- Порт не задан

-- k.mentiukov@k-mentiukov ~ % netstat -a | grep -i "listen"
-- tcp4       0      0  localhost.64174        *.*                    LISTEN     
-- tcp4       0      0  *.cvd                  *.*                    LISTEN     
-- tcp4       0      0  *.49476                *.*                    LISTEN     
-- tcp4       0      0  *.49542                *.*                    LISTEN     
-- tcp4       0      0  *.admind               *.*                    LISTEN     
-- tcp46      0      0  *.64132                *.*                    LISTEN     
-- tcp4       0      0  *.64131                *.*                    LISTEN     
-- tcp6       0      0  *.61500                *.*                    LISTEN     
-- tcp4       0      0  *.61500                *.*                    LISTEN     

-- Порт задан

-- k.mentiukov@k-mentiukov ~ % netstat -a | grep -i "listen"
-- tcp46      0      0  *.3301                 *.*                    LISTEN
-- tcp4       0      0  localhost.64174        *.*                    LISTEN
-- tcp4       0      0  *.cvd                  *.*                    LISTEN
-- tcp4       0      0  *.49476                *.*                    LISTEN
-- tcp4       0      0  *.49542                *.*                    LISTEN
-- tcp4       0      0  *.admind               *.*                    LISTEN
-- tcp46      0      0  *.64132                *.*                    LISTEN
-- tcp4       0      0  *.64131                *.*                    LISTEN
-- tcp6       0      0  *.61500                *.*                    LISTEN
-- tcp4       0      0  *.61500                *.*                    LISTEN
