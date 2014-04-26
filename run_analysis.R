# Getting and Cleaning Data Peer Assessment 
setwd("D:/Users/FRAENG/Documents/2 Projects/2014 Data Analysis/gettingcleaningdatapeerassessment")

#install.packages("data.table")
library(data.table)

# Load relevant data sets into R 

training_set <- read.table('./UCI HAR Dataset/train/X_train.txt')
training_subjects <- read.table('./UCI HAR Dataset/train/subject_train.txt')
training_activities <- read.table('./UCI HAR Dataset/train/y_train.txt')

test_set <- read.table('./UCI HAR Dataset/test/X_test.txt')
test_subjects <- read.table('./UCI HAR Dataset/test/subject_test.txt')
test_activities <- read.table('./UCI HAR Dataset/test/y_test.txt')

feature_names <- read.table('./UCI HAR Dataset/features.txt')

# convert features from factor into character 

feature_names <- as.character(feature_names[, 2]) 

# create full training set and test set including subjects and activities 
training_set <- cbind(training_subjects, training_activities, training_set)
test_set <- cbind(test_subjects, test_activities, test_set)

# 1 merges training and test sets to create one data set

one_set <- rbind(training_set, test_set)

# Uses descriptive activity names to name the activities in the data set

colnames(one_set) <- c('subject', 'activity', feature_names)

# 2 extracts only the measurements on the mean and standard deviation for each measurement
required_features <- grepl('(.*?)-(mean()|std())(.*?)', feature_names)
one_set <- one_set[, c(TRUE, TRUE, required_features)]

# Appropriately labels the data set with descriptive activity names. 
 
one_set$activity[one_set$activity==1] <- "walking"
one_set$activity[one_set$activity==2] <- "walking upstairs"
one_set$activity[one_set$activity==3] <- "walking downstairs"
one_set$activity[one_set$activity==4] <- "sitting"
one_set$activity[one_set$activity==5] <- "standing"
one_set$activity[one_set$activity==6] <- "laying"

# enhance data frame with data table features 

one_set <- as.data.table(one_set) 

# creates tidy data set - one row for each combination of activity & subject

tidy_set <- one_set[, lapply(.SD, mean), by = list(activity, subject)]
tidy_set <- tidy_set[order(tidy_set$subject, decreasing = FALSE)]

# Writes 2nd independent tidy data set with average of each variable for each activity and each subject

write.table(tidy_set, file = "./tidy_data_set.txt", quote = FALSE,
            row.names = FALSE, sep='\t')

# Appendix - Helpful articles 
# http://stackoverflow.com/questions/14937165/using-dynamic-column-names-in-data-table
# http://stackoverflow.com/questions/20459519/apply-function-on-a-subset-of-columns-sdcols-whilst-applying-a-different-func
# http://stackoverflow.com/questions/3505701/r-grouping-functions-sapply-vs-lapply-vs-apply-vs-tapply-vs-by-vs-aggrega

 
 
 

 





