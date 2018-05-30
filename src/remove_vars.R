
remove_vars = c('GarageYrBlt', 'GarageCars', 'set_id')
train[, remove_vars] = NULL
test[, remove_vars] = NULL
df[, remove_vars] = NULL

