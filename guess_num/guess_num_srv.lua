local uuid = require('uuid')

local format = require('format')

box.cfg{
    listen = '127.0.0.1:3301',
    work_dir = './data'
}

box.schema.user.grant('guest', 'super', nil, nil, {if_not_exists = true})

box.schema.space.create('player', {
    format = format['player_format'],
    if_not_exists = true
})

box.schema.space.create('game', {
    format = format['game_format'],
    if_not_exists = true
})

box.space.player:create_index('pri', {
    parts = {'user_name'},
    if_not_exists = true
})

box.space.game:create_index('pri', {
    parts = {'id'},
    if_not_exists = true
})

local DEFAULT_ROUNDS = 3
local DEFAULT_REWARD = 20
local DEFAULT_FINE = 20

function create_user(user)
    box.space.player:insert({user, 0, 0, 0, 0})
    return true
end

function create_game(user)
    local id = uuid():str()
    local datetime = os.date()
    box.space.game:insert({id, user, datetime, 0, 0})
    return id
end

function game_setup(start, fin)
    local rounds = DEFAULT_ROUNDS
    local reward = DEFAULT_REWARD
    local fine = DEFAULT_FINE
    local attempts = math.floor(math.log(fin-start, 2))
    return rounds, reward, fine, attempts
end

function set_secret_num(id, start, fin)
    local secret_num = math.random(start, fin)
    box.space.game:update(id, {
        {'=', 'secret_num', secret_num}
    })
end

function is_match(id, num)
    local s_num = box.space.game:get({id})['secret_num']
    if num == s_num then
        return 10
    elseif num > s_num then
        return 20
    elseif num < s_num then
        return 30
    end
end
