## Getting and Cleaning Data Project
### Author: Arohi Parlikar

### This is the CodeBook for the final project in course Getting and Cleaning Data.

### Source Data
The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones.
Here are the data for the project: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

### R Script
The R script run_analysis performs the following:
#### 1. Reading in the files and merging the training and the test sets to create one data set.
  1.1 Reading files : training tables, testing tables, feature vector, activity labels
  1.2 Assigning variable names
  1.3 Merging all data in one set
#### 2. Extracting only the measurements on the mean and standard deviation for each measurement
  2.1 Reading required variable names using grep
  2.2 Making nessesary subset from merged data set
#### 3. Using descriptive activity names to name the activities in the data set
  This was done using the activity labels table. Used factor() parameters levels and labels to replace with activity names.
#### 4. Appropriately labeling the data set with descriptive variable names 
#### 5. Creating a second, independent tidy data set with the average of each variable for each activity and each subject
  5.1 Making second tidy data set
  5.2 Writing second tidy data set in txt file

The code assumes all the data is present in the same folder, un-compressed and without names altered.

### Variables
1. Data from downloaded files: activityLabel, features, train, trainLabels, trainSubject, test, testLabel, testSubject
2. The train and test data were merged -> merged
3. meanSTD contains the measurement values for only mean and std
4. extractedCols - Contain the mean and std specific data
5. tidyData - is the final data set with average of each variable for activity and subject

