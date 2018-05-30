
# add very highly correlated principal components as features

# identify numeric variables
# =========================================
pca_vars = lapply(filter(df, set_id == '1'), function(x){ifelse(class(x) %in% c('integer', 'numeric'), 1, NA)}) %>% unlist()
pca_vars = names(pca_vars)[which(pca_vars == 1)]
pca_vars = pca_vars[pca_vars != 'Id']
pca_vars = pca_vars[pca_vars != 'SalePriceLog']
pca_vars = pca_vars[pca_vars != 'SalePrice']
pca_vars = pca_vars[pca_vars != 'GarageYrBlt']

df_pca = df[, pca_vars] %>%
  scale()

pca_fit = prcomp(df_pca)
df_pca = pca_fit$x %>%
  as.data.frame() %>%
  mutate('Id' = df[['Id']])

df_vars = df_pca %>%
  inner_join(., train[, c('Id', 'SalePriceLog')])

cor_m = cor(df_vars)
vars = colnames(cor_m)[which(abs(cor_m['SalePriceLog', ]) > .75)]
vars = vars[vars != 'SalePriceLog']


# keep only vars with high correlation to SalePriceLog
# =========================================

train = train %>%
  left_join(., df_pca[, c('Id', vars)])

test = test %>%
  left_join(., df_pca[, c('Id', vars)])

df = df %>%
  left_join(., df_pca[, c('Id', vars)])


rm(cor_m, pca_fit, df_pca, df_vars, vars)
