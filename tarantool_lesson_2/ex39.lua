-- Получить список документов определенного типа. Как это сделать без добавления отдельного индекса? Как должен выглядеть первичный индекс?

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

box.space.documents:create_index('created_at_status_created_by', {
    parts = {{'created_at'}, {'status'}, {'created_by'}},
    unique = false,
    if_not_exists = true
})

box.space.documents:create_index('modified_by_modified_at', {
    parts = {{'modified_by'}, {'modified_at'}},
    unique = false,
    if_not_exists = true
})

box.space.documents:select('xls')

-- Мне кажется это и следующие задания имеет смысл делать после генерации записей. Так будет проще себя проверять.
