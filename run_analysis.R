# This script uses data.table & dplyr packages, following code block loads the package or
# installs it if it's not available
if(!require(data.table)){
    install.packages("data.table")
    # load data.table
    library(data.table)
}
if(!require(dplyr)){
    install.packages("dplyr")
    # load data.table
    library(dplyr)
}

# load training and testing data
features <- data.table::fread('features.txt', col.names = c('Id','variable'))
x_train <- data.table::fread('train/X_train.txt', sep = ' ', col.names = features[,variable]) 
y_train <- data.table::fread('train/y_train.txt', sep = ' ')
subject_train <- data.table::fread('train/subject_train.txt')
x_test <- data.table::fread('test/X_test.txt', sep = ' ', col.names = features[,variable]) 
y_test <- data.table::fread('test/y_test.txt', sep = ' ')
subject_test <- data.table::fread('test/subject_test.txt')

# STEP1: Merge Training and Testing datasets
# Substep: combine x, y & subject 
x_train[,activity:=y_train]
x_train[,subject:=subject_train]

x_test[,activity:=y_test]
x_test[,subject:=subject_test]

merged.measurements <- rbind(x_train,x_test)

# STEP2 : Extract only std & mean columns
req_cols = grep('(mean|std|activity|subject)', names(merged.measurements))
extracted_measurements <- merged.measurements[, ..req_cols]

# STEP3 : Descriptive activity names
activity_labels <- data.table::fread('activity_labels.txt')
step3 <- extracted_measurements[, activity:= activity_labels[,V2][activity]]

# Bring activity & subject columns to front for better readability
setcolorder(step3, c('subject','activity'))

# STEP4 : Descriptive variable names
cols <- names(step3)
# meaningful col names
cols <- sub('-','',cols)
cols <- sub('-','.',cols)
cols <- gsub('[()]','', cols)
cols <- sub('^t', 'time', cols)
cols <- sub('^f', 'frequency', cols)
colnames(step3)<- cols

# STEP5 : Average of each variable for each activity
step5 <- step3 %>% group_by(subject, activity) %>% 
        summarise(across(.cols = everything(), .fns = list(avg=mean))) %>% 
        rename_with(~gsub('_','.',.x))
step5 <- as.data.frame(step5)
# write date to file
#fwrite(step5, file='tidydata.txt')
write.table(step5, file='tidydata.txt', col.names = TRUE, row.names = FALSE)
