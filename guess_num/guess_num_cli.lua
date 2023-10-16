net_box = require('net.box')
conn = net_box.connect('127.0.0.1:3301')

local PHRASES = {
    en = {
        game_start = 'Let\'s play "Guess the number". There will be ',
        game_end = ' attempts in total. Enter the beginning and end of the range of numbers:',
        name_enter = 'Enter your name: ',
        greeting_start = 'Hello ',
        greeting_end = '! Welcome back!',
        welcome = 'Welcome, ',
        begin = 'Beginning of range: ',
        finish = 'End of range: ',
        num_enter = 'Enter a number: ',
        round_start_begin = '\nRound ',
        round_start_end = '. The number is guessed, the number of attempts = ',
        guess_num = 'You guessed right!',
        round_end_start = '',
        round_end_end = ' attempts left',
        you_lose = 'You lose :(',
        more_num = 'The hidden number is greater',
        less_num = 'The hidden number is less',
        number_warning = 'You need to enter a number, try again',
        end_more_start_warning = 'The end of the range must be larger, than eht beginning',
        range_wide_warning = 'You need a wider range to play',
    },
    ru = {
        select_lang = 'Enter the number | Введи число: ',
        game_start = 'Давай сыграем в "Угадай число". Всего будет ',
        game_end = ' раунда. Введи начало и конец диапазона чисел:',
        name_enter = 'Введи свое имя: ',
        greeting_start = 'Привет ',
        greeting_end = '! С возвращением!',
        welcome = 'Добро пожаловать, ',
        begin = 'Начало диапазона: ',
        finish = 'Конец дипазона: ',
        num_enter = 'Введите число: ',
        round_start_begin = '\nРаунд ',
        round_start_end = '. Число загадано, количество попыток = ',
        guess_num = 'Ты угадал!',
        round_end_start = 'Осталось ',
        round_end_end = ' попыток',
        you_lose = 'Ты проиграл :(',
        more_num = 'Загаданное число больше',
        less_num = 'Загаданное число меньше',
        number_warning = 'Нужно ввести число, попробуй еще раз',
        end_more_start_warning = 'Конец диапазона должен быть больше начала',
        range_wide_warning = 'Для игры нужен диапазон пошире',
    }}

local user
local rounds
local reward
local fine
local lang = 'ru'
local trying
local start
local fin

local function is_correct_input(step, lang)
    print(step)
    repeat
        local input = io.read()
        local number = tonumber(input)
        if number then
            return number
        else
            print(PHRASES[lang].number_warning)
        end
    until false
end

local function lang_select()
    print([[
        Привет! По умолчанию игра на русском языке.
        To select the English language enter - 1
        Во всех остальных случаях игра останется на русском.
    ]])
    local lang_num = is_correct_input(PHRASES.ru.select_lang, lang)
    if lang_num == 1 then
        print('You chose English')
        lang = 'en'
    else
        print('Продолжаем по-русски')
    end
    return lang
end

local function set_user(lang)
    print(PHRASES[lang].name_enter)
    local user = io.read()
    if conn.space.player:get{user} then
        print(PHRASES[lang].greeting_start .. user .. PHRASES[lang].greeting_end)
    else
        local result = conn:call('create_user', {user})
        if result then
            print(PHRASES[lang].welcome .. user .. '!')
        else
            print('Что-то пошло не так, попробуйте позже')
        end
    end
    return user
end

local function start_game(lang)
    user = set_user(lang)

    start = is_correct_input(PHRASES[lang].begin, lang)
    fin = is_correct_input(PHRASES[lang].finish, lang)
    if fin <= start then
        repeat
            print(PHRASES[lang].end_more_start_warning)
            fin = is_correct_input(PHRASES[lang].finish, lang)
        until fin > start
    end
    if fin - start == 1 then
        repeat
            print(PHRASES[lang].range_wide_warning)
            fin = is_correct_input(PHRASES[lang].finish, lang)
        until fin - start > 1
    end

    rounds, reward, fine, trying = conn:call('game_setup', {start, fin})

    print(PHRASES[lang].game_start .. rounds .. PHRASES[lang].game_end)

end

local function game(user, lang)
    local score = 0
    for round = 1, rounds do
        local secret_num = conn:call('set_secret_num', {start, fin})
        print(PHRASES[lang].round_start_begin .. round .. PHRASES[lang].round_start_end .. trying)
        local try = trying
        local flag = false
        while try > 0 do
            flag = false
            local n = is_correct_input(PHRASES[lang].num_enter, lang)
            if n == secret_num then
                print(PHRASES[lang].guess_num)
                flag = true
                score = score + reward
                break
            elseif n < secret_num then
                print(PHRASES[lang].more_num)
            elseif n > secret_num then
                print(PHRASES[lang].less_num)
            end
            try = try - 1
            print(PHRASES[lang].round_end_start .. try .. PHRASES[lang].round_end_end)
        end
        if flag == false then
            print(PHRASES[lang].you_lose)
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
    
    print(conn.space.player:get{user})
end

lang_select()
start_game(lang)
game(user, lang)
