
# create area cluster.
# do this on the combined dataset (df) to ensure consistency
# =========================================
area_vars = c('LotFrontage',
              'LotArea', 
              'MasVnrArea',
              'BsmtUnfSF',
              'TotalBsmtSF', 
              'GrLivArea',
              'GarageArea',
              'OverallQual',
              'x_1stFlrSF',
              'x_2ndFlrSF',
              'PoolArea',
              'rat_Lot_1stFlr',
              'rat_garag_land',
              'OverallQual'
              )

df_area = scale(df[, area_vars]) %>%
  as.data.frame()



# dissimilarity matrix using pearson. Pearson is less sensitive to outliers.
# =========================================
require(factoextra)
d_prsn = get_dist(df_area, method = 'spearman')


# k-mediods using pam. Also less sensitive to outliers
# =========================================
pam = pam(x = d_prsn, diss = TRUE, k=3)
clusters = data.frame(Id = df[['Id']], area_cl = as.factor(pam[['clustering']]))


# join results to train & test
# =========================================
train = train %>%
  left_join(., clusters)

test = test %>%
  left_join(., clusters)

df = df %>%
  left_join(., clusters)


# cleanup
# =========================================
rm(clusters, pam, df_area, d_prsn)
