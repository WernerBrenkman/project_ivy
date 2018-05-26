# it makes no sense that there are NA's in LotFrontage
# let's impute using kNN with only certain variables
# =========================================
require(VIM)
dat = df %>%
  select(-GarageYrBlt, -SalePrice, -Id, -set_id)
dat.imp = kNN(dat, k = 3)

df = bind_cols(select(df, set_id, Id, GarageYrBlt), 
               dat.imp[, 1:(ncol(dat.imp)/2)], 
               select(df, SalePrice))

rm(dat.imp, dat)


# split into test and train again
# =========================================
train = df %>%
  filter(set_id == '1')
test = df %>%
  filter(set_id == '2')
train$SalePriceLog = log10(train$SalePrice)


