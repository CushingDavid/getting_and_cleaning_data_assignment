## Getting and Cleaning Data - course assignment
## D. Cushing
##
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. From the data set in step 4, creates a second, independent tidy data set 
##     with the average of each variable for each activity and each subject.

# Clear the current Environment 
rm(list = ls())

# Attach required packages into the environment
# library(dbplyr)
library(dplyr)
library(readr)



# Read in the downloaded data from the UCI folder:

x_train <- read_table2("UCI HAR Dataset/train/X_train.txt", 
                       col_names = FALSE)
y_train <- read_table2("UCI HAR Dataset/train/y_train.txt", 
                       col_names = FALSE)
subject_train <- read_table2("UCI HAR Dataset/train/subject_train.txt", 
                       col_names = FALSE)
x_test <- read_table2("UCI HAR Dataset/test/X_test.txt", 
                       col_names = FALSE)
y_test <- read_table2("UCI HAR Dataset/test/y_test.txt", 
                      col_names = FALSE)
subject_test <- read_table2("UCI HAR Dataset/test/subject_test.txt", 
                             col_names = FALSE)
features <- read_table2("UCI HAR Dataset/features.txt", 
                        col_names = FALSE)
#4 - Appropriately labels the data set with descriptive variable names
# Sorry to put 4 up here - but it's just easier to manage!!!
# Name the correct column headings
# First attach the measurement column headers onto the measurements:
colheads <- as.data.frame(features[ ,2])
names(x_train) <- colheads[,1]
names(x_test) <- colheads[,1]

# Next, the activity and subject column headers:
colnames(subject_test)[1] <- "subject"
colnames(subject_train)[1] <- "subject"
colnames(y_test)[1] <- "activity"
colnames(y_train)[1] <- "activity"

#1 - Create one dataset including all of the recorded data:
train <- cbind(subject_train, y_train, x_train)
test <- cbind(subject_test, y_test, x_test)
dat_tot <- rbind(train, test)

#2 - Extract the mean and standard deviation data.
# Using only full (not directional) parameters.
# This method also removes any duplicates. 
datmean <- dat_tot[ ,grepl("mean()", colnames(dat_tot))]
datmean <- select(datmean, ends_with("mean()"))

datstd <- dat_tot[ ,grepl("std()", colnames(dat_tot))]
datstd <- select(datstd, ends_with("std()"))

meanstd <- cbind(dat_tot[,1], dat_tot[,2], datmean, datstd)
colnames(meanstd)[1] <- "subject"
colnames(meanstd)[2] <- "activity"

#3 - Rename the activies using descriptive names! 
meanstd$activity <- as.character(meanstd$activity)
meanstd$activity[meanstd$activity == "1"] <- "walk"
meanstd$activity[meanstd$activity == "2"] <- "walkup"
meanstd$activity[meanstd$activity == "3"] <- "walkdown"
meanstd$activity[meanstd$activity == "4"] <- "sit"
meanstd$activity[meanstd$activity == "5"] <- "stand"
meanstd$activity[meanstd$activity == "6"] <- "lay"

#4b - Appropriately labels the data set with descriptive variable names
# Here, you can replace some of the more unwieldy variables names using gsub:
names(meanstd)<-gsub("^t", "Time", names(meanstd))
names(meanstd)<-gsub("^f", "Freq", names(meanstd))
names(meanstd)<-gsub("BodyBody", "Body", names(meanstd))
names(meanstd)<-gsub("mean()", "mean", names(meanstd))
names(meanstd)<-gsub("std()", "std", names(meanstd))

#5 - From the data set in step 4, creates a second, independent tidy data set 
#     with the average of each variable for each activity and each subject.
#
# Use summarise_all to apply a function( in this case mean), to all the non-grouping columns 
meansummary <- (meanstd %>%
  group_by(subject,activity) %>%
  summarise_all(mean)
)

# Write the data to a text file - with tab separators:
write.table(meansummary, "tidydata.txt", sep="\t", row.names=F, col.names=T) 



