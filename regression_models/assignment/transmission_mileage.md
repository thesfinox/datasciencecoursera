---
title: "On Transmission Types and Mileage"
author: "Riccardo Finotello"
date: "24 June 2020"
output: 
    html_document:
        keep_md: true
---



## Summary

In this report we investigate the impact of gear transmission type on petrol
mileage of several types of cars. The objective is to study what kind of
transmission has the best impact on mileage (measured in miles per gallon) and
quantify the difference between the two types.

## Exploratory Data Analysis

We first load the _mtcars_ dataset and look at its description and summary:


```r
data("mtcars")
str(mtcars)
```

```
## 'data.frame':	32 obs. of  11 variables:
##  $ mpg : num  21 21 22.8 21.4 18.7 18.1 14.3 24.4 22.8 19.2 ...
##  $ cyl : num  6 6 4 6 8 6 8 4 4 6 ...
##  $ disp: num  160 160 108 258 360 ...
##  $ hp  : num  110 110 93 110 175 105 245 62 95 123 ...
##  $ drat: num  3.9 3.9 3.85 3.08 3.15 2.76 3.21 3.69 3.92 3.92 ...
##  $ wt  : num  2.62 2.88 2.32 3.21 3.44 ...
##  $ qsec: num  16.5 17 18.6 19.4 17 ...
##  $ vs  : num  0 0 1 1 0 1 0 1 1 1 ...
##  $ am  : num  1 1 1 0 0 0 0 0 0 0 ...
##  $ gear: num  4 4 4 3 3 3 3 4 4 4 ...
##  $ carb: num  4 4 1 1 2 1 4 2 2 4 ...
```
As we can see, the dataset is mainly composed of numerical variables and factors
which can be used for regression. We will be interested in the `mpg` variable as
dependent variable mainly as a function of the transmission type `am` which is a
binary variable describing _automatic_ ($am = 0$) or _manual_ ($am = 1$)
transmission type.
