# CovidSentimentInScandinavia
In my preparation for my master thesis, I came across a dataset of covid-19-related sentiment scores for multiple countries. To get to data under my skin, I decided to make this small exercise: I will use the covid-19 sentiment variables for the US, join it onto multiple Fama-french-variables and two stock indices; hereby creating a high-dimensional datasset... sort of (22 variables). - But that's enough for me to prove a point! :)
If you have taken a glance in my repositories, you will find that I am quite interested in machine learning. Therefore, I will use this dataset to utilize a simple PCA and find whether the top 3 PC's are better predictors than the top 3 variables from the original dataset.

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
Once the data has been cleared from NA & NAN's, I proceed to regress my variables:

(PICTURE)

It is evident that the R-squared is almost 1.

(Work in Progress)
