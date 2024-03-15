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

box.space.documents:create_index('created_at_status_created_by', {
    parts = {{'created_at'}, {'status'}, {'created_by'}},
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

-- tarantool> box.space.documents:bsize()
-- ---
-- - 75172154

-- tarantool> for _, document in box.space.documents:pairs() do
--     local t_size = document:bsize()
--     size = size + tonumber(t_size)
-- end

-- tarantool> size
-- ---
-- - 75172154

-- tarantool> box.space.documents.index.pk:bsize()
-- ---
-- - 21954560

-- tarantool> box.space.documents.index.created_at_status_created_by:bsize()
-- ---
-- - 19480576

-- tarantool> box.space.documents.index.modified_at_modified_by:bsize()
-- ---
-- - 19431424

-- tarantool> box.space.documents.index.modified_at_modified_by:max()
-- ---
-- - ['42564', 'txt', 91, 'document744236', '2023-08-15T03:53:28Z', '2024-02-26T03:51:05Z',
--   1, 'Some content', 'user58', 'user39']

-- tarantool> box.space.documents.index.created_at_status_created_by:min()
-- ---
-- - ['79479', 'doc', 2, 'document677962', '2023-01-01T09:00:24Z', '2023-08-05T18:11:19Z',
--   3, 'Some content', 'user49', 'user5']

-- tarantool> box.space.documents.index.pk:random(1)
-- ---
-- - ['83747', 'doc', 31, 'document133484', '2023-07-15T07:14:26Z', '2024-02-22T15:44:45Z',
--   4, 'Some content', 'user98', 'user92']
