#run.analysis.R

#Loads add-on packages data.table and dplyr
  library(data.table)
  library(dplyr)

#Loads Input Data; assume data is in current directory
  features=readLines("./UCI HAR Dataset/features.txt")   
  activity.labels=read.table("./UCI HAR Dataset/activity_labels.txt")    
  x.test=read.table("./UCI HAR Dataset/test/X_test.txt")                  #Set
  y.test=read.table("./UCI HAR Dataset/test/Y_test.txt")                  #Labels 
  subject.test=read.table("./UCI HAR Dataset/test/subject_test.txt")      #Subject 
  x.train=read.table("./UCI HAR Dataset/train/X_train.txt")               #Set
  y.train=read.table("./UCI HAR Dataset/train/Y_train.txt")               #Labels
  subject.train=read.table("./UCI HAR Dataset/train/subject_train.txt")   #Subject 

#Create data.tables
  x.train=as.data.table(x.train)
  x.test=as.data.table(x.test)
  y.train=as.data.table(y.train)
  y.test=as.data.table(y.test)
  subject.test=as.data.table(subject.test)
  subject.train=as.data.table(subject.train)

# Merge data.tables
  #Merge x.train, x.test into dt
  dt = rbind( x.train, x.test)
  # Merge subject.train, subject.test into Subject 
  Subject =  rbind(subject.train, subject.test)
  # Merge labels (y.train, y.test) into Activity
  Activity = rbind(y.train, y.test)

#Make feature.labels
  feature.labels= make.names(features)
  
#4. Appropriately label the data set with descriptive variable names. 
  
  #Use gsub to modify contents of feature.labels  
  feature.labels=gsub("^X[0-9][0-9]*.","",feature.labels)
  feature.labels=gsub("tBody","timeBody",feature.labels)
  feature.labels=gsub("tGravity","timeGravity",feature.labels)
  feature.labels=gsub("fBody","frequencyBody",feature.labels)

  # add column names to make dt, Subject, Activity more readable
  setnames(dt, names(dt), feature.labels)
  setnames(Subject, names(Subject), "Subject")
  setnames(Activity, names(Activity), "Activity")
  
#2. Extracts only measurements with Mean or std

  dtMean=select(dt,contains("Mean",ignore.case=TRUE))
  dtstd=select(dt,contains("std"))

#1. Merges dtMean, dtstd to create one dataset dtTidy
  dtTidy=cbind(dtMean,dtstd)  
  
#3. Uses descriptive activity names to name the activities in the data set
  #use mutate to get Activitylabels
  Activitylabels=mutate(Activity,Activity=factor(Activity,labels=activity.labels[,2]))

  #merges subject and activity columns with dtTidy
  dtTidy=cbind(Subject,Activitylabels, dtTidy)
  dtTidy = arrange(dtTidy,Subject)
  write.table(dtTidy,file="dtTidy.txt", row.name=F)
  print("Tidy dataset with data on mean and std is in dtTidy.txt")

#5. Creates data set with the average of each variable for each activity and each subject.  
  # group by Subject and Activity and summerise (take the mean)
  dtGroup = group_by(dtTidy,Subject,Activity)
  dtTidysum = summarise_each(dtGroup,funs(mean))
  write.table(dtTidysum,file="dtTidysum.txt", row.name=F)
  print("Tidy dataset containing summarized means for each subject by activity is in dtTidysum.txt")

  