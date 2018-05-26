################################
### EDA - House Prices
### Gabriella
################################
setwd("/Users/Gabriella_Camara/Documents/NYDSA/Machine Learning/House Prices - Werner, Gabriella, Petronella")
# Add train + test (numreic as factor will be different; keeping in mind levels)

# Required packages
install.packages("PCAmixdata")
install.packages('corrplot')

library(PCAmixdata)
library('dplyr')
library('VIM')
library('mice')
library('ggplot2')
library('reshape2')
library('corrplot')
library('scales')


# Install Train.csv
train = read.csv('/Users/Gabriella_Camara/Documents/NYDSA/Machine Learning/House Prices - Werner, Gabriella, Petronella/train.csv',
                 header = TRUE,
                 sep = ',')

# Convert Categorical variables to factors
train$MSSubClass  = as.factor(train$MSSubClass)
train$OverallCond_Fac = as.factor(train$OverallCond)
train$OverallQual_Fac = as.factor(train$OverallQual)
# Decided to keep OverallQuali & OverallCond as int (even though factors/ categorical) - in order to maintain the correlation relationship
# Maybe consider one as factor and one as numerical

# Seperating Categorical vs Numerical variables
split <- splitmix(train)
num_train <- split$X.quanti
cat_train <- split$X.quali

#### Data Structure
head(train)
str(train)
dim(train)

summary(num_train)
plot(num_train[1:10])
summary(cat_train)

# Dataframe with 1460 rows with 81 features (variables)
# Remember Id is counted as a feature (therefore 80 features excluding Id)

# Understanding missingness
colSums(sapply(train, is.na))
colSums(sapply(cat_train, is.na))
colSums(sapply(num_train, is.na))
# Categorical variables with largest # NAs is PoolQC, Alley, Fence (excl. MiscFeature)
# Numerical variables are LotFrontage, GarageYrBlt, MasVnrArea

# Graph of Missing Values - VIM Package
md.pattern(train)
aggr(train, prop = F, numbers = T)
matrixplot(train, interactive = F)
matrixplot(cat_train, interactive = F)


#### Histograms of Categorical Variables


#### SalePrice as a response variable
ggplot(train, aes(x = SalePrice)) +
  geom_histogram() +
  scale_x_continuous(breaks= seq(0, 800000, by=100000), labels = comma)

summary(train$SalePrice)
# Data is right skewed as most people could not 'afford' higher priced houses
# / higher priced houses are tougher to sell. 




#### Prices against Neighbourhood
# Count of Neighbourhoods
ggplot(cat_train, aes(x = Neighborhood)) + geom_histogram(stat = 'count') +
  theme(axis.text.x = element_text(angle = 90, hjust =1))

SP_mean = mean(train$SalePrice)

train %>% 
  select(Neighborhood, SalePrice) %>% 
  ggplot(aes(factor(Neighborhood), SalePrice)) + geom_boxplot() + 
  theme(axis.text.x = element_text(angle = 90, hjust =1)) + xlab('Neighborhoods') +
  geom_hline(yintercept=SP_mean, linetype="dashed", color = "red") 
# Can identify which neighbourhoods are the most pricy? 
# Worth comparing all variables to SalesPrice?

#### Correlations (Numeric variables)
# https://cran.r-project.org/web/packages/corrplot/vignettes/corrplot-intro.html
correlations <- cor(na.omit(num_train)) # Corr Matrix
# cor_sorted <- as.matrix(sort(correlations[,'SalePrice'], decreasing = TRUE))
row_indic <- apply(cor_sorted, 1, function(x) sum(x > 0.3 | x < -0.3) > 1)

correlations<- correlations[row_indic ,row_indic ]
corrplot(correlations, method="square")
# SalesPrice has the strongest correlation to OverallQual, GrLivArea, GarageCars, GarageArea, YearBuilt etc. 
# Surprisingly, not strongly correlated to OverallCond

# Seems slight negative correlation between SalesPrice & OverallCond, and OverallCond & YearBuilt
num_train %>% select(OverallCond, YearBuilt) %>%
  ggplot(aes(factor(OverallCond), YearBuilt)) + geom_boxplot() + xlab('Overall Condition')

num_train %>% select(OverallQual, YearBuilt) %>%
  ggplot(aes(factor(OverallQual), YearBuilt)) + geom_boxplot() + xlab('Overall Quality')

num_train %>% select(OverallCond, SalePrice) %>%
  ggplot(aes(factor(OverallCond), SalePrice)) + geom_boxplot() + xlab('Overall Condition')
# Surprisngly, houses with an overall condition on 5 showed higher prices than higher ranked houses. 
# Highest overall ocndition showed little/ no outliers. 

#### Important Numeric Varaibles (highest correlation to SalePrice)
correlations[, -1]

# Consider OverallQual 0.79, GrLivArea 0.71, GarageCars 0.64, GarageArea 0.62, TotalBsmtSF 0.61, X1stFlrSF 0.61
# 1 OverallQual
num_train %>% select(OverallQual, SalePrice) %>%
  ggplot(aes(factor(OverallQual), SalePrice)) + geom_boxplot() + xlab('Overall Quality')
# -- contrast to OverallCond to SalePrice

# 2 GrLivArea (portion of home above ground, not in basement)
num_train %>% select(GrLivArea, SalePrice) %>%
  ggplot(aes(factor(GrLivArea), log10(SalePrice))) + geom_point(col = 'blue') + xlab('Above Ground') +
  # scale_y_continuous(breaks= seq(0, 800000, by=100000), labels = comma) +
  geom_smooth(method = "lm", se=FALSE, color="black", aes(group=1))

# Hint of multicollinearity (GarageArea, GarageCars)
install.packages("GoodmanKruskal")
