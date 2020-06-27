# Twitter Gender Classification
For this project, twitter author gender classifiers are built using statistical models. 3600 Twitter posts are used to train and validate models and additional 500 posts are used for final classification using the models with superior performances.

Prior to modelling the datasets are firstly pre-processed and features are generated using TF-IDF vectoriser. Then, five classifiers of Logistic Regression, Bernoulli Naive Bayes, Linear SVC, Random Forest and XGBoost are compared using cross validation. The top three models of Logistic Regression, Linear SVC and XGBoost are selected to be tuned.

And these optimised models are then used to make classification on the 500 test Twitter posts.

_This project is collaborated with @JeheeHan._

## Most Common Words from Males
<p align="center">
<img src="https://github.com/TravisH0301/data_science_projects/blob/master/twitter_gender_classification/images/common2.png" with="500">
</p>

## Most Common Words from Females
<p align="center">
<img src="https://github.com/TravisH0301/data_science_projects/blob/master/twitter_gender_classification/images/common3.png" with="500">
</p>

## Model Comparison via Cross Validation
||Logistic Regression|Bernoulli NB|Linear SVC|Random Forest|XGBoost|
|-|-|-|-|-|-|
|Avg. CV Accuracy|78%|75%|80%|66%|73%|

## Final Classification on Test Dataset
||Logistic Regression|Linear SVC|XGBoost|
|-|-|-|-|
|Optimised Accuracy|81.6%|81.4%|74%|
