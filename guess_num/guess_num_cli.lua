net_box = require('net.box')
conn = net_box.connect('127.0.0.1:3301')

local phrases = require('phrases')

local user
local rounds
local reward
local fine
local lang = 'ru'
local attempts
local start
local fin

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
    if conn.space.player:get({user}) then
        print(gen_msg('greeting', user))
    else
        local result = conn:call('create_user', {user})
        if result then
            print(gen_msg('welcome', user))
        else
            print(gen_msg('warning_connect'))
        end
    end
    return user
end

local function start_game()
    user = set_user()
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

    rounds, reward, fine, attempts = conn:call('game_setup', {start, fin})

    print(gen_msg('game_start', rounds))
end

local function game(user)
    local score = 0
    for round = 1, rounds do
        conn:call('set_secret_num', {user, start, fin})
        print(gen_msg('round_start', round), gen_msg('round_start_attempts', attempts))
        local attempt = attempts
        local flag = false
        while attempt > 0 do
            flag = false
            local n = read_number(gen_msg('num_enter'))
            local answer = conn:call('is_match', {user, n})
            if answer == 30 then
                print(gen_msg('more_num'))
            elseif answer == 20 then
                print(gen_msg('less_num'))
            elseif answer == 10 then
                print(gen_msg('guess_num'))
                flag = true
                score = score + reward
                break
            end
            attempt = attempt - 1
            print(gen_msg('round_end', attempt))
        end
        if flag == false then
            print(gen_msg('you_lose'))
            score = score - fine
        end
    end
    if score <= 0 then
        conn.space.player:update(user, {
            {'+', 'total_games', 1},
            {'+', 'lose_num', 1}
        })
    else
        conn.space.player:update(user, {
            {'+', 'total_games', 1},
            {'+', 'total_score', score},
            {'+', 'win_num', 1}
        })
    end
    conn.space.player:update(user, {
        {'=', 'secret_num', 0}
    })
    print(conn.space.player:get({user}))
end

lang_select()
start_game()
game(user)
