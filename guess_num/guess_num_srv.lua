box.cfg{
    listen = '127.0.0.1:3301',
    work_dir = './data'
}

box.schema.user.grant('guest', 'super', nil, nil, {if_not_exists = true})

box.schema.space.create('player', {
    format = {
        {name = 'user_name', type = 'string'},
        {name = 'secret_num', type = 'integer'},
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

function create_user(user)
    box.space.player:insert({user, 0, 0, 0, 0, 0})
    return true
end

function game_setup(start, fin)
    local rounds = DEFAULT_ROUNDS
    local reward = DEFAULT_REWARD
    local fine = DEFAULT_FINE
    local attempts = math.floor(math.log(fin-start, 2))
    return rounds, reward, fine, attempts
end

function set_secret_num(user, start, fin)
    secret_num = math.random(start, fin)
    box.space.player:update(user, {
        {'=', 'secret_num', secret_num}
    })
end

function is_guess(user, num)
    local s_num = box.space.player:get{user}['secret_num']
    if num > s_num then
        return true
    elseif num < s_num then
        return false
    end
end
