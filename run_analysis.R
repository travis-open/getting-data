## This function requires the working directory to include the raw data from Samsung, downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
## This function also requires the reshape2 package to be installed. Please install using install.packages("reshape2") if you have not previously done so.

run_analysis<-function(){
require(reshape2)
subject_test<-read.table("test/subject_test.txt")     ## Data are read in from individual text files.
X_test<-read.table("test/X_test.txt")               
Y_test<-read.table("test/Y_test.txt")               
subject_train<-read.table("train/subject_train.txt")  
X_train<-read.table("train/X_train.txt")              
Y_train<-read.table("train/Y_train.txt")              
labels<-read.table("activity_labels.txt")
features<-read.table("features.txt")
test_frame<-cbind(subject_test,Y_test,X_test)         ## Data are combined into a single "big_frame"
train_frame<-cbind(subject_train,Y_train,X_train)
big_frame<-rbind(test_frame,train_frame)
colnames(big_frame)[1:2]<-c("subject","activity")     ## column names are created
colnames(big_frame)[3:563]<-as.character(features[ ,2])
keepers<-sort(c(1,2,grep("mean",colnames(big_frame)),grep("std",colnames(big_frame)))) ## Mean and standard deviations are
big_frame<-big_frame[,keepers]                                                         ## kept. Other columns discarded.
big_frame<-merge(big_frame, labels, by.x="activity", by.y="V1",sort = FALSE)           ## descriptive "activities" variable appended
colnames(big_frame)[82]<-"activities"
vars<-colnames(big_frame)[3:81]
melted<-melt(big_frame,id=c("subject","activities"),measure.vars=vars)        ## Data are melted according to "subject" & "activities"
casted2<-dcast(melted, subject + activities ~ variable, mean)                 ## mean values of each variable for each activity and each subject are created
write.table(casted2, file = "tidy.txt", row.name=FALSE)                       ## Data are saved in the workspace as a text file.


}