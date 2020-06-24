---
title: "Sport Wearable Devices and Activity Performance"
author: "Riccardo Finotello"
date: "24 June 2020"
output:
  html_document:
    keep_md: yes
  pdf_document: default
---



## Summary

In this analysis we will consider data of sport wearable devices and we will
tackle the task of predicting the performance of dumbell exercises as perceived
from the device. In other words we will try to predict the assigned class of the
exercise from motion sensor data.

## Cleaning the Data

We will first access the training data:


```r
data <- read.csv("https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv",
                 na.strings = c("#DIV/0!", "", "NA"),
                 stringsAsFactors = FALSE
                )
```

We then take a look at the number of entries and features in the dataset:


```r
print(paste("No. of entries:", nrow(data)))
```

```
## [1] "No. of entries: 19622"
```

```r
print(paste("No. of columns<:", ncol(data)))
```

```
## [1] "No. of columns<: 160"
```

From the dataset we remove information related to the specific user and keep
only numerical features and non empty columns:


```r
data <- data[,-(1:7)]
data$classe <- as.factor(data$classe) # convert classe to factor
```

We then compute the fraction of **NA** data in each column and remove those
variables with more than 50% of missing data. This shows that we will keep only
a fraction of the original variables:


```r
# find fraction of NA values
data.na.fraction <- sapply(data, function(x) {mean(is.na(x))})
data.cols <- (data.na.fraction <= 0.5)
print(paste("Fraction of retained variables:", round(mean(data.cols),2)))
```

```
## [1] "Fraction of retained variables: 0.35"
```

```r
# select the relevant columns
train.data <- data[, data.cols]
```
We therefore have a tidy dataset containing
100% of complete cases and new dimensions:


```r
print(paste("No. of entries:", nrow(train.data)))
```

```
## [1] "No. of entries: 19622"
```

```r
print(paste("No. of columns:", ncol(train.data)))
```

```
## [1] "No. of columns: 53"
```

We finally divide the features we use for training from the labels we try to
predict:


```r
# shuffle the dataset
train.data <- train.data[sample(nrow(train.data)),]

# store the id of the classes (last column)
labels <- c(ncol(train.data))
```

As an additional step before the exploratory data analysis, we divide the
training set into a further partition for testing:


```r
library(caret)
```

```
## Warning: package 'caret' was built under R version 3.6.3
```

```
## Warning: package 'lattice' was built under R version 3.6.3
```

```
## Warning: package 'ggplot2' was built under R version 3.6.3
```

```r
train.part <- createDataPartition(train.data[,ncol(train.data)], p=0.8, list=FALSE)
train <- train.data[train.part,]
test <- train.data[-train.part,]
```

## Exploratory Data Analysis

To better understand the distribution of the variables, we study their
correlations properties (**we consider only the training partition and we do not
look at the labels to avoid biasing the strategy**):


```r
library(reshape2)
```

```
## Warning: package 'reshape2' was built under R version 3.6.3
```

```r
corr.mat <- cor(train[,-labels])
corr.mat.melt <- melt(corr.mat)

# plot the correlation matrix
library(ggplot2)
g <- ggplot(data = corr.mat.melt, aes(Var1, Var2, fill = value)) +
     geom_tile() +
     xlab("") +
     ylab("") +
     scale_fill_gradient2(low = "red", mid= "white", high = "blue",
                          midpoint = 0, limit = c(-1,1)
                         ) +
    theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1))
print(g)
```

![](activity_performance_files/figure-html/unnamed-chunk-8-1.png)<!-- -->

As we can see the variables are in general not correlated, apart from (mainly)
the accelerometers and gyroscope (partly as expected). We may expect them to
play a greater part in the prediction or at least we will see that they will be
more interacting.

In fact we can dig a bit more on the subject and visualise the distribution of
these sensors with respect to the `classe` label:


```r
library(gridExtra)
```

```
## Warning: package 'gridExtra' was built under R version 3.6.3
```

```r
g1 <- ggplot(data = train,
             aes(x = accel_belt_x, y = accel_belt_y, col = accel_belt_z)) +
      geom_point() +
      scale_color_gradient2(low = "red", mid = "white", high = "blue",
                            midpoint = 0)
g2 <- ggplot(data = train,
             aes(x = gyros_belt_x, y = gyros_belt_y, col = gyros_belt_z)) +
      geom_point() +
      scale_color_gradient2(low = "red", mid = "white", high = "blue",
                            midpoint = 0)

grid.arrange(g1, g2, nrow = 1)
```

![](activity_performance_files/figure-html/unnamed-chunk-9-1.png)<!-- -->

We then divide the training variables from the labels:


```r
x.train <- train[,-labels]
y.train <- train[,labels]
x.test  <- test[,-labels]
y.test  <- test[,labels]
```

The summary of the training variables can then be useful to understand the next
step in the analysis:


```r
library(skimr)
```

```
## Warning: package 'skimr' was built under R version 3.6.3
```

```r
skim(x.train)
```


Table: Data summary

                                   
-------------------------  --------
Name                       x.train 
Number of rows             15699   
Number of columns          52      
_______________________            
Column type frequency:             
numeric                    52      
________________________           
Group variables            None    
-------------------------  --------


**Variable type: numeric**

skim_variable           n_missing   complete_rate      mean       sd         p0       p25       p50       p75      p100  hist  
---------------------  ----------  --------------  --------  -------  ---------  --------  --------  --------  --------  ------
roll_belt                       0               1     64.41    62.74     -28.80      1.10    113.00    123.00    162.00  ▇▁▁▅▅ 
pitch_belt                      0               1      0.45    22.27     -55.80      1.84      5.33     15.20     60.30  ▃▁▇▅▁ 
yaw_belt                        0               1    -11.68    94.82    -180.00    -88.30    -13.20     11.50    179.00  ▁▇▅▁▃ 
total_accel_belt                0               1     11.31     7.74       0.00      3.00     17.00     18.00     29.00  ▇▁▂▆▁ 
gyros_belt_x                    0               1     -0.01     0.21      -1.00     -0.03      0.03      0.11      2.22  ▁▇▁▁▁ 
gyros_belt_y                    0               1      0.04     0.08      -0.64      0.00      0.02      0.11      0.63  ▁▁▇▁▁ 
gyros_belt_z                    0               1     -0.13     0.24      -1.46     -0.20     -0.10     -0.02      1.62  ▁▂▇▁▁ 
accel_belt_x                    0               1     -5.79    29.56    -120.00    -21.00    -15.00     -5.00     81.00  ▁▁▇▁▂ 
accel_belt_y                    0               1     30.21    28.57     -69.00      3.00     35.00     61.00    164.00  ▁▇▇▁▁ 
accel_belt_z                    0               1    -72.60   100.45    -275.00   -162.00   -152.00     27.00    105.00  ▁▇▁▅▃ 
magnet_belt_x                   0               1     55.20    64.02     -49.00      9.00     34.00     59.00    485.00  ▇▂▂▁▁ 
magnet_belt_y                   0               1    593.64    35.60     354.00    581.00    601.00    610.00    673.00  ▁▁▁▇▃ 
magnet_belt_z                   0               1   -345.59    64.85    -623.00   -375.00   -320.00   -306.00    289.00  ▁▇▁▁▁ 
roll_arm                        0               1     17.71    73.04    -180.00    -32.20      0.00     77.50    180.00  ▁▃▇▆▂ 
pitch_arm                       0               1     -4.81    30.74     -88.80    -26.10      0.00     11.10     88.20  ▁▅▇▂▁ 
yaw_arm                         0               1     -0.55    71.30    -180.00    -42.60      0.00     45.50    180.00  ▁▃▇▃▂ 
total_accel_arm                 0               1     25.54    10.52       1.00     17.00     27.00     33.00     65.00  ▃▆▇▁▁ 
gyros_arm_x                     0               1      0.04     1.99      -6.37     -1.33      0.08      1.57      4.87  ▁▃▇▆▂ 
gyros_arm_y                     0               1     -0.26     0.85      -3.44     -0.80     -0.24      0.14      2.81  ▁▂▇▂▁ 
gyros_arm_z                     0               1      0.27     0.55      -2.33     -0.07      0.23      0.72      2.99  ▁▂▇▂▁ 
accel_arm_x                     0               1    -58.95   182.88    -404.00   -241.00    -43.00     84.00    437.00  ▇▅▇▅▁ 
accel_arm_y                     0               1     32.17   109.85    -318.00    -54.00     14.00    138.50    308.00  ▁▃▇▆▂ 
accel_arm_z                     0               1    -71.79   134.55    -629.00   -144.00    -48.00     23.00    292.00  ▁▁▅▇▁ 
magnet_arm_x                    0               1    194.15   444.17    -584.00   -299.00    294.00    640.00    782.00  ▆▃▂▃▇ 
magnet_arm_y                    0               1    155.26   202.16    -392.00    -12.00    200.00    322.00    583.00  ▁▅▅▇▂ 
magnet_arm_z                    0               1    304.60   327.10    -596.00    126.00    441.00    544.00    694.00  ▁▂▂▃▇ 
roll_dumbbell                   0               1     23.55    70.03    -153.71    -19.30     48.18     67.45    153.38  ▂▂▃▇▂ 
pitch_dumbbell                  0               1    -10.71    37.10    -149.59    -40.91    -20.84     17.35    149.40  ▁▆▇▂▁ 
yaw_dumbbell                    0               1      1.94    82.47    -150.87    -77.56     -2.57     79.55    154.95  ▃▇▅▅▆ 
total_accel_dumbbell            0               1     13.69    10.24       0.00      4.00     10.00     19.00     58.00  ▇▅▃▁▁ 
gyros_dumbbell_x                0               1      0.16     1.68    -204.00     -0.03      0.13      0.35      2.20  ▁▁▁▁▇ 
gyros_dumbbell_y                0               1      0.05     0.64      -2.10     -0.14      0.05      0.21     52.00  ▇▁▁▁▁ 
gyros_dumbbell_z                0               1     -0.12     2.55      -2.38     -0.31     -0.13      0.03    317.00  ▇▁▁▁▁ 
accel_dumbbell_x                0               1    -28.47    67.49    -419.00    -50.00     -8.00     11.00    235.00  ▁▁▆▇▁ 
accel_dumbbell_y                0               1     52.21    80.82    -189.00     -9.00     40.00    111.00    315.00  ▁▇▇▅▁ 
accel_dumbbell_z                0               1    -37.84   109.40    -319.00   -141.00     -1.00     39.00    318.00  ▂▅▇▃▁ 
magnet_dumbbell_x               0               1   -327.18   340.71    -643.00   -535.00   -479.00   -298.50    592.00  ▇▂▁▁▂ 
magnet_dumbbell_y               0               1    220.22   328.42   -3600.00    231.00    311.00    390.00    633.00  ▁▁▁▁▇ 
magnet_dumbbell_z               0               1     45.25   140.02    -262.00    -46.00     13.00     95.00    452.00  ▁▇▆▂▂ 
roll_forearm                    0               1     34.25   107.92    -180.00     -0.60     22.60    140.00    180.00  ▃▂▇▂▇ 
pitch_forearm                   0               1     10.72    28.19     -72.50      0.00      9.31     28.40     89.80  ▁▁▇▃▁ 
yaw_forearm                     0               1     19.06   103.49    -180.00    -69.90      0.00    110.00    180.00  ▅▅▇▆▇ 
total_accel_forearm             0               1     34.66    10.07       0.00     29.00     36.00     41.00    108.00  ▁▇▂▁▁ 
gyros_forearm_x                 0               1      0.16     0.65     -22.00     -0.22      0.05      0.56      3.97  ▁▁▁▁▇ 
gyros_forearm_y                 0               1      0.09     3.29      -6.65     -1.46      0.03      1.64    311.00  ▇▁▁▁▁ 
gyros_forearm_z                 0               1      0.16     1.94      -8.09     -0.18      0.08      0.49    231.00  ▇▁▁▁▁ 
accel_forearm_x                 0               1    -61.43   180.13    -498.00   -178.00    -57.00     76.00    477.00  ▂▆▇▅▁ 
accel_forearm_y                 0               1    163.58   199.63    -632.00     57.00    200.00    311.50    923.00  ▁▂▇▅▁ 
accel_forearm_z                 0               1    -55.66   138.59    -446.00   -182.00    -40.00     26.00    291.00  ▁▇▅▅▃ 
magnet_forearm_x                0               1   -313.74   346.28   -1280.00   -617.00   -376.00    -74.00    663.00  ▁▇▇▅▂ 
magnet_forearm_y                0               1    382.33   508.55    -896.00      7.00    593.00    737.00   1480.00  ▂▂▂▇▁ 
magnet_forearm_z                0               1    393.81   369.31    -973.00    194.00    511.00    653.00   1090.00  ▁▁▂▇▃ 

## Machine Learning Predictions

we first preprocess the data and standardise the training features:


```r
preprocess <- preProcess(x.train, method = c("center", "scale"))
x.new.train <- predict(preprocess, newdata = x.train)
x.new.test  <- predict(preprocess, newdata = x.test)
```

We finally apply a **random forest** algorithm to the training data. We use a
10-fold cross-validation asstrategy (partly to prevent overfit and improve
predictions):


```r
# set multithreading
library(doParallel)
```

```
## Warning: package 'doParallel' was built under R version 3.6.3
```

```
## Warning: package 'foreach' was built under R version 3.6.3
```

```
## Warning: package 'iterators' was built under R version 3.6.3
```

```r
cl <- makeCluster(detectCores())
registerDoParallel(cl)

# begin training
set.seed(42)
train.ctrl <- trainControl(method = "cv", number = 10, search = "grid")
train.rf <- train(x.new.train, y.train, trControl = train.ctrl, method = "rf")

# stop multithreading
stopCluster(cl)
```

We the show the summary of the training procedure:

```r
print(train.rf)
```

```
## Random Forest 
## 
## 15699 samples
##    52 predictor
##     5 classes: 'A', 'B', 'C', 'D', 'E' 
## 
## No pre-processing
## Resampling: Cross-Validated (10 fold) 
## Summary of sample sizes: 14130, 14128, 14129, 14130, 14128, 14130, ... 
## Resampling results across tuning parameters:
## 
##   mtry  Accuracy   Kappa    
##    2    0.9930572  0.9912172
##   27    0.9938215  0.9921848
##   52    0.9858586  0.9821103
## 
## Accuracy was used to select the optimal model using the largest value.
## The final value used for the model was mtry = 27.
```

In training we performed a hyperparameter grid search in order to improve the
accuracy of the prediction. In fact we show the plot of such search:


```r
plot(train.rf, main="Accuracy over the Hyperparameter Search")
```

![](activity_performance_files/figure-html/unnamed-chunk-15-1.png)<!-- -->

We finally plot the feature importance assigned by the algorithm to check that
our analysis (including the exploratory analysis and dataset cleaning) was in
fact meaningful:


```r
var.imp <- varImp(train.rf)
plot(var.imp, main = "Variable Ranking (random forest)")
```

![](activity_performance_files/figure-html/unnamed-chunk-16-1.png)<!-- -->

Finally we show the training performance:


```r
train.pred <- predict(train.rf, newdata = x.new.train)
confusionMatrix(data = train.pred, reference = y.train, mode = "everything")
```

```
## Confusion Matrix and Statistics
## 
##           Reference
## Prediction    A    B    C    D    E
##          A 4457   14    0    0    0
##          B    1 3014    7    0    0
##          C    5    9 2728   28    3
##          D    0    0    3 2545    3
##          E    1    1    0    0 2880
## 
## Overall Statistics
##                                          
##                Accuracy : 0.9952         
##                  95% CI : (0.994, 0.9962)
##     No Information Rate : 0.2843         
##     P-Value [Acc > NIR] : < 2.2e-16      
##                                          
##                   Kappa : 0.994          
##                                          
##  Mcnemar's Test P-Value : NA             
## 
## Statistics by Class:
## 
##                      Class: A Class: B Class: C Class: D Class: E
## Sensitivity            0.9984   0.9921   0.9963   0.9891   0.9979
## Specificity            0.9988   0.9994   0.9965   0.9995   0.9998
## Pos Pred Value         0.9969   0.9974   0.9838   0.9976   0.9993
## Neg Pred Value         0.9994   0.9981   0.9992   0.9979   0.9995
## Precision              0.9969   0.9974   0.9838   0.9976   0.9993
## Recall                 0.9984   0.9921   0.9963   0.9891   0.9979
## F1                     0.9976   0.9947   0.9900   0.9934   0.9986
## Prevalence             0.2843   0.1935   0.1744   0.1639   0.1838
## Detection Rate         0.2839   0.1920   0.1738   0.1621   0.1835
## Detection Prevalence   0.2848   0.1925   0.1766   0.1625   0.1836
## Balanced Accuracy      0.9986   0.9957   0.9964   0.9943   0.9989
```

and for the test data:


```r
test.pred <- predict(train.rf, newdata = x.new.test)
confusionMatrix(data = test.pred, reference = y.test, mode = "everything")
```

```
## Confusion Matrix and Statistics
## 
##           Reference
## Prediction    A    B    C    D    E
##          A 1112    1    0    0    0
##          B    3  757    2    0    0
##          C    1    1  681    4    0
##          D    0    0    1  639    0
##          E    0    0    0    0  721
## 
## Overall Statistics
##                                           
##                Accuracy : 0.9967          
##                  95% CI : (0.9943, 0.9982)
##     No Information Rate : 0.2845          
##     P-Value [Acc > NIR] : < 2.2e-16       
##                                           
##                   Kappa : 0.9958          
##                                           
##  Mcnemar's Test P-Value : NA              
## 
## Statistics by Class:
## 
##                      Class: A Class: B Class: C Class: D Class: E
## Sensitivity            0.9964   0.9974   0.9956   0.9938   1.0000
## Specificity            0.9996   0.9984   0.9981   0.9997   1.0000
## Pos Pred Value         0.9991   0.9934   0.9913   0.9984   1.0000
## Neg Pred Value         0.9986   0.9994   0.9991   0.9988   1.0000
## Precision              0.9991   0.9934   0.9913   0.9984   1.0000
## Recall                 0.9964   0.9974   0.9956   0.9938   1.0000
## F1                     0.9978   0.9954   0.9934   0.9961   1.0000
## Prevalence             0.2845   0.1935   0.1744   0.1639   0.1838
## Detection Rate         0.2835   0.1930   0.1736   0.1629   0.1838
## Detection Prevalence   0.2837   0.1942   0.1751   0.1631   0.1838
## Balanced Accuracy      0.9980   0.9979   0.9969   0.9967   1.0000
```

We finally plot the distribution of the **validation set** and compare the
predictions:


```r
library(dplyr)
library(data.table)
test.pred <- data.table(test.pred)
test.pred.n <- test.pred %>% count(test.pred)
y.test <- data.table(y.test)
y.test.n <- y.test %>% count(y.test)

# plot the counts
g <- ggplot() +
     geom_bar(data = test.pred , aes(test.pred, fill = test.pred), width = 0.75) +
     geom_bar(data = y.test, aes(y.test), width = 0.3, fill = "white") +
     xlab("classe") +
     ylab("count") +
     ggtitle("Validation set predictions and true values")
print(g)
```

![\label{fig:pred}Predictions on the validation set: coloured bars represent true values and white superimposed values represent predictions.](activity_performance_files/figure-html/unnamed-chunk-19-1.png)

## Test Set Predictions

We finally consider the final test set:


```r
final.test <- read.csv("https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv",
                 na.strings = c("#DIV/0!", "", "NA"),
                 stringsAsFactors = FALSE)

# perform the same transformations
final.test <- final.test[,-(1:7)]
final.test$problem_id <- as.factor(final.test$problem_id)
test.data.na.fraction <- sapply(final.test, function(x) {mean(is.na(x))})
test.data.cols <- (test.data.na.fraction <= 0.5)

# select the relevant columns
test.data <- final.test[, test.data.cols]
test.data <- test.data[,-ncol(test.data)]

# apply pre-process transformation
test.data <- predict(preprocess, newdata = test.data)
```

We can now make the test set predictions:


```r
final.predictions <- predict(train.rf, newdata = test.data)
print(final.predictions)
```

```
##  [1] B A B A A E D B A A B C B A E E A B B B
## Levels: A B C D E
```

## Conclusions

We showed that we were able to make meaningful predictions on a cleaned version
of the wearable database, achieving a very high level of accuracy using a
random forest approach.
