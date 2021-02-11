library(dplyr)

#download datasets

filepath <- "D:/gvsantonia/Documents/Coursera/R/Wk4_Final.zip"
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, filepath, method="curl")

#unzip file
if(!file.exists("UCI HAR Dataset")){
  unzip(filepath)
}

#read dataframes
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n", "functions"))               #list of functions
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))    #list of activity names
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/x_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/x_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

#merge training and testing sets
x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
subject <- rbind(subject_test, subject_train)
data_merge <- c(subject, x, y)
data_merge <- tbl_df(data_merge)

#create tidy_data using select
tidy_data <- select(data_merge, subject, code, contains("mean"), contains("std"))

#use descriptive activity names
tidy_data$code <- activities[tidy_data$code, 2]
colnames(tidy_data)[2]<-"activity"

#create subset data with average
Meantidydata <- tidy_data %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))

write.table(Meantidydata, "MeanTidyData.txt", row.names=FALSE)