setwd("F:/programming/R/coursera_r/getting_cleaning_data/data_cleaning_project/")
getwd()

Get.Dataset <- function(path.to.data, set.type){
    #set filepath variables
    path.features <- paste(path.to.data, "features.txt", sep="")
    path.X <- paste(path.to.data, set.type, "/X_", set.type, ".txt", sep="")
    path.Y <- paste(path.to.data, set.type, "/y_", set.type, ".txt", sep="")
    path.subject <- paste(path.to.data, set.type, "/subject_", set.type, ".txt", sep="")
    path.activity <- paste(path.to.data, "activity_labels.txt", sep="")
    
    #check that all needed files exist
    if(any(!file.exists(path.features, path.X, path.Y, path.subject, path.activity)))
    {
        stop("Couldn't find one or more data files needed. Please check your input path and set type.")
    }
    
    #get rownames for x
    set.rowNames <- as.vector(read.table(file=path.features)$V2)
    #cleanup row names a little
    set.rowNames <- gsub("[[:punct:]]", ".", set.rowNames)
    set.rowNames <- gsub("[.]{2,}", ".", set.rowNames)
    set.rowNames <- gsub("[.]$", "", set.rowNames)
    set.rowNames <- gsub("^[.]", "", set.rowNames)
    
    #get x set
    x.set <- read.table(file=path.X, col.names=set.rowNames)
    #get subjects
    subject.set <- read.table(file=path.subject, col.names="Subject")
    
    x.set <- cbind(x.set, subject.set)
    
    #get activities
    activity.codes <- read.table(file=path.Y)
    activity.labels <- read.table(file=path.activity, 
                                  col.names=c("activity.Code", "Activity"))
    
    #add activity codes to x.set and assign each row a proper activity name
    x.set <- cbind(x.set, activity.codes)
    x.set <- merge(x.set, activity.labels, by.x="V1", by.y="activity.Code")
    
    #return set without activity codes
    x.set[, !(names(x.set) %in% c("V1"))]
}

data.set.test <- Get.Dataset("F:/programming/R/coursera_r/getting_cleaning_data/project/data/", 
                          "test")
data.set.train <- Get.Dataset("F:/programming/R/coursera_r/getting_cleaning_data/project/data/", 
                           "train")

data.full <- rbind(data.set.test, data.set.train)
data.full <- data.full[order(data.full$Subject, data.full$Activity), ]

row.Names <- names(data.full)
sub.vec <- setdiff(grep("mean", row.Names), grep("[X,Y,Z]", row.Names))
sub.vec <- c(sub.vec, setdiff(grep("std", row.Names), grep("[X,Y,Z]", row.Names)))

#sub.vec <- c(grep("mean.[X,Y,Z]", row.Names), grep("std.[X,Y,Z]", row.Names))

tidy.set <- x.full[, sub.vec]
tidy.set <- cbind(tidy.set, x.full["Subject"])
tidy.set <- cbind(tidy.set, x.full["Activity"])

tidy.set <- aggregate(. ~ Subject + Activity, tidy.set, mean)
tidy.set <- tidy.set[order(tidy.set$Subject, tidy.set$Activity), ]

write.csv(tidy.set, file="./tidy_set.csv", row.names=FALSE)