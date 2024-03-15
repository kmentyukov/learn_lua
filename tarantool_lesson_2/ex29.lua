
-- Какой индекс нужно создать, чтобы выполнить поиск всех приборов, которые принадлежат пользователю U и находящихся в определенном состоянии?
-- Можно ли этим индексом заменить индексы, которые предназначены для поиска приборов по определенному пользователю и поиска по состоянию?
-- На что влияет порядок полей в индексе? Продемонстрируйте с помощью программы.

local clock = require('clock')
local datetime = require('datetime')

box.cfg{
    listen = 3301,
    work_dir = 'data'
}

box.schema.space.create('users', {
    format = {
        {name = 'login', type = 'string'},
        {name = 'registered', type = 'datetime'},
        {name = 'last_login', type = 'datetime'},
        {name = 'deleted', type = 'boolean'}
    },
    if_not_exists = true
})

box.space.users:create_index('pk', {
    parts = {'login'},
    if_not_exists = true
})

box.space.users:create_index('registered', {
    parts = {'registered'},
    unique = false,
    if_not_exists = true
})

box.space.users:create_index('last_login', {
    parts = {'last_login'},
    unique = false,
    if_not_exists = true
})

box.space.users:create_index('deleted', {
    parts = {'deleted'},
    unique = false,
    if_not_exists = true
})

box.schema.space.create('devices', {
    format = {
        {name = 'address', type = 'string'},
        {name = 'model', type = 'string'},
        {name = 'name', type = 'string', is_nullable = true},
        {name = 'state', type = 'unsigned'},
        {name = 'user', type = 'string', foreign_key = {space = 'users', field = 'login'}},
        {name = 'attributes', type = 'map'}
    },
    if_not_exists = true
})

box.space.devices:create_index('pk', {
    parts = {'address'},
    if_not_exists = true
})

box.space.devices:create_index('user_state', {
    parts = {{'user'}, {'state'}},
    unique = false,
    if_not_exists = true
})

box.space.devices:create_index('state', {
    parts = {'state'},
    unique = false,
    if_not_exists = true
})

local function device_address(lenth)
    if lenth <= 1 then lenth = 1 end
    local address = ''
    for i = 1, lenth do
        math.randomseed(tonumber(clock.monotonic64()))
        local address_part = tostring(math.random(0,99))
        if string.len(address_part) < 2 then
            address_part = '0' .. address_part
        end
        address = address .. address_part .. ':'
    end
    return address:sub(1, -2)
end

for i = 1, 100 do
    math.randomseed(tonumber(clock.monotonic64()))
    local login = 'user' .. '_' .. i
    local start_time = os.time({year = 2023, month = 1, day = 1})
    local registered = math.random(start_time, os.time())
    local last_login = math.random(registered, os.time())
    local deleted = false
    box.space.users:insert({
        login,
        datetime.new({ timestamp = registered }),
        datetime.new({ timestamp = last_login }),
        deleted
    })
    for device_num = 1, math.random(3, 5) do
        local address = device_address(6)
        local model = 'model' .. device_num
        local name = ''
        local state = math.random(0, 10)
        local attributes = {
            note = 'Please, write something'
        }
        box.space.devices:insert({address, model, name, state, login, attributes})
    end
end

-- box.space.devices:create_index('user_state', {
--     parts = {{'user'}, {'state'}},
--     unique = false,
--     if_not_exists = true
-- })

-- Этим индексом можно заменить только индекс, который ищет по полю user, т.е. только по первому полю составного индекса.
-- Если в индексе поменять поля местами, то искать будет либо только по первому полю, либо по обоим полям одновременно. Порядок имеет значение.

-- tarantool> box.space.devices.index.user_state:select('user_10')
-- ---
-- - - ['26:92:39:73:71:91', 'model3', '', 0, 'user_10', {'note': 'Please, write something'}]
--   - ['60:03:83:61:30:82', 'model1', '', 3, 'user_10', {'note': 'Please, write something'}]
--   - ['50:48:67:57:24:24', 'model4', '', 4, 'user_10', {'note': 'Please, write something'}]
--   - ['53:22:97:98:68:68', 'model2', '', 5, 'user_10', {'note': 'Please, write something'}]

-- tarantool> box.space.devices.index.user_state:select({'user_10', 5})
-- ---
-- - - ['53:22:97:98:68:68', 'model2', '', 5, 'user_10', {'note': 'Please, write something'}]

-- tarantool> box.space.devices.index.user_state:select(5)
-- ---
-- - error: 'Supplied key type of part 0 does not match index part type: expected string'
