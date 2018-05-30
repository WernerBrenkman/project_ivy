
# combine into one data frame. This way the factor vars have the same levels
# =========================================
df = bind_rows(train, test, .id = 'set_id')
rm(train, test)

# var lists - to be used later
# =========================================
none_vars = c('Alley', 
              'BsmtQual', 
              'BsmtCond', 
              'BsmtExposure', 
              'BsmtFinType1', 
              'BsmtFinType2', 
              'FireplaceQu', 
              'GarageType', 
              'GarageFinish',
              'GarageQual',
              'GarageCond',
              'PoolQC',
              'Fence',
              'MiscFeature',
              'KitchenQual'
)

factor_vars = c('MSSubClass',
                'MSZoning',
                'Street',
                'Alley',
                'LotShape',
                'LandContour',
                'Utilities',
                'LotConfig',
                'LandSlope',
                'Neighborhood',
                'Condition1',
                'Condition2',
                'BldgType',
                'HouseStyle',
                'RoofStyle',
                'RoofMatl',
                'Exterior1st',
                'Exterior2nd',
                'MasVnrType',
                'Foundation',
                'Heating',
                'CentralAir',
                'Electrical',
                'Functional',
                'GarageType',
                'GarageFinish',
                'PavedDrive',
                'MiscFeature'
                )

ord_factor_vars = list(ExterQual = c('Po', 'Fa','TA', 'Gd', 'Ex'),
              ExterCond = c('Po', 'Fa','TA', 'Gd', 'Ex'),
              BsmtQual = c('None', 'Po', 'Fa','TA', 'Gd', 'Ex'),
              BsmtCond = c('None', 'Po', 'Fa','TA', 'Gd', 'Ex'),
              BsmtExposure = c('None', 'No', 'Mn','Av', 'Gd'),
              BsmtFinType1 = c('None', 'Unf', 'LwQ','Rec', 'BLQ', 'ALQ', 'GLQ'),
              BsmtFinType2 = c('None', 'Unf', 'LwQ','Rec', 'BLQ', 'ALQ', 'GLQ'),
              HeatingQC = c('Po', 'Fa','TA', 'Gd', 'Ex'),
              KitchenQual = c('None', 'Po', 'Fa','TA', 'Gd', 'Ex'),
              FireplaceQu = c('None', 'Po', 'Fa','TA', 'Gd', 'Ex'),
              GarageQual = c('None', 'Po', 'Fa','TA', 'Gd', 'Ex'),
              GarageCond = c('None', 'Po', 'Fa','TA', 'Gd', 'Ex'),
              PoolQC = c('None', 'Po', 'Fa','TA', 'Gd', 'Ex'),
              Fence = c('None', 'MnWw', 'GdWo', 'MnPrv', 'GdPrv'))


# explicitly set NA's based on data_desc.txt
# =========================================
ifna = function(var, replacement){
  ifelse(is.na(var), replacement, as.character(var))
}

df = df %>%
  mutate_at(none_vars, ifna, replacement = 'None')


# force the types of factors
# =========================================
df = df %>%
  mutate_at(c(factor_vars), as.factor)


# force the types of ordered factors to integers
# =========================================
f_ord = function(dat, col){
  return(factor(as.character(dat[[col]]), levels = ord_factor_vars[[col]], ordered = TRUE))
  }
for(name in names(ord_factor_vars)){
  df[[name]] = f_ord(df, name)
  df[[name]] = as.integer(df[[name]])
}

rm(name)

# remodeled Yes/No
# basement Yes/No
# garage Yes/No
# WoodDeck Yes/No
# Porch Yes/No
# Pool Yes/No
# Age
# GarageType Binary groups
# Condition2 Binary groups
# Neighborhood
# RoofMatl Binary WdShngl
# MSZoning Binary Commercial
# Functional
# Heating
# ExterQual


# BsmtUnfSF/TotalBsmtSF - ratio >> maybe rather use complement as it'll ...
# GrLivArea/total home area