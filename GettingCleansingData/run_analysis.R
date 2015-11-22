##################################################################################
#
# Getting and Cleaning Data Course Project
#
##################################################################################

## Create MyData folder in working directory
if(!file.exists("./Mydata")){dir.create("./Mydata")}

## Download file
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./Mydata/Dataset.zip",method="curl")

## Unzip the file#
unzip(zipfile="./Mydata/Dataset.zip",exdir="./Mydata")
path <- file.path("./Mydata" , "UCI HAR Dataset")
files<-list.files(path, recursive=TRUE)
files

##Read activity data from unzipped files
dataActivityTest  <- read.table(file.path(path, "test" , "Y_test.txt" ),header = FALSE)
dataActivityTrain <- read.table(file.path(path, "train", "Y_train.txt"),header = FALSE)

## Read subject lines from unzipped files
dataSubjectTrain <- read.table(file.path(path, "train", "subject_train.txt"),header = FALSE)
dataSubjectTest  <- read.table(file.path(path, "test" , "subject_test.txt"),header = FALSE)

## Read features from unzipped files
dataFeaturesTest  <- read.table(file.path(path, "test" , "X_test.txt" ),header = FALSE)
dataFeaturesTrain <- read.table(file.path(path, "train", "X_train.txt"),header = FALSE)

## Check the results
str(dataActivityTest)
str(dataActivityTrain)
str(dataSubjectTrain)
str(dataSubjectTest)
str(dataFeaturesTest)
str(dataFeaturesTrain)

## Link data tables by rows
dataActivityAll <- rbind(dataActivityTrain, dataActivityTest)
dataSubjectAll  <- rbind(dataSubjectTrain, dataSubjectTest)
dataFeaturesAll <- rbind(dataFeaturesTrain, dataFeaturesTest)

## Check the results
str(dataActivityAll)
str(dataSubjectAll)
str(dataFeaturesAll)

## Set names
names(dataSubjectAll)<-c("subject")
names(dataActivityAll)<- c("activity")
dataFeaturesNames <- read.table(file.path(path, "features.txt"),head=FALSE)
names(dataFeaturesAll)<- dataFeaturesNames$V2

## Build the complete data set
dataAll <- cbind(dataSubjectAll, dataActivityAll)
Data <- cbind(dataFeatures, dataAll)

## Extract mean and standard deviation
subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)
str(Data)

## Assign labels to data elements
activityLabels <- read.table(file.path(path, "activity_labels.txt"),header = FALSE)

names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))
names(Data)

##Create a second independent tidy data set
install.packages("plyr")
library(plyr)
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)
Data2






