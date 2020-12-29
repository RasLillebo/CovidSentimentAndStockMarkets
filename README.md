# Utilizing PCA on Covid-19- & Fama-French Data
In my preparation for my master thesis, I came across a dataset of covid-19-related sentiment scores for multiple countries. To get the data under my skin for the project to come, I decided to make this small exercise: I will use the covid-19 sentiment variables for the US, join it onto multiple Fama-french-variables and two stock indices; hereby creating a high-dimensional datasset... sort of (22 variables). - But that's enough for me to prove a point! :)
If you have taken a glance in my repositories, you will find that I am quite interested in machine learning. Therefore, I will use this dataset to utilize a simple PCA and find whether the top 3 Principle components are better predictors than the top 3 variables from the original dataset.

Now, the dataset consist of the following variables:
- Date
- Country
- Total Deaths
- Total Cases
- Total Recovered
- Daily Deaths
- Daily Cases
- Daily Recovered
- Panic Index
- Media Hype Index
- Fake News Index
- Sentiment Index
- Infodemic Index
- Media Coverage Index
- Dow Jones Industrial Average Adjusted closing price
- S&P500 Adjusted closing price
- Market Risk-free rate
- SMB
- HML
- RMW
- CMA
- Risk-free rate

My goal is to predict Dow Jones Industrial Average Closing price. I will only be using simple OLS as estimation method to keep it relatively simple.
Once the data has been cleared from NA & NAN's, I calculate the differenced variables to transform them into stationary processes. Otherwise, I would have regressed a time trend, which would overestimate the correlation between the variables. Once the data is stationary, I regress the dataset on the adjusted DOW price.

https://github.com/RasLillebo/UtilizingPCAonCovidAndFF/issues/2#issue-776079551

It is evident that of all the variables; CMA, Panic_index and HML are the 3 most relevant when considering the p-values. I will keep that in mind for later.
Now, I will be utilizing PCA to decrease the number of variables. But what is PCA?:

## PCA (Principle Component Analysis)
In short; Principle Component Analysis is a method to extract most of the variance in a dataset in a few 'Principle components'. This is done by creating othogonal vectors of the variables, and exploiting the eigenvalues and eigenvectors. The math isn't hard, but also not exactly straight forward if linear algebra seem foreign. If that is the case, I would suggest going to the YouTube channel 'StatQuest', and watch the walkthrough on PCA. Otherwise, if you are comfortable with math and linear algebra, I would go through chapter 10, page 378 in 'An Introduction to Statistical Learning' by Hastie & Tibshirani et al. 

## Back to the exercise
I use the following code to construct my principle components. It is evident that the first principle component (PC1) explains 55% of the variance in the data. Remember that the components are already sorted, so I know that PC1 is the principle components that explain most of the variance.

(Plot of PC1 and PC2 is coming soon)

Knowing this: I can now use my principle components in a regression, to try to predict the adjusted price of the DOW:

(Regression output coming soon)

Evidently, the principle components regression explain 70% of the variance of the adjusted price of DOW. But how about the original (significant) variables: Am I better off without the PC's? or have I created components that better explain the data?
To answer that, I also regress the significant original variables on the adjusted closing price of DOW, from which I get an r-squared of 68%.

(Regression outbut coming soon)

Now, plotting the predictions:

I Can thereby conclude that:
1. Principle component analysis can reduce the amount of variables 
2. A fixed amount of principle Components can actually explain more of the variance that an equal amount of regular variables. 

I hope you found this very simple exercise interesting. 

(Work in Progress)
