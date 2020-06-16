# Getting and Cleaning Data Course Project

This repository holds the `R` code used in the peer-reviewed assignment of the course _Getting and Cleaning Data_ offered through [Coursera.org](https://www.coursera.org) by the **John Hopkins University**.

The dataset used for the exercise can be found at [UCI Machine Learning Repository](https://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) and contains data on human activity recognition using smartphones performed in 2012.

## Introduction

The code in `run_analysis.R` automatically downloads the `zip` file containing the data and proceeds to processing the files:

- it first reads the names of the features and activities,
- then it merges training and test datasets assigning the correct names to the columns,
- it extracts only measurements involving mean and standard deviation,
- it tidies up variable names and feature names,
- it creates a second dataset (`tidy_dataset.txt`) containing the average of each measurement grouped by kind of activity and subject performing it.

Other files in the repository include `CodeBook.md` which describes data, variables and transformations.
