-- local format = {
--     {name = 'user_name', type = 'string'},
--     {name = 'total_games', type = 'unsigned'},
--     {name = 'total_score', type = 'unsigned'},
--     {name = 'win_num', type = 'unsigned'},
--     {name = 'lose_num', type = 'unsigned'}
-- }

local format = {
    player_format = {
        {name = 'user_name', type = 'string'},
        {name = 'total_games', type = 'unsigned'},
        {name = 'total_score', type = 'unsigned'},
        {name = 'win_num', type = 'unsigned'},
        {name = 'lose_num', type = 'unsigned'}
    },
    game_format = {
        {name = 'id', type = 'string'},
        {name = 'player_name', foreign_key = {space = 'player', field = 'user_name'}},
        {name = 'datetime', type = 'string'},
        {name = 'secret_num', type = 'number'},
        {name = 'score', type = 'number'},
    }
}

return format
