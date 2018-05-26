
remove_vars = c('GarageYrBlt', 'GarageCars', 'BsmtUnfSF', 'Utilities')
train[, remove_vars] = NULL
test[, remove_vars] = NULL