# This script runs the analysis requested by the Programming Assignment 4 of
# the course "Getting and Cleaning Data".

library(dplyr)
library(data.table)

# STEP 0: Get the dataset and unzip it
############################################################################

# open url and download zip file
db_url   <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
out_file <- "dataset.zip"

if(!file.exists(out_file)) { download.file(db_url, out_file, method = "curl") }
if(file.exists(out_file))  { unzip(out_file) }

# STEP 1: merge training and test datasets
############################################################################

# read feature names
features <- fread("UCI HAR Dataset/features.txt", #-------- load file
                  select = 2, #---------------------------- select only names (IDs are already provided)
                  col.names = "FeatureName" #-------------- give a meaningful name
                 )
activities <- fread("UCI HAR Dataset/activity_labels.txt",
                    select = 2,
                    col.names = "ActivityName"
                   )

# read datasets
x_train <- fread("UCI HAR Dataset/train/X_train.txt", col.names = features$FeatureName)
y_train <- fread("UCI HAR Dataset/train/y_train.txt", col.names = "Activity")
s_train <- fread("UCI HAR Dataset/train/subject_train.txt", col.name = "Subject")

x_test <- fread("UCI HAR Dataset/test/X_test.txt", col.names = features$FeatureName)
y_test <- fread("UCI HAR Dataset/test/y_test.txt", col.names = "Activity")
s_test <- fread("UCI HAR Dataset/test/subject_test.txt", col.name = "Subject")

# merge datasets
x_dat <- rbind(x_train, x_test) #------------------------- x dataset
y_dat <- rbind(y_train, y_test) #------------------------- y dataset
s_dat <- rbind(s_train, s_test) #------------------------- subject (s) dataset

# STEP 2: Extract  measurements on the mean and std for each measurement
############################################################################

# select data
x_dat <- select(x_dat, contains("mean") | contains("std"))

# STEP 3: Use descriptive activity names to name the activities in the data set
############################################################################

# factor each activity in y_dat using the activity dictionary
y_dat$Activity <- factor(y_dat$Activity,
                         levels = 1:length(activities$ActivityName), #---- as many levels as there are activities
                         labels = activities$ActivityName #--------------- labelled using the activity name
                        )

# STEP 4: Appropriately labels the data set with descriptive variable names
############################################################################

# column bind all the datasets and remove () from the name of the features
data <- cbind(x_dat, y_dat, s_dat)
names(data) <- gsub("\\(\\)", "", names(data))

# STEP 5: Create a second set with the average of each variable for each
#         activity and each subject
############################################################################

avg_data <- data %>%
            group_by(Subject, Activity) %>%
            summarise(across(!matches("Activity|Subject"), #----- go "across" each other column
                             mean #------------------------------ compute the mean
                            )
                     )

# output to file
write.table(avg_data, file = "tidy_dataset.txt", row.names = FALSE)
