

# group neighbourhoods into buckets using median saleprice
# =========================================
breaks = quantile(df$SalePrice[df$set_id == '1'], probs = seq(0, 1, 0.1))
labels = LETTERS[1:(length(breaks)-1)]
x = df %>%
  filter(set_id == '1') %>%
  dplyr::select(Neighborhood, SalePrice) %>%
  group_by(Neighborhood) %>%
  summarise(med = median(SalePrice))
x$NeighborhoodClass = cut(x$med, breaks = breaks, labels = labels)
x$med = NULL

# add to df
df = df %>%
  dplyr::left_join(., x)

df$Neighborhood = as.factor(df$Neighborhood)
rm(x, labels, breaks)

# transforms
# =========================================
df = df %>%
  mutate(total_area = x_1stFlrSF + x_2ndFlrSF + TotalBsmtSF,
         SalePriceLog = ifelse(set_id == '1', log10(SalePrice), NA),
         rat_Lot_1stFlr = x_1stFlrSF/total_area,
         rat_garag_land = GarageArea/total_area,
         cred_bubble = as.factor(ifelse(YrSold < 2008, '1', '2')),
         rat_1stFlr_GrLiv = log10(x_1stFlrSF*GrLivArea),
         NeighborhoodClass = as.integer(NeighborhoodClass)
         )

# split into test and train again
# =========================================
train = df %>%
  filter(set_id == '1')
test = df %>%
  filter(set_id == '2')

# remove
# =========================================
remove_vars = c('GarageYrBlt', 'GarageCars')
train[, remove_vars] = NULL
test[, c(remove_vars, 'SalePrice', 'SalePriceLog')] = NULL
df[, remove_vars] = NULL
