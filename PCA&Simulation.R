#  Covid Sentiment I Scandinavia 
library(quantmod)
library(readr)
library(dplyr)
library(ggplot2)

Covid_19_US <- read_excel("C:/Users/rasmu/OneDrive/Skrivebord/Covid-19 US.xlsx", 
                          col_types = c("text", "text", "text", 
                                        "numeric", "numeric", "numeric", 
                                        "numeric", "numeric", "numeric", 
                                        "numeric", "numeric", "numeric", 
                                        "numeric", "numeric", "numeric"))


Covid_19_US$TIMESTAMP_UTC <- as.Date(Covid_19_US$TIMESTAMP_UTC, "%Y-%m-%d")
MIN = min(Covid_19_US$TIMESTAMP_UTC)
MAX = max(Covid_19_US$TIMESTAMP_UTC)

FF<- read_csv("C:/Users/rasmu/OneDrive/F-F_Research_Data_5_Factors_2x3_daily.CSV" , skip = 3)
FF <- transform(FF, x = as.Date(as.character(X1), "%Y%m%d"))

getSymbols("DOW", from=MIN, to=MAX, by="days", src="yahoo")
getSymbols("SPY", from=MIN, to=MAX, by="days", src="yahoo")

DJI_data <- data.frame(DJI$DJI.Close, DJI$DJI.Volume, DJI$DJI.Adjusted, index(DJI))
SPY_data <- data.frame(SPY$SPY.Close, SPY$SPY.Volume, SPY$SPY.Adjusted, index(SPY))
names(DJI_data) <- c("close", "Volume", "Adjusted", "created_at")
names(SPY_data) <- c("close", "Volume", "Adjusted", "created_at")
names(FF) <- c("X1", "MKT.RF", "SMB", "HML", "RMW", "CMA", "RF", "created_at")
names(Covid_19_US) <- c("created_at", "CountryCode", "CountryName", "Total_cases",
                        "Daily_cases", "Total_recovered", "Daily_recovered",
                        "Total_deaths", "Daily_deaths", "Panic_index", "Media_hype_index",
                        "Fake_news_index", "sentiment_index", "Infordemic_index", "Media_coverage_index" )
Data <- left_join(Covid_19_US, DJI_data, by="created_at")
Data <- left_join(Data, SPY_data, by="created_at")
Data <- left_join(Data, FF,  by="created_at")
Data <- na.omit(Data)
Data$CountryCode = Data$CountryName= Data$Volume.x = Data$close.x = Data$Volume.y = Data$close.y = NULL

# Regressing over a time trend
Reg= lm(Data$Adjusted.x~., data = Data)
summary(Reg)

# Introducing Time Series Environment 
# Need to difference the data so we don't estimate a trend (Make the data stationary)

Diff_Data = Data-lag(Data, 1)
Reg_diff = lm(Diff_Data$Adjusted.x~., data=Diff_Data)
summary(Reg_diff)

#Too many variables that are similar in many ways: Use PCA
PCA <- prcomp(Data[, 2:22], center=FALSE, scale=TRUE)
summary(PCA)

# 45.81% of the variance is explained by PC1
# 33.42% of the variance is explained by PC2


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

# Regress the two PC's that explains most of the variance
Data2 <- cbind(Data, PCA$x[,1:5])

Reg_PCA = lm(Data2$Adjusted.x~PC1+PC2+PC3+PC4+PC5, data=Data2)
summary(Reg_PCA)

# Split data in 25% test 75% training
index <- sample(1:nrow(Data2),round(0.75*nrow(Data2)))
Train <- Data2[index,]                      #Training set
Test <- Data2[-index,]                      #Test set

# Utilizing the PC's model
PCA.fit <- lm(Adjusted.x~ PC1 + PC2 + PC3, data=Train)
summary(PCA.fit)                             #Summarize Model
pr.PCA <- predict(PCA.fit,Test)              #Predicting HAR model
MSE.PCA <- sum((pr.PCA - Test$Adjusted.x)^2)/nrow(Test) #Calculating MSE
MSE.PCA

Reg.fit <- lm(Adjusted.x~ Panic_index + HML + CMA, data=Train)
summary(Reg.fit)                             #Summarize Model
pr.Reg <- predict(Reg.fit,Test)              #Predicting HAR model
MSE.Reg <- sum((pr.Reg - Test$Adjusted.x)^2)/nrow(Test) #Calculating MSE
MSE.Reg

windows()
plot(Test$created_at, Test$Adjusted.x, type="l", main = "Predicting the Price of DOW",
     xlab="Time (2020)", ylab="DOW Price") #Plot simple test set variable
#Forecasting predictioin
lines(Test$created_at, pr.PCA, col="red") #Plotting forecast
lines(Test$created_at, pr.Reg, col="blue")



