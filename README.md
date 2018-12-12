** You should include a README.md in the repo describing how the script works **

How the run_analysis script works: 

1. clears the working environment

2. the script then loads the dplyr and readr packages from the library (if you don't have these packages, please intall 

		using the command install.packages("dplyr") and install.packages("readr"))

3. the script then reads in the downloaded data into the environment using read_table2 

4. the created data frames at this point are called:

		a. x_train - the main training data measurements

		b. y_train - the activity codes for each measurement 

		c. subject_train - the list of subjects who carried out each training exercise

		d. x_test - the main testing data measurements

		e. y_test - the activity codes for each measurement

		f. subject_test - the list of subjects who carried out each test exercise

		g. features - a list of the headings for the data measurements

5. 	if the data has not been downloaded and the folder put into the working directory, you can download the data using a 

		command such as fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "

		download.file(fileURL, 'filename', method="curl")

6. Next, the script adds column headers to the main data frames. 

7. The data is then joined into one data frame using cbind and rbind

8. Extract the mean and standard deviation coulmns from the data frame, excluding the directional x,y,z data and any duplicate columns.
	Here the magnitude of the 3 directions has been summarised using a mean calculated using the Eucliden norm. Therefore,
	individual directions are not really required (or asked for!) 

9. Rename the numbered activies using descriptive names (walk, walkup, walkdown, sit, stand, lay). 

10. Rename some of the dodgy measurement column headers. 

11. Group the data frame by subject and activity. 

12. Calculate the measurement mean from each grouped set of rows.

13. Write the tidy data containing the average of each of the selected columns out to a text file 'tidydata.txt'   



Used websites and references: 

https://datacarpentry.org/R-genomics/04-dplyr.html

https://thoughtfulbloke.wordpress.com/2015/09/09/getting-and-cleaning-the-assignment/

Wickham & Grolemund (2017) - 'R for Data Science', O'Reilly
