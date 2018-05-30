
# it makes no sense that there are NA's in LotFrontage
# let's impute using kNN with only certain variables
# =========================================
require(VIM)
dat = df %>%
  dplyr::select(-GarageYrBlt, -SalePrice, -Id, -set_id)
dat.imp = kNN(dat, k = 3)

df = dplyr::bind_cols(dplyr::select(df, set_id, Id, GarageYrBlt), 
               dat.imp[, 1:(ncol(dat.imp)/2)], 
               dplyr::select(df, SalePrice))

rm(dat.imp, dat)
