project ivy: House Prices (Kaggle) - EDA (Categorical)
================

Overview
--------

[House Prices: Advanced Regression Techniques](https://www.kaggle.com/c/house-prices-advanced-regression-techniques)

Now that we've had a look at the data, and dived into the numerical analysis. Let's take a deeper look into some of the categorical features.

Categorical variables
---------------------

The transformation of the categorical varibles are enclosed in the **transform.R source** code. All Quality variables which had the same ordered levels that ranked the quality of the feature from None to Excellent were label encoded (maped to an integer representation) that reflected the order of the level. 0 = None, incrementally until 5 = Excellent. Additionally, there were varaibles that, by nature & definition, were ordered. These variables were also label encoded.

After considering the NA values in the dataset, we also came across a feature that was overwhlemingly populated by a single level. The Utilities variable, as we'll see displayed all house, except one, having all public utilities. Thus, this variable doesn't offer much enrichment for Preditcion & therefore removed. (Removed in feature\_eng.R code).

    ## 
    ## AllPub NoSeWa 
    ##   2916      1

Visualization of Categorical Varibles (Boxplot)
-----------------------------------------------

Let's visualize the boxplot of the categorical variables.

    ## Loading required package: grid

![](exploratory_cat_data_analysis_files/figure-markdown_github/unnamed-chunk-2-1.png)

From the above graphs, there are definitely features that have similar shapes. However, there are also features that display significant variation and will be explored in more detail.

When reading **data\_descr.txt** it is clear that some variables are highly correlated purely by definition. Let's explore those in detail and decide which to keep.

Highly correlated by definition, results in the following 'grouped' variables: \* Property Variables: Street, Alley, LotShape, LandContour, LandSlope, LotConfig \* Dwelling/ Living Variables: BldgType, HouseStyle, MSSubClass, MSZoning, Neighborhood \* Utility: Utilities, Electrical \* Overall Quality & Condition: OverallQual, OverallCond, Functional \* Material of House: OverallQual, RoofMatl, Exterior1st, Exterior2nd, MasVnrType, ExterQual, ExterCond, Foundation \* Roof: RoofStyle, RoofMatl \* Basement: BsmtQual, BsmtCond, BsmtExposure, BsmtFinType1, BsmtFinType2 \* Heating: Heating, HeatingQC, CentralAir, FireplaceQu \* Garage: GarageType, GarageFinish, GarageQual, GarageCond, PavedDrive \* Misc: PoolQC, Fence, MiscFeature, KitchenQual \* Nature of Sale: SaleType, SaleCondition

Correlation of Label Encoded Features
-------------------------------------

Once varaiables had been label encoded, we could develop a Correlation Matrix to display the relationship between these variables.

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

![](exploratory_cat_data_analysis_files/figure-markdown_github/unnamed-chunk-3-1.png)

From the above correlations, we can see a number of features which are strongly correlated to eachother. It seems to be a trend (intuitively) that the Quality and Condition of a feature show strong relationships. On top of that, we can see that BsmtQual had a strong relationship to KitchenQual, and ExterQual show significant relationships to BsmtQual, HeatingQC, KitchenQual, GarageFinish. We'll explore these relationships below.

Additionally, we can see that the features that contribute to SalePrice significantly are: GarageFinsih, FireplaceQC, KitchenQual, BsmtQual, ExterQual, (HeatingQC)

Let's visualize these relationships:

    ## 
    ## Attaching package: 'gridExtra'

    ## The following object is masked from 'package:dplyr':
    ## 
    ##     combine

![](exploratory_cat_data_analysis_files/figure-markdown_github/unnamed-chunk-4-1.png)

From the above graphs, we can see a very clear and strong postive linear relationship between the feature and SalesPrice.

GoodmanKruskal Method
---------------------

To further explore the relationships between 2 categorical features, we will looks at the GoodmanKruskal tau values, which describe both the forward & backward association between these 2 variables. [GoodmanKruskal Tau](https://cran.r-project.org/web/packages/GoodmanKruskal/vignettes/GoodmanKruskal.html)

    ## Loading required package: GoodmanKruskal

    ##         xName          yName Nx Ny tauxy tauyx
    ## 1 df$BsmtQual df$KitchenQual  5  5 0.252 0.217

From the above table, we can see that there is an equal predictive relationship between these to features. But seems to hint that knowledge of the BsmtQual is predictive (more so) of the KitchenQual - however, not significantly enough to throw away either.

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

Let's look at a Random Forest model that will highlight the importnat features taht form part of our dataset, and potentially inform our prediction models.

    ## randomForest 4.6-12

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

![](exploratory_cat_data_analysis_files/figure-markdown_github/unnamed-chunk-7-1.png)

    ##                  %IncMSE IncNodePurity
    ## set_id         0.0000000  0.000000e+00
    ## Id            -3.1998269  1.539335e-01
    ## MSSubClass    25.2818078  9.575999e-01
    ## MSZoning       7.3779648  2.015324e-01
    ## LotArea       16.8485023  5.270363e-01
    ## Street        -0.1417445  3.034545e-03
    ## Alley          1.0099072  2.530234e-02
    ## LotShape       4.2051144  4.250637e-02
    ## LandContour    3.5905865  4.865746e-02
    ## Utilities      0.0000000  7.620959e-05
    ## LotConfig      0.7733765  4.500417e-02
    ## LandSlope      3.0722900  2.380855e-02
    ## Neighborhood  33.5387965  6.043275e+00
    ## Condition1     1.3521792  5.921048e-02
    ## Condition2    -1.8089661  5.282765e-03
    ## BldgType       5.1989742  3.639135e-02
    ## HouseStyle     9.5126045  1.027178e-01
    ## OverallQual   25.4902774  9.468594e+00
    ## OverallCond   12.1645849  3.057212e-01
    ## YearBuilt     10.4193034  1.329869e+00
    ## YearRemodAdd  13.8921416  3.270326e-01
    ## RoofStyle      4.7264317  4.399700e-02
    ## RoofMatl      -1.0818364  1.158568e-02
    ## Exterior1st   10.5750154  3.113297e-01
    ## Exterior2nd   10.8814955  3.234202e-01
    ## ExterQual     12.2109684  3.438109e+00
    ## ExterCond      1.6275814  6.928481e-02
    ## Foundation     4.2013747  1.373012e-01
    ## BsmtQual       7.5507319  8.213978e-01
    ## BsmtCond       7.4539367  7.613410e-02
    ## BsmtExposure   8.1729894  7.334197e-02
    ## BsmtFinType1  13.6084328  1.466863e-01
    ## BsmtFinSF1    20.6977131  6.387216e-01
    ## BsmtFinType2   0.7154489  2.808221e-02
    ## BsmtFinSF2    -0.1261153  2.164319e-02
    ## BsmtUnfSF      8.2819855  1.978614e-01
    ## TotalBsmtSF   24.9647928  1.487479e+00
    ## Heating       -1.3910126  1.807560e-02
    ## HeatingQC      6.3755307  7.962922e-02
    ## CentralAir     7.6118287  3.529941e-01
    ## x_1stFlrSF    25.5348777  1.405099e+00
    ## x_2ndFlrSF    17.4078308  5.214011e-01
    ## LowQualFinSF  -0.3633982  8.676180e-03
    ## GrLivArea     33.4175965  5.136228e+00
    ## BsmtFullBath   8.9385243  6.515627e-02
    ## BsmtHalfBath   0.1444322  9.021967e-03
    ## FullBath       8.7722802  6.254118e-01
    ## HalfBath       6.5820213  4.182964e-02
    ## BedroomAbvGr   8.5102546  1.150008e-01
    ## KitchenAbvGr   3.6884119  2.104526e-02
    ## KitchenQual    9.5154799  1.657880e+00
    ## TotRmsAbvGrd  11.2923105  2.422569e-01
    ## Functional     1.4504506  4.999354e-02
    ## Fireplaces     9.4080826  2.737999e-01
    ## FireplaceQu   12.7584899  5.346423e-01
    ## GarageType     9.0630950  4.240587e-01
    ## GarageFinish   7.6363639  3.448989e-01
    ## GarageCars    13.9047968  1.613512e+00
    ## GarageArea    19.6843393  1.345791e+00
    ## GarageQual     5.6430140  8.135672e-02
    ## GarageCond     3.0679527  9.639585e-02
    ## PavedDrive     0.7817286  4.779045e-02
    ## WoodDeckSF     6.4346986  1.083237e-01
    ## OpenPorchSF    8.0461485  1.901639e-01
    ## EnclosedPorch  1.7686782  6.199440e-02
    ## x_3SsnPorch   -0.8099499  5.616065e-03
    ## ScreenPorch    3.0132832  2.573014e-02
    ## PoolArea      -1.5929528  4.492253e-03
    ## PoolQC         1.2952494  2.380775e-03
    ## Fence          1.5945421  3.182652e-02
    ## MiscFeature   -0.2000814  7.664173e-03
    ## MiscVal        1.0966673  8.898390e-03
    ## MoSold         0.8437230  1.297192e-01
    ## YrSold         0.6353292  6.436661e-02
    ## SaleType       1.2629704  3.838760e-02
    ## SaleCondition  0.8228356  1.256077e-01

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

![](exploratory_cat_data_analysis_files/figure-markdown_github/unnamed-chunk-10-1.png) From the above graph, we can see that NAmes and CollgCr are the most 'popular' neighborhoods (higher count). NAmes seems to have some variance that can't be ignored. Popularity could be dependant on many things, firstly it could be the price. Ie. Houses which are more affordable are more popular, additionally it could be based on the actual area of the neighborhood.

Let's sort the neighborhood by highest median price. Reason to use median is to be less influenced by outliers of which there appear to be many in Neighborhood. In doing so, we hope to uncover some binning opportunities due to the fact that there are so many levels in Neighborhood.

![](exploratory_cat_data_analysis_files/figure-markdown_github/unnamed-chunk-11-1.png)

From the above graph, we can see that we could explore potential binning of neighborhood. We've binned Neighborhood into 5 respective buckets, based on the median SalesPrice - see the results of the feature below.

    ## 
    ##    A    B    C    D    E 
    ##  593  783  114 1141  288

MSSubClass
----------

Let's explore MSSubClass to determine if we unlock anything interesting.

![](exploratory_cat_data_analysis_files/figure-markdown_github/unnamed-chunk-13-1.png) Comparing to Mean Price

![](exploratory_cat_data_analysis_files/figure-markdown_github/unnamed-chunk-14-1.png) Similarily, let's bin MSSubClass.

Top MSSubClasses = 2-STORY 1946 & NEWER 1-STORY PUD (Planned Unit Development) - 1946 & NEWER 2-1/2 STORY ALL AGES 1-STORY 1946 & NEWER ALL STYLES

Average MSSubClasses = SPLIT OR MULTI-LEVEL 2-STORY 1945 & OLDER 1-STORY W/FINISHED ATTIC ALL AGES SPLIT FOYER 1-1/2 STORY FINISHED ALL AGES 2-STORY PUD - 1946 & NEWER DUPLEX - ALL STYLES AND AGES 2 FAMILY CONVERSION - ALL STYLES AND AGES

Bottom MSSubClasses = 1-1/2 STORY - UNFINISHED ALL AGES PUD - MULTILEVEL - INCL SPLIT LEV/FOYER 1-STORY 1945 & OLDER

    ## 
    ##    0    1    2 
    ##  174  886 1859
