#Getting and Cleaning Data Project: Code Book
### Ivette C. Martínez

## 1. Original Data
Original Data set is available here:
<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>


## 2. Merged Data Set
1. To buid the merged data set we use the following files (at "./data/UCI HAR DATASET"):

1.1. For Features data: 
 * "train/X_train.txt"                           
 * "test/X_test.txt"   
 * "features.txt"  (Variable Names)

1.2. For the Activity data:
 * "train/y_train.txt" 
 * "test/y_test.txt"
 
1.3. For Subjects data:
 * "train/subject_train.txt" 
 * "train/subject_train.txt" 

2. We store the merged data into the *completeTable* variable. 

- completeTable's colums order is: 

 "subject", "activity", [feature_1], ... , [feature_n]"

- where [feature_i] is the i-name of a featue at the second column of "features.txt"

- completeTable has 10299 rows and 563 colums


## 3. Selected Data Set (Result of the project' step 4)

1. From *completeTable* we selected the first two columns (subject and activity), along with the fetuatures that have "mean()" or std()" in their names. We store the resulting table into the *selectedData* variable. It has 10299 rows and 68 columns.

2. Using the labels from the second column of *activity_labels.txt* we replace the numeric values on *"activiy"* column by their respective descriptive string. 

3. We modify features columns' labels to made them more readable, by replacing the following substrings:

- "f" -> "frequency"
- "t" -> "time"
- "mean()" -> "mean"
- "std()" -> "std"
- "Acc" -> "Accelerometer"
- "Gyro" ->"Gyroscope"
- "Mag" -> "Magnitude"
- "BodyBody" -> "Body"

## 4. Final Tidy Data Set (With mean for each variable on the SelectedDataSet Group by subject and activity)
 
The final tidy data set was the result of gruoping *selectedData* by *subject* and *activity* and calculating the mean for the rest of columns. It was stored into the 
*groupData* variable, and stored into the *Tidy.txt* file

