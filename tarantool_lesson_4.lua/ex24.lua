-- Написать программу, которая конфигурирует Tarantool и создаёт space с названием person (без индексов, и без полей). 
-- Выполнится ли операция box.space.person:insert({'John'}) ? Что произойдёт?

box.cfg{}

box.schema.space.create('person')

-- Ошибка:
-- 2024-01-17 15:54:43.082 [72111] main/103/ex24.lua space.h:384 E> ER_NO_SUCH_INDEX_ID: No index #0 is defined in space 'person'
-- ---
-- - error: 'No index #0 is defined in space ''person'''
-- ...

-- Предварительно необходимо создать первичный индекс.
