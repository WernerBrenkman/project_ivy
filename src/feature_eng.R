

# group neighbourhoods into buckets using median saleprice
# =========================================
breaks = quantile(df$SalePrice[df$set_id == '1'], probs = seq(0, 1, 0.2))
labels = LETTERS[1:(length(breaks)-1)]
x = df %>%
  filter(set_id == '1') %>%
  dplyr::select(Neighborhood, SalePrice) %>%
  group_by(Neighborhood) %>%
  summarise(med = median(SalePrice))
x$NeighPrice = cut(x$med, breaks = breaks, labels = labels)
x$med = NULL

# add to df
df = df %>%
  dplyr::left_join(., x)

df$Neighborhood = as.factor(df$Neighborhood)
rm(x, labels, breaks)

# group MSSubClass into buckets using mean saleprice
# =========================================
df$MSSubClassPrice[df$MSSubClass %in% c('60', '120', '75', '20')] = 2
df$MSSubClassPrice[!df$MSSubClass %in% c('30', '180', '45', '60','120', '75', '20' )] = 1
df$MSSubClassPrice[df$MSSubClass %in% c('30', '180', '45')] = 0


# transforms
# =========================================
df = df %>%
  mutate(LotArea = log10(LotArea),
         SalePriceLog = ifelse(set_id == '1', log10(SalePrice), NA),
         rat_Lot_1stFlr = x_1stFlrSF/LotArea,
         rat_garag_land = GarageArea/LotArea,
         cred_bubble = as.factor(ifelse(YrSold < 2008, '1', '2')),
         rat_1stFlr_GrLiv = log10(x_1stFlrSF*GrLivArea)
         )

# split into test and train again
# =========================================
train = df %>%
  filter(set_id == '1')
test = df %>%
  filter(set_id == '2')

# remove
# =========================================
# Added Utilities, not sure about BsmtUnfSF
remove_vars = c('GarageYrBlt', 'GarageCars', 'Utilities')
train[, remove_vars] = NULL
test[, c(remove_vars, 'SalePrice', 'SalePriceLog')] = NULL
df[, remove_vars] = NULL
