box.cfg{ listen = '127.0.0.1:3301' }
box.schema.user.grant('guest', 'super', nil, nil, {if_not_exists = true})