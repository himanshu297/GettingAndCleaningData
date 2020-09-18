## Downloading of Human Activity Recognition using Smartphones Dataset

destfile <- "./HAR.zip"
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,destfile)
datedownloaded <- date()

##Load dplyr and tidyr

library(dplyr)
library(tidyr)

##Unzip locally stored zip file
har <- unzip(destfile)

#===============================================================#
  ## Task 1: Merge training and test sets to create one dataset
#===============================================================#
  
## Reading Training sets tables

x_train <- read.table("./UCI HAR Dataset/train/x_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

## Reading Test sets tables

x_test <- read.table("./UCI HAR Dataset/test/x_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

## Reading feature vector:
features <- read.table('./UCI HAR Dataset/features.txt')

## Reading activity labels:
activityLabels = read.table('./UCI HAR Dataset/activity_labels.txt')

## Assigning Column names

colnames(x_train) <- features[,2]
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

## merge datasets in one

merge_train <- cbind(y_train, subject_train, x_train)
merge_test <- cbind(y_test, subject_test, x_test)
mergeAll <- rbind(merge_train, merge_test)

#==================================================================================================#
  ## Task 2: Extracts only the measurements on the mean and standard deviation for each measurement.
#==================================================================================================#

colNames <- colnames(mergeAll)
mean_std <- grep("activityId|subjectId|.*mean.*|.*std.*", colNames)
colNames2 <- colNames[mean_std]
ExtractedTable <- mergeAll[, colNames2]


#===================================================================================#
  ## Task 3: Uses descriptive activity names to name the activities in the data set
#===================================================================================#

ExtractedTableWithActivityNames <- merge(ExtractedTable, activityLabels,by='activityId',all.x=TRUE)

#====================================================#=========================#
  ## Task 4: Appropriately labels the data set with descriptive variable names.
#==============================================================================#

# Already done in previous Tasks.

#==================================================================================#
  ## Task 5: From the data set in step 4, creates a second, independent tidy 
  ## data set with the average of each variable for each activity and each subject.
#==================================================================================#

TidySet <- aggregate(. ~subjectId + activityId, ExtractedTableWithActivityNames, mean)

## Sort by Subject ID and Activity ID
TidySet <- TidySet[order(TidySet$subjectId, TidySet$activityId),]

## Writing TidySet to text file
write.table(TidySet, "TidySet.txt" , row.names = FALSE)

