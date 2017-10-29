setwd("C:/Users/Sidoeri/datasciencecoursera/GettingAndCLeaningData/UCI HAR Dataset")

library(dplyr)

#import activity labels and features
activity_labels <- read.csv("activity_labels.txt", sep="", header = F)
features <- read.csv("features.txt", sep="", header = F)

#import test files
subject_test <-read.csv("test/subject_test.txt", sep="" , col.names = "subjectId", header = F)
X_test <-read.csv("test/X_test.txt", sep="", header = F)
y_test <-read.csv("test/Y_test.txt", col.names = "activityId", sep="", header = F)

#import train files
subject_train <-read.csv("train/subject_train.txt", sep="", col.names = "subjectId", header = F)
X_train <-read.csv("train/X_train.txt", sep="", header = F)
y_train <-read.csv("train/Y_train.txt", sep="", col.names = "activityId", header = F)

#combine test and train
completeSet <- rbind(X_test, X_train)
activityIds <-rbind(y_test, y_train)
subjectIds <- rbind(subject_test, subject_train)

#add appropriate labels to dataset
colnames(completeSet) <- features[,2]

#add subjectIds and activityIds to datasey
completeSet <- cbind(subjectIds, activityIds, completeSet)

#add activitynames to dataset and rearrange to tidy 
completeSet <- merge(activity_labels, completeSet, by.x = "V1", by.y = "activityId")
completeSet <- rename(completeSet, activityId = V1)
completeSet <- rename(completeSet, activity = V2)
completeSet <-arrange(completeSet, subjectId, activityId)
completeSet <- completeSet[,c(3, 2, 4:564)]

#subset all the columns related to mean and standard deviation
subSet <- completeSet[,c(1,2,grep(pattern = "mean|std", x=colnames(completeSet)))]
subSet <- subSet[,c(!grepl(pattern = "meanFreq", x=colnames(subSet)))]

#create tidy data set with the average of each variable for each activity and each subject
tidyData <- subSet %>%
            group_by( subjectId, activity) %>%
            summarise_each(funs(mean))

write.table(tidyData, "C:/Users/Sidoeri/datasciencecoursera/GettingAndCLeaningData/tidyData.txt", row.names = F)
