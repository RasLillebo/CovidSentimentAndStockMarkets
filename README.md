# CovidSentimentInScandinavia
In my preparation for my master thesis, I came across a dataset of covid-19-related sentiment scores for Scandinavia (Denmark, Sweden, Norway, Finland).
If you have taken a glance in my repositories, you will find that I am quite interested in sentiment analysis. I also used the dataset in my ecommerce-job, where I analysed the correlation between covid-sentiment and online purchases: I will post a simulated study of that later.

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

Of these variables, I will likely only be using a handful:My goal is to map the correlation between the variables and select af few noticable ones. I will then be using these select variables to forecast the four indices of the the specific country, and check which country specific stock index is most affected by these sentiment variables. In the forecast I will use a simply rolling regression, but this is subject to change.

(Work in Progress)
