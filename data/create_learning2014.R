# Agata Dominowska
# 15.11.2017
# This file contains the R code for IODS 2017: Exercise 2.

### Data wrangling

## 1.Create a folder named ‘data’ in your IODS-project folde, create a new  R script with RStudio. Write your name, date and a one sentence file description as a comment on the top of the script file. Save the script for example as 'create_learning2014.R' in the ‘data’ folder. - Done! 

## 2. Read the full learning2014 data from the given URL into R and explore the structure and dimensions of the data.

learning2014 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

# The first function, dim(), explores the dimensions of the data. It allows us to see how many rows and columns there are in our data frame. There are 183 rows and 60 columns.
# The second function, str(), shows the structure of the data.

dim(learning2014)
str(learning2014)

## 3. Create an analysis dataset with the variables gender, age, attitude, deep, stra, surf and points by combining questions in the learning2014 data.

# Install the dplyr package and access it.
# install.packages("dplyr") - only used it the first time round.
library(dplyr)

# Combine questions related to deep, surface and strategic learning, as described here: http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-meta.txt
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# Scale all combination variables to the original scales (by taking the mean).

# select the columns related to deep learning and create column 'deep' by averaging
deep_columns <- select(learning2014, one_of(deep_questions))
learning2014$deep <- rowMeans(deep_columns)

# select the columns related to surface learning and create column 'surf' by averaging
surface_columns <- select(learning2014, one_of(surface_questions))
learning2014$surf <- rowMeans(surface_columns)

# select the columns related to strategic learning and create column 'stra' by averaging
strategic_columns <- select(learning2014, one_of(strategic_questions))
learning2014$stra <- rowMeans(strategic_columns)

# Exclude observations where the exam points variable is zero. 
# To actually include all observations other than zero, one could use Points != 0, but negative exam results are rather improbable :)
learning2014 <- filter(learning2014, Points > 0)

# Keep only wanted columns and create the analysis dataset. 
keep_columns <- c("gender", "Age", "Attitude", "deep", "surf", "stra", "Points")
learning2014 <- select(learning2014, one_of(keep_columns))

# Prettify the column names in the dataset: change initial letters to small.
colnames(learning2014)[2] <- "age"
colnames(learning2014)[3] <- "attitude"
colnames(learning2014)[7] <- "points"

# The data should now have 166 observations and 7 variables. 
dim(learning2014)
str(learning2014)

#And it does! \o/

## 4. Set the working directory of you R session to the IODS project folder (study how to do this with RStudio).

# Check the current working directory...
getwd()

#...and change it to the project folder.
setwd("C:\Users\myProfile\Documents\GitHub\IODS-project\data")

# Save the analysis dataset to the ‘data’ folder, using write.table() function. 
# You can name the data set for example as learning2014(.txt or .csv). See ?write.csv for help or search the web for pointers and examples. 
write.table(learning2014, file = "learning2014.csv", sep = "\t", col.names = TRUE)

# Demonstrate that you can also read the data again by using read.table() or read.csv().  
read.table("learning2014.csv", header = TRUE, sep = "\t")

# Use `str()` and `head()` to make sure that the structure of the data is correct.
str(learning2014)
head(learning2014)

# Seems to be working just fine.





