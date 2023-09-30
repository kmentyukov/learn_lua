local fiber = require('fiber')

box.cfg{ listen = '127.0.0.1:3301' }
box.schema.user.grant('guest', 'super', nil, nil, {if_not_exists = true})

fiber.create(function()
    while true do
        local input = io.read("*n")
        print('input is ', input)
        fiber.yield()
    end
end)