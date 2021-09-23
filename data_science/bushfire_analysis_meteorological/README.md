# Bushfire Analysis using Meteorological Data
Bush fires are critical threats to nature and human lives causing enormous economical and ecological damages. 
In Australia, bush fires are serious environmental issues. In late 2019 and early 2020, Australia experienced 
devastating bush fires that burnt approximately 18.6 million hectares, destroying over 5000 houses and building 
and killing at least 34 people and around one billion animals (Calma, 2020). This has also caused significant 
environmental and ecological impacts as well as the Australian economy.

To prevent or mitigate such disasters, fast detection is important. This project aims to approach this problem by 
building regression models to predict the burned area using meteorological data. In building regression models, 
different models are compared and the best model is selected. Additionally, a subset of attributes that 
have a strong correlation to the burned area is identified as well.

The models are trained and tested using the data collected from the northeast region of Portugal that includes 
information related to fire occurrences, such as spatial location, date, the forest Fire Weather Index (FWI), weather
and the total burned area (Cortez & Morais, 2007).

## Preprocessing
Prior to modelling, the dataset is inspected and preprocessed. Upon inspection, the dataset contains both qualitative and quantitative variables. 
For the quantitative variables, the variables are transformed and standardised to improve modelling performance and qualitative variables are
dummy coded to produce n-1 number of binary variables. Then, 80:20 ratio is used to split the dataset into training and testing datasets.

## Feature Selection
In this project, three regression models; Stepwise Regression, Lasso Regression (L1 Regularisation) and Ridge Regression (L2 Regularisation) 
models are used to perform feature selection based on statistical significance.

## Modelling
### Stepwise Regression
The feature set is selected based on statistical performance of the regression such as Cp, BIC, adjusted R2 and RSS. 

<img src="https://github.com/TravisH0301/data_science_projects/blob/master/data_science/bushfire_analysis_meteorological/images/bushfire_stepwise1.png" width="500">

Based on the evaluation, 6 features are chosen. And the residuals of the regression is tested to ensure they behave like a normal distribution.

<img src="https://github.com/TravisH0301/data_science_projects/blob/master/data_science/bushfire_analysis_meteorological/images/bushfire_stepwise2.png" width="500">

### Lasso Regression
To determine the regularisation parameter, lambda, mean-squared error is plotted against lambda.

<img src="https://github.com/TravisH0301/data_science_projects/blob/master/data_science/bushfire_analysis_meteorological/images/bushfire_lasso1.png" width="500">

<img src="https://github.com/TravisH0301/data_science_projects/blob/master/data_science/bushfire_analysis_meteorological/images/bushfire_lasso2.png" width="500">

Based on regularisation, 24 out of 27 features are shruken to zero. 

### Ridge Regression
Similar regularisation approach was taken for the Ridge regression by determining the most efficient lambda.

<img src="https://github.com/TravisH0301/data_science_projects/blob/master/data_science/bushfire_analysis_meteorological/images/bushfire_ridge1.png" width="500">

<img src="https://github.com/TravisH0301/data_science_projects/blob/master/data_science/bushfire_analysis_meteorological/images/bushfire_ridge2.png" width="500">

Unlike the Lasso regularisation, all features are kept yet the coefficients of the insignificant features are penalised.

## Comparison
In comparison of the regression performance, the Lasso regression resulted in the lowest root squared mean error (RSME) and the selected features are 
Duff Moisture Code (DMC), Month December, Month March and Month September. 

These features also showed high correlations to the burned area both individually and as a group. This implies the importance of seasonal weather factor 
in predicting the bush fire in Portugal where the dataset is originated from.
