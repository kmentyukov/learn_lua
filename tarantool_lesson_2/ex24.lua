-- Может ли поле, которое является внешним ключом, быть nullable? Продемонстрировать с помощью программы.

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
        {name = 'user', type = 'string', foreign_key = {space = 'users', field = 'login'}, is_nullable = true},
        {name = 'attributes', type = 'map'}
    },
    if_not_exists = true
})

box.space.devices:create_index('pk', {
    parts = {'address'},
    if_not_exists = true
})

box.space.devices:create_index('user', {
    parts = {'user'},
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
        local name = nil
        local state = math.random(0, 10)
        local attributes = {
            note = 'Please, write something'
        }
        box.space.devices:insert({address, model, name, state, nil, attributes})
    end
end

-- Может
-- tarantool> box.space.devices:get('99:66:50:50:58:58')
-- ---
-- - ['99:66:50:50:58:58', 'model3', null, 6, null, {'note': 'Please, write something'}]
-- ...
