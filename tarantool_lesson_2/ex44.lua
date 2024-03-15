-- Удалить все документы, которые в статусе "Архив". Можно ли для этого использовать индекс?

-- Для удаления кортежа необходимо использовать уникальный индекс. Соотвественно с помощью индекса можно сделать селект, а уже в рамках 
-- полученного результата провести удаления. Чтобы использовать статус из индекса, он должен быть либо первой частью составного индеса, либо 
-- отдельным индексом.
-- В данном случае я изменил порядок полей в индексе

local datetime = require('datetime')
local clock = require('clock')

box.cfg{
    listen = 3301,
    work_dir = 'data'
}

box.schema.space.create('documents', {
    format = {
        {name = 'docnum', type = 'string'},
        {name = 'doctype', type = 'string'},
        {name = 'version', type = 'unsigned'},
        {name = 'name', type = 'string'},
        {name = 'created_at', type = 'datetime'},
        {name = 'modified_at', type = 'datetime'},
        {name = 'status', type = 'unsigned'},
        {name = 'content'},
        {name = 'created_by', type = 'string'},
        {name = 'modified_by', type = 'string'},
        {name = 'deleted_by', type = 'string', is_nullable = true}
    },
    if_not_exists = true
})

box.space.documents:create_index('pk', {
    parts = {{'doctype'}, {'docnum'}},
    if_not_exists = true
})

box.space.documents:create_index('status_created_at_created_by', {
    parts = {{'status'}, {'created_at'}, {'created_by'}},
    unique = false,
    if_not_exists = true
})

box.space.documents:create_index('modified_at_modified_by', {
    parts = {{'modified_at'}, {'modified_by'}},
    unique = false,
    if_not_exists = true
})

local DOCTYPES = {'doc', 'xls', 'pdf', 'jpg', 'txt'}

for _, dt in pairs(DOCTYPES) do
    for i = 1, 1000000/#DOCTYPES do
        math.randomseed(tonumber(clock.monotonic64()))
        local docnum = tostring(i)
        local doctype = dt
        local version = math.random(1, 100)
        local name = 'document' .. math.random(1, 1000000)
        local start_time = os.time({year = 2023, month = 1, day = 1})
        local created_at = math.random(start_time, os.time())
        local modified_at = math.random(created_at, os.time())
        local status = math.random(0, 4)
        local content = 'Some content'
        local created_by = 'user' .. math.random(1, 100)
        math.randomseed(tonumber(clock.monotonic64()))
        local modified_by = 'user' .. math.random(1, 100)
        local deleted = false
        box.space.documents:insert({
            docnum,
            doctype,
            version,
            name,
            datetime.new({ timestamp = created_at }),
            datetime.new({ timestamp = modified_at }),
            status,
            content,
            created_by,
            modified_by,
            nil
        })
    end
end

local res = box.space.documents.index.status_created_at_created_by:select(4)
local batch = 10
local time_to_yield = batch
for _, tuple in pairs(res) do
    box.space.documents:delete({tuple[2], tuple[1]})
    time_to_yield = time_to_yield - 1
    print(time_to_yield)
    if time_to_yield == 0 then
        print('pause')
        require('fiber').yield()
        time_to_yield = batch
    end
end
