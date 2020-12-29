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
```
Diff_Data = Data-lag(Data, 1)
Reg_diff = lm(Diff_Data$Adjusted.x~., data=Diff_Data)
summary(Reg_diff)
```

<img width="372" alt="Picture1 PCA Covid" src="https://user-images.githubusercontent.com/69420936/103313096-51b21900-4a1f-11eb-9b86-47258e0ee18e.png">

It is evident that of all the variables; CMA, Panic_index and HML are the 3 most relevant when considering the p-values. I will keep that in mind for later.
Now, I will be utilizing PCA to decrease the number of variables. But what is PCA?:

## PCA (Principle Component Analysis)
In short; Principle Component Analysis is a method to extract most of the variance in a dataset in a few 'Principle components'. This is done by creating othogonal vectors of the variables, and exploiting the eigenvalues and eigenvectors. The math isn't hard, but also not exactly straight forward if linear algebra seem foreign. If that is the case, I would suggest going to the YouTube channel 'StatQuest', and watch the walkthrough on PCA. Otherwise, if you are comfortable with math and linear algebra, I would go through chapter 10, page 378 in 'An Introduction to Statistical Learning' by Hastie & Tibshirani et al. 

## Back to the exercise
I use the following code to construct my principle components. It is evident that the first principle component (PC1) explains 55% of the variance in the data. Remember that the components are already sorted, so I know that PC1 is the principle components that explain most of the variance.
```
#Too many variables that are similar in many ways: Use PCA
PCA <- prcomp(Data[, 2:22], center=FALSE, scale=TRUE)
summary(PCA)

# Plotting the PC's
var_explained <- PCA$sdev^2/sum(PCA$sdev^2)
var_explained[1:5]

PCA$x %>% 
  as.data.frame %>%
  ggplot(aes(x=PC1,y=PC2)) + geom_point(size=2) +
  theme_bw(base_size=15) + 
  labs(x=paste0("PC1: ",round(var_explained[1]*100,1),"%"),
       y=paste0("PC2: ",round(var_explained[2]*100,1),"%")) +
  theme(legend.position="top")
```
![Picture2 PCA Covid](https://user-images.githubusercontent.com/69420936/103313670-144e8b00-4a21-11eb-9413-a915d1a3a07e.png)

Knowing this: I can now use my principle components in a regression, to try to predict the adjusted price of the DOW:
```
# Regress the PC's that explains most of the variance
Data2 <- cbind(Data, PCA$x[,1:5])

Reg_PCA = lm(Data2$Adjusted.x~PC1+PC2+PC3+PC4+PC5, data=Data2)
summary(Reg_PCA)
```
<img width="366" alt="Picture3 PCA Covid" src="https://user-images.githubusercontent.com/69420936/103313816-82934d80-4a21-11eb-99d7-c0ffff692a1f.png">


Evidently, the principle components regression explain 66.7% of the variance of the adjusted price of DOW. But how about the original (significant) variables: Am I better off without the PC's? or have I created components that better explain the data?
To answer that, I also regress the significant original variables on the adjusted closing price of DOW, from which I get an r-squared of 69.49%.

```
# Split data in 25% test 75% training
index <- sample(1:nrow(Data2),round(0.75*nrow(Data2)))
Train <- Data2[index,]                      #Training set
Test <- Data2[-index,]                      #Test set

# Utilizing the PC's model
PCA.fit <- lm(Adjusted.x~ PC1 + PC2 + PC3, data=Train)
summary(PCA.fit)                             #Summarize Model
pr.PCA <- predict(PCA.fit,Test)    

```
<img width="391" alt="Picture4 PCA Covid" src="https://user-images.githubusercontent.com/69420936/103314023-106f3880-4a22-11eb-8047-25ce4e4d084f.png">

Now, plotting the predictions:
```
windows()
plot(Test$created_at, Test$Adjusted.x, type="l", cex=4, main = "Predicting the Price of DOW",
     xlab="Time (2020)", ylab="DOW Price") #Plot simple test set variable
#Forecasting predictioin
lines(Test$created_at, pr.PCA, col="red") #Plotting forecast
lines(Test$created_at, pr.Reg, col="blue")
legend("bottomleft", legend=c("PCA", "Reg"),
       col=c("red", "blue"), lty=1, cex=1)
```
![Picture5 PCA Covid](https://user-images.githubusercontent.com/69420936/103314905-6513b300-4a24-11eb-8e83-fe10ac332509.png)

I Can thereby conclude that:
1. Principle component analysis can reduce the amount of variables 
2. A fixed amount of principle Components can actually explain more of the variance that an equal amount of regular variables. 

I hope you found this very simple exercise interesting. 
