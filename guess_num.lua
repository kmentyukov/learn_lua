local rounds = 3
local score = 0
local reward = 20
local fine = 20

print('Давай сыграем в "Угадай число". Всего будет ' .. rounds .. ' раунда. Введи начало и конец диапазона чисел:')
local start = io.read("n")
local fin = io.read("n")
local trying = math.floor(math.log(fin-start, 2))

for round = 1, rounds do
    local num = math.random(start, fin)
    print()
    print('Раунд ' .. round .. '. Число загадано, количество попыток = ' .. trying)
    local try = trying
    local flag = false
    while try > 0 do
        flag = false
        print('Введите число:')
        local n = io.read("n")
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
