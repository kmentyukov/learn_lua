-- Как получить список пользователей в обратном порядке, с помощью операции select?

box.space.users:select({}, {iterator = 'REQ'})
