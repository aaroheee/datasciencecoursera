# Getting and Cleaning Data Project John Hopkins Coursera
# Author: Arohi Parlikar

# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


# 1. Merges the training and the test sets to create one data set. ----
## Downloading the data
packages <- c('dplyr','data.table')
invisible(lapply(packages, library, character.only = TRUE))
#setwd("D:/Application/RPrac/")

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,destfile = "GCDataSet.zip")
unzip(zipfile = "GCDataSet.zip")

## Set your path
workD <- getwd()
path <- paste0(workD,"/UCI HAR Dataset/")


## Reading activity names and labels
activityLabel <- fread(file.path(path,"activity_labels.txt"), col.names = c("Label","ActivityName"))

## Reading features
features <- fread(file.path(path,"features.txt"), col.names = c("Index","FeatureName"))

## Reading train data
train <- fread(file.path(path,"train/X_train.txt"))
trainLabels <- fread(file.path(path,"train/y_train.txt"), col.names = c("Acitivity")) 
trainSubject <- fread(file.path(path,"train/subject_train.txt"), col.names = c("SubjectNumber"))

train <- cbind(trainSubject,trainLabels,train)

## Reading test data
test <- fread(file.path(path,"test/X_test.txt"))
testLabels <- fread(file.path(path,"test/y_test.txt"), col.names = c("Acitivity"))
testSubject <- fread(file.path(path,"test/subject_test.txt"), col.names = c("SubjectNumber"))

test <- cbind(testSubject,testLabels,test)

## Merge data sets
merged <- rbind(train, test)
FName <- gsub(pattern = "[()]", replacement = "", x = features$FeatureName)
colnames(merged) <- c("SubjectNumber","Activity",FName)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. ----
MeanSTD <- grep("(mean|std)",FName, value = TRUE, ignore.case = TRUE)
## MeanSTD2 <- grep("(mean|std)",FName, value = TRUE, ignore.case = FALSE)
requiredCols <- c("SubjectNumber","Activity",MeanSTD)
extractedCols <- merged[,..requiredCols]

# 3. Uses descriptive activity names to name the activities in the data set ----
## Replace Label with ActivityName in the Activity column
extractedCols$Activity <- factor(extractedCols$Activity, 
                                 levels = activityLabel$Label, 
                                 labels =  activityLabel$ActivityName)

# 4. Appropriately labels the data set with descriptive variable names. ----
names(extractedCols)<-gsub("Acc", "Accelerometer", names(extractedCols))
names(extractedCols)<-gsub("Gyro", "Gyroscope", names(extractedCols))
names(extractedCols)<-gsub("BodyBody", "Body", names(extractedCols))
names(extractedCols)<-gsub("Mag", "Magnitude", names(extractedCols))
names(extractedCols)<-gsub("^t", "Time", names(extractedCols))
names(extractedCols)<-gsub("^f", "Frequency", names(extractedCols))
names(extractedCols)<-gsub("tBody", "TimeBody", names(extractedCols))
names(extractedCols)<-gsub("-mean", "Mean", names(extractedCols), ignore.case = TRUE)
names(extractedCols)<-gsub("-std", "STD", names(extractedCols), ignore.case = TRUE)
names(extractedCols)<-gsub("-freq", "Frequency", names(extractedCols), ignore.case = TRUE)
names(extractedCols)<-gsub("angle", "Angle", names(extractedCols))
names(extractedCols)<-gsub("gravity", "Gravity", names(extractedCols))

# 5. From the data set in step 4, creates a second, independent tidy data set  ----
## with the average of each variable for each activity and each subject.

## Factoring Subject
extractedCols$SubjectNumber <- as.factor(extractedCols$SubjectNumber)

tidyData <- aggregate(. ~SubjectNumber + Activity, extractedCols, mean)
tidyData <- tidyData[order(tidyData$SubjectNumber,tidyData$Activity),]
write.table(tidyData, file = "tidyData.txt", row.names = FALSE, quote = FALSE)
