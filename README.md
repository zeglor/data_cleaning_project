# Getting and Cleaning Data project

## Description
This repository contains data files provided by http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones study and script for processing those into clean dataset. "Clean" assumes that data should be easy to deal with in future explorations.

## Files
* Folder _data_ contains unzipped the original data.
* File _run_analysis.R_ is an R script for transforming data into tidy dataset.
* File _tidy_set.csv_ is the result tidy dataset.
* File _README.md_ - name speaking for itself :)

## Tidy set data
For this project we take all aggregate variables from the original data set - that is, variables without postfixes [X,Y,Z]. The reason is x,y,z dimensions aren't that useful for studying overall behaviour, and they may vary across devices, subjects or even measurements - authors don't specify axes positioning. We also merge measurements data with subject id and activity name, so that future studies could dig into similarity/distinction patterns across those variables more easily. Detail description of variables in resulting file can be found in _data_book.md_ file.

## Processing data algorithm
_run_analysis.R_ script uses function __Get.Dataset(path.to.data, set.type)__ to obtain pre-processed test and train sets.  
Then those two datasets are merged into one __data.full__ and ordered by subject and activity name.  
After that, we create __tidy.set__ by copying the needed variables from __data.full__ into it.  
And the last step of the algorithm is to aggregate data in __tidy.set__ by subject index and activity name, having only mean values of variables for each row.  
Well, really the last step is to copy __tidy.set__ into __tidy_set.csv__  

### function __Get.Dataset(path.to.data, set.type)__
The core function of _run_analysis.R_ script is __Get.Dataset(path.to.data, set.type)__. It takes 2 arguments: __path.to.data__ (path to root folder of the original dataset ending with "/") and __set.type__ ("test" or "train" depending on which dataset you wish to obtain), both being mandatory. The function returns pre-processed data.frame, containing measurements data merged with subject and activity information having proper variable names provided. Function assumes that your data folder has following files :
* ./features.txt
* ./activity_labels.txt
* ./test/X_test.txt
* ./test/y_test.txt
* ./test/subject_test.txt
* ./train/X_train.txt
* ./train/y_train.txt
* ./train/subject_train.txt

First the function creates all the needed paths to files and checks if all the files exist.  
If they do, it first loads rownames and cleans them up: replaces punctuation character with ".", then merges all repeating "." into single, then trails head and tail ".".  
Then function loads actual measurements from file x[test, train].txt depending on __set.type__ value.  
Then it loads subject ids and attaches them to dataset.  
Then function loads activity codes and also aataches them to dataset. Then we load table with activity code - activity name values and merge it with dataset.  
Column with data codes is removed from dataset, and dataset is returned.  