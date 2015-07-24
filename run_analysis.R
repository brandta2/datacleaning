setwd("R\\UCI HAR Dataset")

## Load in Datasets
## 1. Merges the training and the test sets to create one data set.

	xtrain = read.csv("train/X_train.txt", sep="", header=FALSE)
	ytrain = read.csv("train/Y_train.txt", sep="", header=FALSE)
	subjecttrain = read.csv("train/subject_train.txt", sep="", header=FALSE)

	xtest = read.csv("test/X_test.txt", sep="", header=FALSE)
	ytest = read.csv("test/Y_test.txt", sep="", header=FALSE)
	subjecttest = read.csv("test/subject_test.txt", sep="", header=FALSE)

#create x data
	x_data <-rbind(xtrain,xtest)

#create y data 
	labelsdata <- rbind(ytrain,ytest)

#create subject data
	subject_data <- rbind(subjecttrain,subjecttest)

# 2. Extract only the measurements on the mean and standard deviation for each measurement

	featurenames <- read.csv("features.txt",sep="", header=FALSE)

# get only columns with mean() or std() in their names
#add feature names as column names
	wantedfeatures <- grep("-(mean|std)\\(\\)", featurenames [, 2])

# subset the desired columns
	x_data <- x_data[, wantedfeatures ]

# wanted column names
names(x_data) <- featurenames[wantedfeatures , 2]


# 3. Uses descriptive activity names to name the activities in the data set
	activity <- read.table("activity_labels.txt")

# update values with correct activity names
	labelsdata [, 1] <- activity [labelsdata [, 1], 2]

# wanted column name
	names(labelsdata ) <- "activity"

# 4. Appropriately labels the data set with descriptive variable names.

	names(subject_data) <- "subject"

# all data put together
	alldata <-cbind(x_data, labelsdata , subject_data)

#5. From the data set in step 4, creates a second, independent tidy data set with the 
#   average of each variable for each activity and each subject

library(reshape2)
alldata $activity <- factor(alldata $activity, levels = activity[,1], labels = activity[,2])
alldata $subject <- as.factor(alldata $subject)

alldata.melted <- melt(alldata , id = c("subject", "activity"))
alldata.mean <- dcast(alldata.melted, subject + activity ~ variable, mean)

write.table(alldata.mean, "tidydata.txt", row.names = FALSE, quote = FALSE)


