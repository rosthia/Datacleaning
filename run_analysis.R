## set working directory
setwd("~/datasciencecoursera/Cleaningdata/data")

## Get feature names and subset to only those features of mean or std measures
feature_names <- read.table("features.txt")
desired_features <- grep("std|mean", feature_names$V2)

## Get the train and test feature sets and subset only the desired features
train_features <- read.table("train/X_train.txt")
desired_train_features <- train_features[,desired_features]
test_features <- read.table("test/X_test.txt")
desired_test_features <- test_features[,desired_features]

## Combine two datasets into 1 set
total_features <- rbind(desired_train_features, desired_test_features)

## Attach column names to features
colnames(total_features) <- feature_names[desired_features, 2]

## Read and combine the train and test activity codes
train_activities <- read.table("train/y_train.txt")
test_activities <- read.table("test/y_test.txt")
total_activities <- rbind(train_activities, test_activities)

## Get activity labels and attach to activity codes
activity_labels <- read.table("activity_labels.txt")
total_activities$activity <- factor(total_activities$V1, levels = activity_labels$V1, labels = activity_labels$V2)

## Get and combine the train and test subject ids
train_subjects <- read.table("train/subject_train.txt")
test_subjects <- read.table("test/subject_test.txt")
total_subjects <- rbind(train_subjects, test_subjects)

## Combine and label subjects and activities
subjects_n_activities <- cbind(total_subjects, total_activities$activity)
colnames(subjects_n_activities) <- c("subject.id", "activity")

## Combine with measures of interest for finished desired data frame
activity.frame <- cbind(subjects_n_activities, total_features)

## Compute result
## From the set produced for analysis, compute and report average of each variable for each activity and subject
result.frame <- aggregate(activity.frame[,3:81], by = list(activity.frame$subject.id, activity.frame$activity), FUN = mean)
colnames(result.frame)[1:2] <- c("subject.id", "activity")

##write out the 2nd data set
write.table(result.frame, file="tidydata.txt", row.names = FALSE)

