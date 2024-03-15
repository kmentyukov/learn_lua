local datetime = require('datetime')

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

box.space.documents:create_index('created_by_status_created_at', {
    parts = {{'created_by'}, {'status'}, {'created_at'}},
    unique = false,
    if_not_exists = true
})

box.space.documents:create_index('modified_by_modified_at', {
    parts = {{'modified_by'}, {'modified_at'}},
    unique = false,
    if_not_exists = true
})

-- Изменение документа приводит к увеличение версии на 1 и обновлению даты и времени именения документа. - Разве это можно задать на этапе
--  создания схемы?
