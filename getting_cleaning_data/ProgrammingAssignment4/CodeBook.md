# Code Book

This file contains a description of the variables and data used in the analysis.

## Data

Data can be recovered at the [UCI Machine Learning Repository](https://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) and contains data on human activity recognition using smartphones (experiments performed in 2012).

The script `run_analysis.R` performs the following steps:

0. it downloads the file containing training and test data from the repository (unless it is already present in the directory) and unzips it,
1. it reads the dataset and merges training and test sets using `rbind` (it also provides appropriate names for the columns),
2. it extracts only measurements containing average and standard deviations,
3. it assigns human readable activity names to the activity dataset using the dictionary provided in the `activity_labels.txt` file,
4. it then removes non human readable labels and merges (with `cbind`) the features, the activity and the subject performing it,
5. it creates a new tidy dataset containing the average of each feature grouped by subject and kind of activity.

## Files

Inside the unzipped `UCI HAR Dataset` directory we find:

- **training data**: `train/X_train.txt`, `train/y_train.txt`, `train/subject_train.txt` containing features (with placeholder column names), activity labels and the subject performing the activity,
- **test data**: `test/X_test.txt`, `test/y_test.txt`, `test/subject_test.txt` with the same content, used for testing,
- **features**: `features.txt` contains the names of the features, `features_info.txt` contains their descriptions,
- **labels**: `activity_labels.txt` contains the dictionary of the labels.

## Variables

Variables used include:

- `db_url`, `out_file` to manage the remote location of the dataset and the local destination,
- `features`, `activities` to hold the names of the features and the labels according to the dictionaries provided,
- `x_train`, `y_train`, `s_train` contain the training data for features, labels and the subjects,
- `x_test`, `y_test`, `s_test` contain the respective test data,
- `x_dat`, `y_dat`, `s_dat` are the merged versions of training and test data using `rbind`,
- `data` is the variable containing the full dataset after `cbind`-ing features, labels and subjects (it uses the instrument and measurements names as columns referring to the features, "Activity" for the column linked to `y_dat`, "Subject" for the column linked to `s_dat`),
- `avg_dat` holds the average of the features grouped by subject and kind of activity.

`avg_dat` is then output to `tidy_dataset.txt` using `write.table`.
