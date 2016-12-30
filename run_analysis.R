library(plyr)

# 1. Merge the training and the test sets to create one data set
# Load train sets
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/Y_train.txt")
subjects_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

# Load test sets
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/Y_test.txt")
subjects_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

# Merge data sets
x_data <- rbind(x_train, x_test) #merge x data sets
y_data <- rbind(y_train, y_test) #merge y data sets
subjects_data <- rbind(subjects_train, subjects_test) #merge subjects data sets

# 2. Extract only the measurements on the mean and standard deviation for each measurement
features <- read.table("UCI HAR Dataset/features.txt")
mean_and_std <- grep("-(mean|std)\\(\\)", features[, 2])  #get column with mean or std in their names

x_data <- x_data[, mean_and_std] #subset of desired columns
names(x_data) <- features[mean_and_std, 2] #replace with correct column names

# 3. Use descriptive activity names to name the activities in the data set
activities <- read.table("UCI HAR Dataset/activity_labels.txt")
y_data[, 1] <- activities[y_data[, 1], 2] #replace with correct activity name
names(y_data) <- "activity" #replace with correct column name

# 4. Appropriately label the data set with descriptive variable names.
names(subjects_data) <- "subject" #replace with correct column name

all_data <- cbind(x_data, y_data, subjects_data) #combine all datasets

# 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject.
averages_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(averages_data, "averages_data.txt", row.name=FALSE)
