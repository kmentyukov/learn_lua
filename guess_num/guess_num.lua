box.cfg{
    listen = '127.0.0.1:3301'
}

box.schema.user.grant('guest', 'super', nil, nil, {if_not_exists = true})

box.schema.space.create('player', {
    format = {
        {name = 'user_name', type = 'string'},
        {name = 'total_games', type = 'integer'},
        {name = 'total_score', type = 'integer'},
        {name = 'win_num', type = 'integer'},
        {name = 'lose_num', type = 'integer'}
    },
    if_not_exists = true
})

box.space.player:create_index('pri', {
    parts = {'user_name'},
    if_not_exists = true
})

local DEFAULT_ROUNDS = 3
local DEFAULT_REWARD = 20
local DEFAULT_FINE = 20

local phrases = require('phrases')
local lang = 'ru'
local attempts
local start
local fin

local function create_user(user)
    box.space.player:insert({user, 0, 0, 0, 0})
end

local function gen_msg(phrase, key)
    return string.format(phrases[lang][phrase], tostring(key))
end

local function read_number(step)
    print(step)
    repeat
        local input = io.read()
        local number = tonumber(input)
        if number then
            return number
        end
        print(gen_msg('warning_number'))
    until false
end

local function lang_select()
    print([[
        Привет! По умолчанию игра на русском языке.
        To select the English language enter - 1
        Во всех остальных случаях игра останется на русском.
    ]])
    local lang_num = read_number(phrases.ru.select_lang)
    if lang_num == 1 then
        print('You chose English')
        lang = 'en'
    else
        print('Продолжаем по-русски')
    end
    return lang
end

local function set_user()
    print(gen_msg('name_enter'))
    local user = io.read()
    if box.space.player:get({user}) then
        print(gen_msg('greeting', user))
    else
        create_user(user)
        print(gen_msg('welcome', user))
    end
    return user
end

local function start_game()
    local user = set_user()
    print(gen_msg('game_start', DEFAULT_ROUNDS))
    start = read_number(gen_msg('begin'))
    fin = read_number(gen_msg('finish'))
    if fin <= start then
        repeat
            print(gen_msg('warning_end_more_start'))
            fin = read_number(gen_msg('finish'))
        until fin > start
    elseif fin - start == 1 then
        repeat
            print(gen_msg('warning_range_wide'))
            fin = read_number(gen_msg('finish'))
        until fin - start > 1
    end

    attempts = math.floor(math.log(fin-start, 2))
    return user
end

local function game(user)
    local score = 0
    for round = 1, DEFAULT_ROUNDS do
        local secret_num = math.random(start, fin)
        local attempt = attempts
        local flag = false
        print(gen_msg('round_start', round), gen_msg('round_start_attempts', attempts))
        while attempt > 0 do
            flag = false
            local n = read_number(gen_msg('num_enter'))
            if n == secret_num then
                print(gen_msg('guess_num'))
                flag = true
                score = score + DEFAULT_REWARD
                break
            elseif n < secret_num then
                print(gen_msg('more_num'))
            elseif n > secret_num then
                print(gen_msg('less_num'))
            end
            attempt = attempt - 1
            print(gen_msg('round_end', attempt))
        end
        if flag == false then
            print(gen_msg('you_lose'))
            score = score - DEFAULT_FINE
        end
    end
    if score <= 0 then
        box.space.player:update(user, {
            {'+', 'total_games', 1},
            {'+', 'lose_num', 1}
        })
    else
        box.space.player:update(user, {
            {'+', 'total_games', 1},
            {'+', 'total_score', score},
            {'+', 'win_num', 1}
        })
    end
    
    print(box.space.player:get({user}))
end

lang_select()
local user = start_game()
game(user)
