box.cfg{ listen = '127.0.0.1:3301' }
box.schema.user.grant('guest', 'super', nil, nil, {if_not_exists = true})

format = {{'user_name', 'string'},
          {'total_games', 'integer'},
          {'total_score', 'integer'},
          {'win_num', 'integer'},
          {'lose_num', 'integer'}
        }

box.schema.create_space('player', {if_not_exists = true})
box.space.player:format(format)
box.space.player:create_index('pri', {parts = {'user_name'}, if_not_exists = true})

local DEFAULT_ROUNDS = 3
local DEFAULT_REWARD = 20
local DEFAULT_FINE = 20
local steps = {'Начало диапазона: ', 'Конец дипазона: ', 'Конец диапазона должен быть больше начала', 'Для игры нужен диапазон пошире', 'Введите число: '}
local trying
local start
local fin

local function create_user(user)
    box.space.player:insert{user, 0, 0, 0, 0}
end

local function is_num(step)
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

local function greeting()
    print('Давай сыграем в "Угадай число". Всего будет ' .. DEFAULT_ROUNDS .. ' раунда. Введи начало и конец диапазона чисел:')
    print('Введи свое имя: ')
    local user = io.read()
    if box.space.player:get{user} then
        print('Привет ' .. user .. '! С возвращением!')
    else
        create_user(user)
        print('Добро пожаловать, ' .. user .. '!')
    end

    start = is_num(steps[1])
    fin = is_num(steps[2])
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

    trying = math.floor(math.log(fin-start, 2))
    return user
end

local function game(user)
    local score = 0
    for round = 1, DEFAULT_ROUNDS do
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
                score = score + DEFAULT_REWARD
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
            score = score - DEFAULT_FINE
        end
    end
    print(score)
    if score <= 0 then
        box.space.player:update(user, {{'+', 'total_games', 1},
                             {'+', 'lose_num', 1}
                            }
                      )
    else
        box.space.player:update(user, {{'+', 'total_games', 1},
                             {'+', 'total_score', score},
                             {'+', 'win_num', 1}
                            }
                      )
    end
    
    print(box.space.player:get{user})  
end

local user = greeting()
game(user)

require 'console'.start()
os.exit()