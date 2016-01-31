###Getting and Cleaning Data Project

David Pelcyger

###Description

This codebook describes variables, data, and any transformations or performed to clean up the data.

###Source Data

A full description of the data used in this project can be found at The UCI Machine Learning Repository:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The source data for this project can be found in:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.

 
###1. Merge the training and the test sets to create one data set.

  I loaded the following files into sep arate tables:

    features.txt
    activity_labels.txt
    subject_train.txt
    x_train.txt
    y_train.txt
    subject_test.txt
    x_test.txt
    y_test.txt

  I used the rbind and cbind functions in R to merge all of the test and train     datasets into a single table.

###2. Extract only the measurements on the mean and standard deviation for each measurement.
  
  I Used setnames data.table function to add column names to dt 
  I used select to extracts only measurements with Mean or std from dt   
   
###3. Use descriptive activity names to name the activities in the data set

  I Used setnames (from data.table) to add column names to Activity 
  I used mutate (from dplyr) to put the descriptive names in Activitylabels 
  I then merge dtTidy with the Activitylabels to include the descriptive activity   names.

###4. Appropriately labels the data set with descriptive variable names

  I used the gsub function  to clean up the variable names.

###5. Create a second, independent tidy data set with the average of each variable for each activity and each subject.

  I used group_by (from dplyr) to group the data by subject and activity
  in dtGroup.
  I used Summarise (from dplyr) to get the mean in dtTidysum
 