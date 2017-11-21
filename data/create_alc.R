# Agata Dominowska
# 22.11.2017
# This file contains the R code for IODS 2017: Exercise 3.

# Setting working directory to the current one:
setwd("C:\\Users\\myProfile\\Documents\\GitHub\\IODS-project\\data")

# 2. The data used in this exercise comes from this source: https://archive.ics.uci.edu/ml/machine-learning-databases/00320/
# Relevant dataset information can be found under this link: https://archive.ics.uci.edu/ml/datasets/Student+Performance
# The datasets contain questionnaire results

# 3. Read both student-mat.csv and student-por.csv into R (from the data folder).
mat <- read.table("student-mat.csv", header = TRUE, sep = ";")
por <- read.table("student-por.csv", header = TRUE, sep = ";")

# Explore the structure and dimensions of the data.
dim(mat)
str(mat)
head(mat)

dim(por)
str(por)
head(por)

# The mat data frame has 395 observations and 33 variables, 
# while por includes 649 observations and 33 variables.
# The same variables are used in both datasets.

# 4. Join the two data sets using the variables "school", "sex", "age", "address", "famsize", "Pstatus", "Medu", "Fedu", 
# "Mjob", "Fjob", "reason", "nursery","internet" as (student) identifiers. Keep only the students present in both data sets. 
# Explore the structure and dimensions of the joined data.

# Access the dplyr library.
library(dplyr)

# Point to relevant variables (indicating which students replied to both questionnaires).
joint_variables <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")

# Join both datasets by selected identifiers.
mat_por <- inner_join(mat, por, by = joint_variables, suffix = c(".mat", ".por"))

# Have a look at the new dataset.

dim(mat_por)
str(mat_por)
head(mat_por)
# The new data set has 382 observations on 53 variables.

# 5. Copy the solution from the DataCamp exercise The if-else structure (https://campus.datacamp.com/courses/helsinki-open-data-science/logistic-regression?ex=3)
# to combine the 'duplicated' answers in the joined data.

# print out the column names of 'math_por'
colnames(mat_por)

# create a new data frame with only the joined columns
alc <- select(mat_por, one_of(joint_variables))

# the columns in the datasets which were not used for joining the data
notjoined_columns <- colnames(mat)[!colnames(mat) %in% joint_variables]

# print out the columns not used for joining
notjoined_columns

# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(mat_por, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}

# Glimpse at the new combined data:
glimpse(alc)


# 6. Take the average of the answers related to weekday and weekend alcohol consumption 
# to create a new column 'alc_use' to the joined data. 
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)


# Then use 'alc_use' to create a new logical column 'high_use' which is TRUE for students for which 'alc_use' is greater than 2 (and FALSE otherwise).
alc <- mutate(alc, high_use = alc_use > 2)

# 7. Glimpse at the joined and modified data to make sure everything is in order. 
glimpse(alc)

# The joined data should now have 382 observations of 35 variables. 

# It does! \o/

# Save the joined and modified data set to the ‘data’ folder, using for example write.csv() or write.table() functions.

write.table(alc, file = "alc.csv", sep = ";", col.names = TRUE)







