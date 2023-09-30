box.cfg{ listen = '127.0.0.1:3301' }
box.schema.user.grant('guest', 'super', nil, nil, {if_not_exists = true})

format = {{'user_id', 'unsigned'},
          {'user_name', 'string'},
          {'in_game', 'boolean'},
          {'secret_number', 'number'},
          {'attempts', 'number'},
          {'total_games', 'number'},
          {'total_score', 'number'},
          {'win_num', 'number'},
          {'lose_num', 'number'}
        }

box.schema.create_space('player', {format = format})

function next_id()
    local id = #box.space.player
    if id == nil then
        return 1
    else
        return id + 1
    end
end

function create_user(user_name)
    local user_id = next_id()
    box.space.player:insert(user_id, user_name, 0, 0, 0, 0)
end

local rounds = 3
local score = 0
local reward = 20
local fine = 20
local steps = {'Начало диапазона: ', 'Конец дипазона: ', 'Конец диапазона должен быть больше начала', 'Для игры нужен диапазон пошире', 'Введите число: '}

function is_num(step)
    print(step)
    repeat
        local line = io.read()
        local input_num = tonumber(line)
        if input_num == nil then
            print('Нужно ввести число, попробуй еще раз')
        else
            return input_num
        end
    until input_num ~= nil
end

print('Давай сыграем в "Угадай число". Всего будет ' .. rounds .. ' раунда. Введи начало и конец диапазона чисел:')
print('Введи свое имя: ')
local user_name = io.read()
create_user(user_name)


local start = is_num(steps[1])

local fin = is_num(steps[2])
if fin <= start then
    repeat
        print(steps[3])
        fin = is_num(steps[2])
    until fin > start
end
if fin - start == 1 then
    repeat
        print(steps[4])
        fin = is_num(steps[2])
    until fin - start > 1
end

local trying = math.floor(math.log(fin-start, 2))

for round = 1, rounds do
    local num = math.random(start, fin)
    print()
    print('Раунд ' .. round .. '. Число загадано, количество попыток = ' .. trying)
    local try = trying
    local flag = false
    while try > 0 do
        flag = false
        local n = is_num(steps[5])
        if n == num then
            print('Ты угадал!')
            flag = true
            score = score + reward
            break
        elseif n < num then
            print('Загаданное число больше')
        elseif n > num then
            print('Загаданное число меньше')
        end
        try = try - 1
        print('Осталось ' .. try .. ' попыток')
        print()
    end
    if flag == false then
        print('Ты не угадал :(')
        score = score - fine
    end
end
print('Твой счет = ' .. score)

require 'console'.start()
os.exit()