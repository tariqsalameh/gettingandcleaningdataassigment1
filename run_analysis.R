setwd("D:\\TRQ\\Resources\\R-Scripts\\R-Scripts\\gettingandcleaningdataassigment1")
if(!file.exists("./merged")){dir.create("./merged")}

#install.packages("plry")
#library(plry)

#Reading features and activity Data
activitylabel<-read.table("activity_labels.txt",header = FALSE)
names(activitylabel)<-c("id","description")
features<-read.table("features.txt",header = FALSE)
names(features)<-c("id","description")



#Reading Test Data
X_test<-read.table("./test/X_test.txt",header = FALSE)
Y_test<-read.table("./test/Y_test.txt",header = FALSE)
subject_test<-read.table("./test/subject_test.txt",header = FALSE)
names(Y_test)<-c("activity_id")
names(subject_test)<-c("subject_id")
#Reading Train Data
X_train<-read.table("./train/X_train.txt",header = FALSE)
Y_train<-read.table("./train/Y_train.txt",header = FALSE)
subject_train<-read.table("./train/subject_train.txt",header = FALSE)
names(Y_train)<-c("activity_id")
names(subject_train)<-c("subject_id")

#giving names for measures
names(X_test)<-features$description
names(X_train)<-features$description

X_merged<-rbind(X_test,X_train)
Y_merged<-rbind(Y_test,Y_train)
subject_merged<-rbind(subject_test,subject_train)

write.table(X_merged,file = "./merged/X_merged.txt")
write.table(Y_merged,file = "./merged/Y_merged.txt")
write.table(subject_merged,file = "./merged/subject_merged.txt")

#names(X_merged) %in% ("mean","std")
library(stringr)
#str_detect(names(X_merged),"std") | str_detect(names(X_merged),"mean")

colIndex<-features[str_detect(names(X_merged),"std") | str_detect(names(X_merged),"mean"),]$id
X_select<-X_merged[,colIndex]
xy_sub_merged<-cbind(X_select,Y_merged)
xy_sub_merged<-cbind(xy_sub_merged,subject_merged)
#xy_sub_projected<-xy_sub_merged[,colIndex]

XY_projected_Activity<- merge(x = xy_sub_merged,y = activitylabel,by.x = "activity_id",by.y = "id",all = TRUE)
names(XY_projected_Activity)<-str_replace(str_replace(str_replace(names(XY_projected_Activity), pattern ="[(]" ,replacement = ""), pattern ="[)]" ,replacement = ""), pattern ="[-]" ,replacement = "")

dataColumns = names(XY_projected_Activity)[2:80]
groupColumns=c("activity_id","subject_id")
res = ddply(XY_projected_Activity,groupColumns, function(x) colMeans(x[dataColumns],na.rm=TRUE))

write.table(res,file = "./merged/avg_per_activity_subject.txt",row.names = FALSE)

##End of scripting 
