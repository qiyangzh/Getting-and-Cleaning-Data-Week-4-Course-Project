#set everything up
setwd("~/Desktop/Coursera/Getting-and-Cleaning-Data-Week-4-Course-Project/UCI HAR Dataset")
library(data.table)
library(dplyr)

#read the activitity files
ActivityTest <- read.table("./test/y_test.txt", header = F)
ActivityTrain <- read.table("./train/y_train.txt", header = F)

#read the features files
FeaturesTest <- read.table("./test/X_test.txt", header = F)
FeaturesTrain <- read.table("./train/X_train.txt", header = F)

#read subject files
SubjectTest <- read.table("./test/subject_test.txt", header = F)
SubjectTrain <- read.table("./train/subject_train.txt", header = F)

#read activity labels
ActivityLabels <- read.table("./activity_labels.txt", header = F)

#read deature names
FeaturesNames <- read.table("./features.txt", header = F)

#merge
FeaturesData <- rbind(FeaturesTest, FeaturesTrain)
SubjectData <- rbind(SubjectTest, SubjectTrain)
ActivityData <- rbind(ActivityTest, ActivityTrain)

#rename
names(ActivityData) <- "ActivityName"
names(ActivityLabels) <- c("ActivityName", "Activity")

Activity <- left_join(ActivityData, ActivityLabels, "ActivityName")[, 2]

names(SubjectData) <- "Subjectname"
names(FeaturesData) <- FeaturesNames$V2

#create a large data set
DataSet <- cbind(SubjectData, Activity)
DataSet <- cbind(DataSet, FeaturesData)

subFeaturesNames <- FeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", FeaturesNames$V2)]
DataNames <- c("Subjectname", "Activity", as.character(subFeaturesNames))
DataSet <- subset(DataSet, select=DataNames)

names(DataSet)<-gsub("^t", "time", names(DataSet))
names(DataSet)<-gsub("^f", "frequency", names(DataSet))
names(DataSet)<-gsub("Acc", "Accelerometer", names(DataSet))
names(DataSet)<-gsub("Gyro", "Gyroscope", names(DataSet))
names(DataSet)<-gsub("Mag", "Magnitude", names(DataSet))
names(DataSet)<-gsub("BodyBody", "Body", names(DataSet))

SecondDataSet<-aggregate(. ~Subjectname + Activity, DataSet, mean)
SecondDataSet<-SecondDataSet[order(SecondDataSet$Subject,SecondDataSet$Activity),]

write.table(SecondDataSet, file = "tidydata.txt",row.name=FALSE)


