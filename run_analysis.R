# Title: run_analisys.R (Getting and Cleaning Data Course Project main script)
# Author: Ivette C. Martínez
# Creation Date: January 28, 2016
# Last Modification Date: january 30, 2016

## Project's Instruction

# One of the most exciting areas in all of data science right now is wearable computing 
# - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing 
# to develop the most advanced algorithms to attract new users. The data linked to from 
# the course website represent data collected from the accelerometers from the Samsung 
# Galaxy S smartphone. 
# A full description is available at the site where the data was obtained:
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
# Here are the data for the project:
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# You should create one R script called run_analysis.R that does the following.
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the 
# average of each variable for each activity and each subject.

## loading required libraries
library(gdata)
library(dplyr)

## Getting  the data
dataSetUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists("./Dataset.zip")){
  download.file(dataSetUrl, destfile= "./Dataset.zip", method = "curl")
  dateDownloaded <- date()
}
if (!file.exists("./UCI HAR DATASET")){
  unzip(zipfile="./Dataset.zip",exdir=".")
}

### Reading data tables (train and test)
dataTrainTable <- read.table("./UCI HAR DATASET/train/X_train.txt",sep="", header=FALSE)
dataTestTable <- read.table("./UCI HAR DATASET/test/X_test.txt",sep="", header=FALSE)

### Reading subject tables (train and test)
subjectTrainTable <-read.table("./UCI HAR DATASET/train/subject_train.txt",sep="", header=FALSE)  
subjectTestTable <-read.table("./UCI HAR DATASET/test/subject_test.txt",sep="", header=FALSE)  

### Reading activity tables (train and test)
activityTrainTable <- read.table("./UCI HAR DATASET/train/y_train.txt",sep="", header=FALSE)
activityTestTable <- read.table("./UCI HAR DATASET/test/y_test.txt",sep="", header=FALSE)

### Reading Features
featuresNamesTable <- read.table("./UCI HAR DATASET/features.txt",sep="", header=FALSE)  

# 1. Merges the training and the test sets to create one data set.

### Merging Data tables
dataTable <- rbind(dataTrainTable,dataTestTable)
### Merging Subjects tables
subjectTable <- rbind(subjectTrainTable,subjectTestTable)
### Merging Activity tables
activityTable <- rbind(activityTrainTable, activityTestTable)

### Changing variable names
names(subjectTable) <- c("subject")
names(activityTable) <- ("activity")
names(dataTable) <- featuresNamesTable$V2

#### Merging all tables
completeTable <- cbind(subjectTable, cbind(activityTable, dataTable))
##### Removing unnecessary tables
rm(dataTrainTable,dataTestTable, dataTable)
rm(subjectTrainTable, subjectTestTable, subjectTable)
rm(activityTrainTable, activityTestTable, activityTable)

dim(completeTable) # Dimensions of the merged data 



# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
### Obtaining features names with "mean()" or "std()" in their names
selectedFeaturesNames <- featuresNamesTable$V2[grep("mean\\(\\)|std\\(\\)", featuresNamesTable$V2)]
selectedFeaturesNames <- c(as.character(selectedFeaturesNames))
newFeaturesNames <- c("subject","activity", selectedFeaturesNames)
# Subsetting desired columns
selectedData <- subset(completeTable, select=newFeaturesNames)
# Removing unnecessary tables
rm(completeTable)

dim(selectedData)


# 3. Uses descriptive activity names to name the activities in the data set
activitiesNames <- read.table("./UCI HAR DATASET/activity_labels.txt",sep="", header=FALSE)$V2
selectedData$activity <- activitiesNames[selectedData$activity]

unique(selectedData$activity) ## Showing activities into selectedData 

# 4. Appropriately labels the data set with descriptive variable names.
names(selectedData)<-gsub("^f", "frequency", names(selectedData))
names(selectedData)<-gsub("^t", "time", names(selectedData))
names(selectedData)<-gsub("mean\\(\\)", "mean", names(selectedData))
names(selectedData)<-gsub("std\\(\\)", "std", names(selectedData))
names(selectedData)<-gsub("Acc", "Accelerometer", names(selectedData))
names(selectedData)<-gsub("Gyro", "Gyroscope", names(selectedData))
names(selectedData)<-gsub("Mag", "Magnitude", names(selectedData))
names(selectedData)<-gsub("BodyBody", "Body", names(selectedData))

names(selectedData) # Showing modified Colums Names

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
groupData <- selectedData
groupData <- groupData %>% group_by(subject,activity) %>% summarise_each(funs(mean))

dim(groupData) # check dimensions of the new tidy dataset

# saving new data set into a file 
write.table(groupData, file = "Tidy.txt",row.name=FALSE)

