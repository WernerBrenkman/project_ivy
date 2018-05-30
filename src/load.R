# load the train and test data sets from disk
# =========================================
train = read_csv('data/train.csv')
test = read_csv('data/test.csv')


# append names of variables starting vith a numeric
# =========================================
idx = names(train) %>%
  grep('^[0-9]', .)
names(train)[idx] = paste0('x_', names(train)[idx])
rm(idx)


idx = names(test) %>%
  grep('^[0-9]', .)
names(test)[idx] = paste0('x_', names(test)[idx])
rm(idx)
