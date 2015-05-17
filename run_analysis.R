# Here are the data for the project: 
#   
#   https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# 
# You should create one R script called run_analysis.R that does the following. 


# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


# Merges the training and the test sets to create one data set.

x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
print(x_train)
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
x_merged <- rbind(x_train, x_test)

print(x_merged)

subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
subject_merged <- rbind(subject_train, subject_test)

y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
y_merged <- rbind(y_train, y_test)

#Extracts only the measurements on the mean and standard deviation for each measurement.

features <- read.table("UCI HAR Dataset/features.txt")

#filter means and standard deviation using grep
mean_and_std_deviation <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])
x_merged<- x_merged[, mean_and_std_deviation]
names(x_merged) <- features[mean_and_std_deviation, 2]
names(x_merged) <- gsub("\\(|\\)", "", names(x_merged))
names(x_merged) <- tolower(names(x_merged))

#Uses descriptive activity names to name the activities in the data set.

activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")

#use gsub to replace _ with empty string
activity_labels[, 2] = gsub("_", "", tolower(as.character(activity_labels[, 2])))
y_merged[,1] = activity_labels[y_merged[,1], 2]
names(y_merged) <- "activity"

#Appropriately labels the data set with descriptive activity names.

names(subject_merged) <- "subject"
merged_clean_data <- cbind(subject_merged, y_merged, x_merged)
write.table(merged_clean_data, "UCI HAR Dataset/merged_clean_data.txt")

#Creates a 2nd, independent tidy data set with the average of each variable for each activity and each subject.

uniqueSubjects = unique(subject_merged)[,1]
numOfSubjects = length(unique(subject_merged)[,1])
numOfActivities = length(activity_labels[,1])
numCols = dim(merged_clean_data)[2]
result = merged_clean_data[1:(numOfSubjects*numOfActivities), ]

print("result set before cleaning:")
print(result)
row = 1
for (s in 1:numOfSubjects) {
    for (a in 1:numOfActivities) {
        result[row, 1] = uniqueSubjects[s]
        result[row, 2] = merged_clean_data[a, 2]
        temp <- cleaned[merged_clean_data$subject==s & cleaned$activity==merged_clean_data[a, 2], ]
        result[row, 3:numCols] <- colMeans(temp[, 3:numCols])
        row = row+1
    }
}
print("printing final result avg")
print(result)
write.table(result, "UCI HAR Dataset/data_set_with_the_averagesof_each_variable_each_activity_each_subject.txt")
