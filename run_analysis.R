#For reading test data
a1<-read.table("./test/subject_test.txt")
a2<-read.table("./test/X_test.txt")
a3<-read.table("./test/y_test.txt")
#To combine all test data
a<-cbind(a1,a3,a2)
#To read train data
b1<-read.table("./train/subject_train.txt")
b2<-read.table("./train/X_train.txt")
b3<-read.table("./train/y_train.txt")
#To combine train data
b<-cbind(b1,b3,b2)
#To combine test and train data
c<-rbind(a,b)
#to read features
d<-read.table("./features.txt")
#To extract mean and std columns
p<-grep("mean\\(\\)|std\\(\\)",d$"V2")
#The following 2 lines are to account for the two added columns form cbind
z<-p+2
z<-c(1,2,z)
#Extracting only meand and std info
l<-c[,z]
#Next two line are for Converting factors to activities
gh<-sapply(l$"V1.1", function(x) if(x==1){x="WALKING"} else if(x==2){x="WALKING_UPSTAIRS"} else if(x==3){x="WALKING_DOWNSTAIRS"} else if(x==4){x="SITTING"} else if(x==5){x="STANDING"} else if(x==6){x="LAYING"})
l$"V1.1"<-gh
#Next 3 lines are for adding column names keeping in mind the 2 extra columns added through cbind
qw<-as.character(d[p,2])
qw<-c("Subject","TrainingLabels",qw)
colnames(l)<-qw
#all the following lines with names(l) make the data tidier
names(l)<-gsub("\\(|\\)","",names(l),perl=TRUE)
names(l)<-make.names(names(l))
names(l) <- gsub("Acc", "Acceleration", names(l))
names(l) <- gsub("^t", "Time", names(l))
names(l) <- gsub("^f", "Frequency", names(l))
names(l) <- gsub("BodyBody", "Body", names(l))
names(l) <- gsub("mean", "Mean", names(l))
names(l) <- gsub("std", "Std", names(l))
names(l) <- gsub("Freq", "Frequency", names(l))
names(l) <- gsub("Mag", "Magnitude", names(l))
#To group and summarize data
final<-ddply(l,c("Subject","TrainingLabels"),numcolwise(mean))
#To write the data in a .txt file           
write.table(final,file="tidydata.txt",row.name=FALSE)
