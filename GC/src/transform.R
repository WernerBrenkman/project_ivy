# combine into one data frame. This way the factor vars have the same configuration
# =========================================
df = bind_rows(train, test, .id = 'set_id')

# Replacing NA variables with none
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
              'MiscFeature'
)

ifna = function(var, replacement){
  ifelse(is.na(var), replacement, as.character(var))
}

# In replacing NA, it's ordering the varibles with integers from 1 - 6; 
# in doing so, we are loosing the ordinality of the features
df = df %>%
  mutate_at(none_vars, ifna, replacement = 'None')

# Setting variables to factors (no ordinality)
# =========================================
fact_vars = c('MSSubClass', 
              'MSZoning',
              'Street',
              'Alley',
              'LandContour',
              'LotConfig',
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
              'GarageType',
              'Fence',
              'SaleType',
              'SaleCondition',
              'Electrical',
              'MiscFeature')

spec_ord_fact = c('LotShape',
                  'LandSlope',
                  'BsmtExposure',
                  'BsmtFinType1',
                  'BsmtFinType2',
                  'CentralAir',
                  'Functional',
                  'GarageFinish',
                  'PavedDrive')

qual_fact = c('ExterQual',
              'ExterCond',
              'BsmtQual',
              'BsmtCond',
              'HeatingQC',
              'KitchenQual',
              'FireplaceQu',
              'GarageQual',
              'GarageCond',
              'PoolQC')

df = df %>%
  mutate_at(c(fact_vars), as.factor)

# Special case ordinal factors
# =========================================

df$LotShape = as.integer(revalue(as.character(df$LotShape), c(IR3 = 0, IR2 = 1, IR1 = 2, Reg = 3)))

df$LandSlope = as.integer(revalue(as.character(df$LandSlope), c(Sev = 0, Mod = 1, Gtl = 2)))

df$BsmtExposure = as.integer(revalue(as.character(df$BsmtExposure), c(None = 0, No = 1, Mn = 2, Av = 3, Gd = 4)))

Bsmt_Levels = c(None = 0, Unf = 1, LwQ = 2, Rec = 3, BLQ = 4, ALQ = 5, GLQ = 6)
df$BsmtFinType1 = as.integer(revalue(as.character(df$BsmtFinType1), Bsmt_Levels))
df$BsmtFinType2 = as.integer(revalue(as.character(df$BsmtFinType2), Bsmt_Levels))

df$CentralAir = as.integer(revalue(as.character(df$CentralAir), c(N = 0, Y = 1)))

func = c(Sal = 0, Sev = 1, Maj2 = 2, Maj1 = 3, Mod = 4, Min2 = 5, Min1 = 6, Typ = 7)
df$Functional = as.integer(revalue(as.character(df$Functional), func))

df$GarageFinish = as.integer(revalue(as.character(df$GarageFinish), c(None = 0, Unf = 1, RFn = 2, Fin = 3)))

df$PavedDrive = as.integer(revalue(as.character(df$PavedDrive), c(N = 0, P = 1, Y = 2)))

# Ordered List - Excellent Grading
df = df %>% 
  mutate_at(c(qual_fact), as.character)

Qualities  = c(None = 0, Po = 1, Fa = 2, TA = 3, Gd = 4, Ex = 5)

df$ExterQual = revalue(df$ExterQual, Qualities)
df$ExterCond = revalue(df$ExterCond, Qualities)
df$BsmtQual = revalue(df$BsmtQual, Qualities)
df$BsmtCond = revalue(df$BsmtCond, Qualities)
df$HeatingQC = revalue(df$HeatingQC, Qualities)
df$KitchenQual = revalue(df$KitchenQual, Qualities)
df$FireplaceQu = revalue(df$FireplaceQu, Qualities)
df$GarageQual = revalue(df$GarageQual, Qualities)
df$GarageCond = revalue(df$GarageCond, Qualities)
df$PoolQC = revalue(df$PoolQC, Qualities)

# Convert Ordered Factors to numeric values in order to build relationship in correlation matrix
df = df %>%
  mutate_at(c(qual_fact), as.integer)




# # var lists - to be used later
# # =========================================
# 
# factor_vars = c('MSSubClass',
#                 'MSZoning',
#                 'Street',
#                 'Alley',
#                 'LotShape',
#                 'LandContour',
#                 'Utilities',
#                 'LotConfig',
#                 'LandSlope',
#                 'Neighborhood',
#                 'Condition1',
#                 'Condition2',
#                 'BldgType',
#                 'HouseStyle',
#                 'RoofStyle',
#                 'RoofMatl',
#                 'Exterior1st',
#                 'Exterior2nd',
#                 'MasVnrType',
#                 'Foundation',
#                 'Heating',
#                 'CentralAir',
#                 'Electrical',
#                 'Functional',
#                 'GarageType',
#                 'GarageFinish',
#                 'PavedDrive',
#                 'MiscFeature', 
#                 'SaleType',
#                 'SaleCondition'
# )
# 
# ord_factor_vars = c('ExterQual',
#                     'ExterCond',
#                     'BsmtQual',
#                     'BsmtCond',
#                     'BsmtExposure',
#                     'BsmtFinType1',
#                     'BsmtFinType2',
#                     'HeatingQC',
#                     'KitchenQual',
#                     'FireplaceQu',
#                     'GarageQual',
#                     'GarageCond',
#                     'PoolQC',
#                     'Fence'
# )
# 
# qual_vars = c('')
# 
# order_vars = c('LotShape', 
#                'LandSlope', 
#                'NeighPrice', 
#                'ExterQual', 
#                'ExterCond', 
#                'BsmtQual', 
#                'BsmtCond',
#                'BsmtExposure', 
#                'BsmtFinType1',
#                'BsmtFinType2',
#                'HeatingQC',
#                'KitchenQual',
#                'FireplaceQu',
#                'GarageFinish',
#                'GarageQual',
#                'GarageCond',
#                'PoolQC',
#                'Fence',
#                'SalePriceLog')



