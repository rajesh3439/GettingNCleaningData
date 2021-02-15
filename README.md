# GettingNCleaningData
CourseEra Getting and Cleaning data peer graded assignment

## Steps to run the script
1) Download the data from following link and unzip it to a seperate folder:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

2) Download run_analysis.R script and place it in the unzipped folder from Setp1

3) In R/R Studio set the folder in Step1 as working directory

4) Souce the script.

## Instructions for Loading tidydata.txt
1) The tidydata is stored to file with write.table function with column headers
2) Use header=TRUE with read.table `read.table('tidydata.txt', header=TRUE)` for reading the data
