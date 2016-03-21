# Unzip "UCI HAR Dataset.zip" into a Directory ./UCI HAR Dataset/
#Load dply and tidyr libraries
library(dplyr)
library(tidyr)

# Load the train, test and subject data into data frames
x_train_data <-  read.table("./UCI HAR Dataset/train/X_train.txt")
y_train_labels <-  read.table("./UCI HAR Dataset/train/y_train.txt") 
subj_train <- read.table("./UCI HAR Dataset/train/subject_train.txt") 
x_test_data <-  read.table("./UCI HAR Dataset/test/X_test.txt")
y_test_labels <-  read.table("./UCI HAR Dataset/test/y_test.txt") 
subj_test <- read.table("./UCI HAR Dataset/test/subject_test.txt") 

# Load activity labels and feature labels into data frames
activity_labels <-  read.table("./UCI HAR Dataset/activity_labels.txt")
names(activity_labels) <- c("IDs", "activity")
features <-  read.table("./UCI HAR Dataset/features.txt")
names(features) <- c("IDs", "var_labels")

# Combine the data, subjects and labels and 
x_comb_data <- rbind(x_train_data, x_test_data)
y_comb_lbls <- rbind(y_train_labels, y_test_labels)
subj_data <- rbind(subj_train, subj_test)


# Index the features and extract the means and stds
ix_features <- grep("?mean\\()*|?std\\()?", features$var_labels)
x_comb_data <- x_comb_data[, ix_features]

# Add the labels to the activities and the subjects
y_comb_lbls[, 1] = activity_labels[y_comb_lbls[, 1], 2]
names(y_comb_lbls) <- "Activity"
names(subj_data) <- "Subject"

# Putting it all together for one tidy data set
AllCombo <- cbind(subj_data, y_comb_lbls, x_comb_data)
write.csv(AllCombo, file = "./UCI HAR Dataset/AllCombo.csv")


# Take averages of all variable by activity and subject
len_AllCombo <- length(AllCombo)
mns_stds_vars <- AllCombo[,3:len_AllCombo]
AllCombo_avgs <- aggregate(mns_stds_vars, list(AllCombo$Subject, AllCombo$Activity), mean)
names(AllCombo_avgs) <- names(AllCombo)
write.csv(AllCombo_avgs, file = "./UCI HAR Dataset/AllCombo_avgs.csv")

