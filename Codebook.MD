First of all,  relevant data sets were loaded into R. 
Data sets were separated into training and test sets. 

training_set <- read.table('./UCI HAR Dataset/train/X_train.txt')
training_subjects <- read.table('./UCI HAR Dataset/train/subject_train.txt')
training_activities <- read.table('./UCI HAR Dataset/train/y_train.txt')
......

Next, accelerometer features were loaded and subsequently converted from factor into strings so as to apply them as column names later on 

feature_names <- read.table('./UCI HAR Dataset/features.txt')
feature_names <- as.character(feature_names[, 2]) 

Next, complete training sets and test sets were created. Complete in sense of including subjects and activities into data set

training_set <- cbind(training_subjects, training_activities, training_set)
test_set <- cbind(test_subjects, test_activities, test_set)

Next, training and test sets were merged to create one data set

one_set <- rbind(training_set, test_set)

Next, feature names were applied as column headers to make data set more descriptive

colnames(one_set) <- c('subject', 'activity', feature_names)

Next,  measurements on mean and standard deviation were extracted (only those columns which contained mean() and std() as strings in their name

required_features <- grepl('(.*?)-(mean()|std())(.*?)', feature_names)
one_set <- one_set[, c(TRUE, TRUE, required_features)]

Next, labels were applied to activities 
 
one_set$activity[one_set$activity==1] <- "walking"
one_set$activity[one_set$activity==2] <- "walking upstairs"
one_set$activity[one_set$activity==3] <- "walking downstairs"
one_set$activity[one_set$activity==4] <- "sitting"
one_set$activity[one_set$activity==5] <- "standing"
one_set$activity[one_set$activity==6] <- "laying"

Next, data frame was converted into data table 

one_set <- as.data.table(one_set) 

Next, a tidy data set was created - one row for each combination of activity & subject

tidy_set <- one_set[, lapply(.SD, mean), by = list(activity, subject)]
tidy_set <- tidy_set[order(tidy_set$subject, decreasing = FALSE)]

Next, a 2nd independent tidy data set with average of each variable for each activity and each subject was created 

write.table(tidy_set, file = "./tidy_data_set.txt", quote = FALSE,
            row.names = FALSE, sep='\t')

Appendix - Helpful articles 
http://stackoverflow.com/questions/14937165/using-dynamic-column-names-in-data-table
http://stackoverflow.com/questions/20459519/apply-function-on-a-subset-of-columns-sdcols-whilst-applying-a-different-func
http://stackoverflow.com/questions/3505701/r-grouping-functions-sapply-vs-lapply-vs-apply-vs-tapply-vs-by-vs-aggrega
