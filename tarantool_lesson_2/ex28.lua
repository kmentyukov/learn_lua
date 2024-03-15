-- Имеются записи в следующем виде:
-- Как эти данные вставить в спейсы пользователя и приборов?

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


local users = {
    {
        login = 'user_1',
        registered = datetime.new({
            year = 2023,
            month = 1,
            day = 1
        }),
        last_login = datetime.now(),
        deleted = false
    },
    {
        login = 'user_2',
        registered = datetime.new({
            year = 2023,
            month = 2,
            day = 2
        }),
        last_login = datetime.now(),
        deleted = false
    }
}

local devices = {
    {
        address = '00:00:00:00:00:00',
        model = 'Electric Bulb',
        name = 'Kitchen bulb',
        state = 0,
        user = 'user_2',
        attributes = {
            note = 'Sometimes it switches to off...'
        }
    }
}

for _, user in pairs(users) do
    box.space.users:insert(box.space.users:frommap(user))
end

box.space.devices:insert(box.space.devices:frommap(devices[1]))
