project ivy: House Prices (Kaggle) - EDA (Categorical)
================

Overview
--------

[House Prices: Advanced Regression Techniques](https://www.kaggle.com/c/house-prices-advanced-regression-techniques)

Now that we've had a look at the data, and dived into the numerical analysis. Let's take a deeper look into some of the categorical features.

Categorical variables
---------------------

The transformation of the categorical variables are enclosed in the **transform.R source** code. All Quality variables which had the same ordered levels that ranked the quality of the feature from None to Excellent were label encoded (maped to an integer representation) that reflected the order of the level. 0 = None, incrementally until 5 = Excellent. Additionally, there were varaibles that, by nature & definition, were ordered. These variables were also label encoded.

After considering the NA values in the dataset, we also came across a feature that was overwhlemingly populated by a single level. The Utilities variable, as we'll see displayed all house, except one, having all public utilities. Thus, this variable doesn't offer much enrichment for Preditcion & therefore removed. (Removed in feature\_eng.R code).

    ## 
    ## AllPub NoSeWa 
    ##   2916      1

Visualization of Categorical Variables (Boxplot)
------------------------------------------------

Let's visualize the boxplot of the categorical variables.

    ## Loading required package: grid

![](exploratory_cat_data_analysis_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-2-1.png)

From the above graphs, there are definitely features that have similar shapes. However, there are also features that display significant variation and will be explored in more detail.

When reading **data\_descr.txt** it is clear that some variables are highly correlated purely by definition. Let's explore those in detail and decide which to keep.

Highly correlated by definition, results in the following 'grouped' variables: *Property Variables: Street, Alley, LotShape, LandContour, LandSlope, LotConfig *Dwelling/ Living Variables: BldgType, HouseStyle, MSSubClass, MSZoning, Neighborhood *Utility: Utilities, Electrical *Overall Quality & Condition: OverallQual, OverallCond, Functional *Material of House: OverallQual, RoofMatl, Exterior1st, Exterior2nd, MasVnrType, ExterQual, ExterCond, Foundation *Roof: RoofStyle, RoofMatl *Basement: BsmtQual, BsmtCond, BsmtExposure, BsmtFinType1, BsmtFinType2 *Heating: Heating, HeatingQC, CentralAir, FireplaceQu *Garage: GarageType, GarageFinish, GarageQual, GarageCond, PavedDrive *Misc: PoolQC, Fence, MiscFeature, KitchenQual \*Nature of Sale: SaleType, SaleCondition

Correlation of Label Encoded Features
-------------------------------------

Once variables had been label encoded, we could develop a Correlation Matrix to display the relationship between these variables.

    ##        set_id            Id    MSSubClass      MSZoning   LotFrontage 
    ##             0             0             0             4           486 
    ##       LotArea        Street         Alley      LotShape   LandContour 
    ##             0             0             0             0             0 
    ##     Utilities     LotConfig     LandSlope  Neighborhood    Condition1 
    ##             2             0             0             0             0 
    ##    Condition2      BldgType    HouseStyle   OverallQual   OverallCond 
    ##             0             0             0             0             0 
    ##     YearBuilt  YearRemodAdd     RoofStyle      RoofMatl   Exterior1st 
    ##             0             0             0             0             1 
    ##   Exterior2nd    MasVnrType    MasVnrArea     ExterQual     ExterCond 
    ##             1            24            23             0             0 
    ##    Foundation      BsmtQual      BsmtCond  BsmtExposure  BsmtFinType1 
    ##             0             0             0             0             0 
    ##    BsmtFinSF1  BsmtFinType2    BsmtFinSF2     BsmtUnfSF   TotalBsmtSF 
    ##             1             0             1             1             1 
    ##       Heating     HeatingQC    CentralAir    Electrical    x_1stFlrSF 
    ##             0             0             0             1             0 
    ##    x_2ndFlrSF  LowQualFinSF     GrLivArea  BsmtFullBath  BsmtHalfBath 
    ##             0             0             0             2             2 
    ##      FullBath      HalfBath  BedroomAbvGr  KitchenAbvGr   KitchenQual 
    ##             0             0             0             0             0 
    ##  TotRmsAbvGrd    Functional    Fireplaces   FireplaceQu    GarageType 
    ##             0             2             0             0             0 
    ##   GarageYrBlt  GarageFinish    GarageCars    GarageArea    GarageQual 
    ##           159             0             1             1             0 
    ##    GarageCond    PavedDrive    WoodDeckSF   OpenPorchSF EnclosedPorch 
    ##             0             0             0             0             0 
    ##   x_3SsnPorch   ScreenPorch      PoolArea        PoolQC         Fence 
    ##             0             0             0             0             0 
    ##   MiscFeature       MiscVal        MoSold        YrSold      SaleType 
    ##             0             0             0             0             1 
    ## SaleCondition     SalePrice  SalePriceLog 
    ##             0          1459          1459

    ## [1] 1460   21

![](exploratory_cat_data_analysis_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-3-1.png)

From the above correlations, we can see a number of features which are strongly correlated to eachother. It seems to be a trend (intuitively) that the Quality and Condition of a feature show strong relationships. On top of that, we can see that BsmtQual had a strong relationship to KitchenQual, and ExterQual show significant relationships to BsmtQual, HeatingQC, KitchenQual, GarageFinish. We'll explore these relationships below.

Additionally, we can see that the features that contribute to SalePrice significantly are: GarageFinsih, FireplaceQC, KitchenQual, BsmtQual, ExterQual, (HeatingQC)

Let's visualize these relationships:

    ## 
    ## Attaching package: 'gridExtra'

    ## The following object is masked from 'package:dplyr':
    ## 
    ##     combine

![](exploratory_cat_data_analysis_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-4-1.png)

From the above graphs, we can see a very clear and strong postive linear relationship between the feature and SalesPrice.

GoodmanKruskal Method
---------------------

To further explore the relationships between 2 categorical features, we will looks at the GoodmanKruskal tau values, which describe both the forward & backward association between these 2 variables. [GoodmanKruskal Tau](https://cran.r-project.org/web/packages/GoodmanKruskal/vignettes/GoodmanKruskal.html)

    ## Loading required package: GoodmanKruskal

    ##         xName          yName Nx Ny tauxy tauyx
    ## 1 df$BsmtQual df$KitchenQual  5  5 0.252 0.217

From the above table, we can see that there is an equal predictive relationship between these two features. But seems to hint that knowledge of the BsmtQual is predictive (more so) of the KitchenQual - however, not significantly enough to throw away either.

    ##          xName       yName Nx Ny tauxy tauyx
    ## 1 df$ExterQual df$BsmtQual  4  5 0.267 0.354

    ##          xName        yName Nx Ny tauxy tauyx
    ## 1 df$ExterQual df$HeatingQC  4  5 0.193 0.255

    ##          xName          yName Nx Ny tauxy tauyx
    ## 1 df$ExterQual df$KitchenQual  4  5 0.415 0.453

    ##          xName           yName Nx Ny tauxy tauyx
    ## 1 df$ExterQual df$GarageFinish  4  4 0.136 0.217

A surprising relationship is that of ExterQual to KitchenQual.

Feature Importance: Random Forest
---------------------------------

Let's look at a Random Forest model that will highlight the important features that form part of our dataset, and potentially inform our prediction models.

    ## randomForest 4.6-14

    ## Type rfNews() to see new features/changes/bug fixes.

    ## 
    ## Attaching package: 'randomForest'

    ## The following object is masked from 'package:gridExtra':
    ## 
    ##     combine

    ## The following object is masked from 'package:dplyr':
    ## 
    ##     combine

    ## The following object is masked from 'package:ggplot2':
    ## 
    ##     margin

![](exploratory_cat_data_analysis_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-7-1.png)

    ##                  %IncMSE IncNodePurity
    ## set_id         0.0000000  0.000000e+00
    ## Id            -0.2295387  1.548827e-01
    ## MSSubClass    24.7006491  9.238635e-01
    ## MSZoning       9.1805534  2.176460e-01
    ## LotArea       19.1723641  5.317503e-01
    ## Street        -1.4103309  3.773289e-03
    ## Alley          1.6955427  2.742265e-02
    ## LotShape       5.4542197  4.069892e-02
    ## LandContour    3.6935283  5.962471e-02
    ## Utilities      0.0000000  6.075822e-04
    ## LotConfig      0.8003341  4.204032e-02
    ## LandSlope      3.1243847  2.528968e-02
    ## Neighborhood  33.0162194  6.704076e+00
    ## Condition1     2.2524630  5.785015e-02
    ## Condition2    -0.8467243  6.225906e-03
    ## BldgType       7.1014352  3.958928e-02
    ## HouseStyle    10.2909754  9.626345e-02
    ## OverallQual   26.9551421  1.048070e+01
    ## OverallCond   16.2071488  3.262616e-01
    ## YearBuilt     10.8530523  1.162783e+00
    ## YearRemodAdd  12.6213490  3.499204e-01
    ## RoofStyle      2.2238683  4.699960e-02
    ## RoofMatl       0.1366940  1.433382e-02
    ## Exterior1st    9.0140572  3.167001e-01
    ## Exterior2nd   10.2153710  3.226340e-01
    ## ExterQual     11.6889162  3.208737e+00
    ## ExterCond      2.5335546  6.906112e-02
    ## Foundation     5.8796696  6.053008e-02
    ## BsmtQual       7.5697608  7.097205e-01
    ## BsmtCond       7.7528229  7.224474e-02
    ## BsmtExposure   8.7367669  8.061753e-02
    ## BsmtFinType1  14.0256362  1.685725e-01
    ## BsmtFinSF1    22.4468990  6.231602e-01
    ## BsmtFinType2   0.6739879  2.402135e-02
    ## BsmtFinSF2     2.0753534  2.253327e-02
    ## BsmtUnfSF      9.7344819  2.036915e-01
    ## TotalBsmtSF   27.2735855  1.446216e+00
    ## Heating       -2.6772748  2.041336e-02
    ## HeatingQC      3.4315956  7.941516e-02
    ## CentralAir     6.7518543  3.756008e-01
    ## x_1stFlrSF    22.7595166  1.348306e+00
    ## x_2ndFlrSF    17.3880317  4.973422e-01
    ## LowQualFinSF  -0.3463479  1.068361e-02
    ## GrLivArea     38.1029519  4.940502e+00
    ## BsmtFullBath  10.2791991  6.127619e-02
    ## BsmtHalfBath   1.7554944  9.573142e-03
    ## FullBath       8.5767149  3.843413e-01
    ## HalfBath       8.5735222  4.737874e-02
    ## BedroomAbvGr   9.2348528  1.090029e-01
    ## KitchenAbvGr   4.1817714  1.619542e-02
    ## KitchenQual    8.9223292  1.258524e+00
    ## TotRmsAbvGrd  12.0293521  2.661983e-01
    ## Functional     2.5248404  4.984730e-02
    ## Fireplaces     9.0317967  2.700250e-01
    ## FireplaceQu   12.4446886  5.011678e-01
    ## GarageType    12.1129917  3.752428e-01
    ## GarageFinish   8.1402466  2.763453e-01
    ## GarageCars    15.9537547  1.491877e+00
    ## GarageArea    18.6688848  1.471223e+00
    ## GarageQual     4.8809810  8.580358e-02
    ## GarageCond     3.8531678  9.369903e-02
    ## PavedDrive     2.8542121  3.801349e-02
    ## WoodDeckSF     6.3921538  1.127992e-01
    ## OpenPorchSF    9.2465319  1.881850e-01
    ## EnclosedPorch  1.7395513  6.111238e-02
    ## x_3SsnPorch    1.3082772  5.134175e-03
    ## ScreenPorch    4.3925704  2.785632e-02
    ## PoolArea       1.0010015  2.695676e-03
    ## PoolQC        -1.0505044  1.483834e-03
    ## Fence          0.3172713  2.780403e-02
    ## MiscFeature   -0.8857804  6.893715e-03
    ## MiscVal        2.0683666  6.846851e-03
    ## MoSold         2.1077085  1.321873e-01
    ## YrSold         2.8091886  6.365697e-02
    ## SaleType       1.8484367  3.785968e-02
    ## SaleCondition -0.2345705  1.267182e-01

Considering non-ordinal categorical features
--------------------------------------------

From the list of of non-ordinal features, there are a couple that stand out and are worth exploring. (It's more art than science). Additionally, the 2 non-ordered categorical features highlighted from the RandomForest model that scored the highest value of importance were Neighborhood and MSSubClass - let's take a closer look.

    ## Joining, by = "Neighborhood"

    ##             xName         yName Nx Ny tauxy tauyx
    ## 1 df$Neighborhood df$MSSubClass 25 16 0.212 0.086

    ##             xName       yName Nx Ny tauxy tauyx
    ## 1 df$Neighborhood df$MSZoning 25  6 0.657 0.101

From the above we can see that knowledge of Neighborhood is predictive of MSSubClass, and signifanctly more of MSZoning.

Neighborhood
------------

One of the features I'm particularly interested in is the Neighborhood. From intuition, I know that neighborhood plays a pretty important role when someone is considering buying a house. More favourable Neighborhoods are likely to have higher SalePrices. Conversely, more popular neighborhoods could also mean cheaper SalesPrices.

![](exploratory_cat_data_analysis_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-10-1.png)

From the above graph, we can see that NAmes and CollgCr are the most 'popular' neighborhoods (higher count). NAmes seems to have some variance that can't be ignored. Popularity could be dependant on many things, firstly it could be the price. Ie. Houses which are more affordable are more popular, additionally it could be based on the actual area of the neighborhood.

Let's sort the neighborhood by highest median price. Reason to use median is to be less influenced by outliers of which there appear to be many in Neighborhood. In doing so, we hope to uncover some binning opportunities due to the fact that there are so many levels in Neighborhood.

![](exploratory_cat_data_analysis_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-11-1.png)

From the above graph, we can see that we could explore potential binning of neighborhood. We've binned Neighborhood into 5 respective buckets, based on the median SalesPrice - see the results of the feature below.

    ## 
    ##    A    B    C    D    E 
    ##  593  783  114 1141  288

MSSubClass
----------

Let's explore MSSubClass to determine if we unlock anything interesting.

![](exploratory_cat_data_analysis_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-13-1.png)

Comparing to Mean Price

![](exploratory_cat_data_analysis_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-14-1.png)

Similarily, let's bin MSSubClass.

Top MSSubClasses = 2-STORY 1946 & NEWER 1-STORY PUD (Planned Unit Development) - 1946 & NEWER 2-1/2 STORY ALL AGES 1-STORY 1946 & NEWER ALL STYLES

Average MSSubClasses = SPLIT OR MULTI-LEVEL 2-STORY 1945 & OLDER 1-STORY W/FINISHED ATTIC ALL AGES SPLIT FOYER 1-1/2 STORY FINISHED ALL AGES 2-STORY PUD - 1946 & NEWER DUPLEX - ALL STYLES AND AGES 2 FAMILY CONVERSION - ALL STYLES AND AGES

Bottom MSSubClasses = 1-1/2 STORY - UNFINISHED ALL AGES PUD - MULTILEVEL - INCL SPLIT LEV/FOYER 1-STORY 1945 & OLDER

    ## 
    ##    0    1    2 
    ##  174  886 1859
