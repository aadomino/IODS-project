# Data wrangling
# R Exercise 4 & 5, 29.11.2017 & 6.12.2017, Agata Dominowska


# Set the working directory to be the IODS project folder:
setwd("C:/Users/P8Z77-V/Documents/GitHub/IODS-project/data")

# Access libraries
library(dplyr)
library(stringr)

# "Human development" and "Gender inequality" files:

hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

str(hd)
dim(hd)
summary(hd)

str(gii)
dim(gii)
summary(gii)

# There are 8 variables and 195 observations in hd, a variable describing countries ranked based on human development index.

# There are 10 variables and 195 observations in gii, countries' ranking based on gender inequality index.

# Rename the columns of hd and then gii

colnames(hd)[1] <- "HDIrank"
colnames(hd)[2] <- "Country"
colnames(hd)[3] <- "HDI"
colnames(hd)[4] <- "Life.Exp"
colnames(hd)[5] <- "Edu.Exp"
colnames(hd)[6] <- "Edu.Mean"
colnames(hd)[7] <- "GNI"
colnames(hd)[8] <- "diffGNIrankHDIrank"

colnames(gii)[1] <- "GIIrank"
colnames(gii)[2] <- "Country"
colnames(gii)[3] <- "GII"
colnames(gii)[4] <- "Mat.Mor"
colnames(gii)[5] <- "Ado.Birth"
colnames(gii)[6] <- "Parli.F"
colnames(gii)[7] <- "Edu2.F"
colnames(gii)[8] <- "Edu2.M"
colnames(gii)[9] <- "Labo.F"
colnames(gii)[10] <- "Labo.M"

# Ratios of gender vs secondary education and labour force participation in the gi data.

Edu2.FM <- gii$Edu2.F/gii$Edu2.M
Labo.FM <- gii$Labo.F/gii$Labo.M

gii$Edu2.FM <- Edu2.FM
gii$Labo.FM <- Labo.FM

# Join the two data sets by country.

human <- inner_join(hd, gii, by = c("Country"))

# Look at the joined data.

str(human)
dim(human)

# There are now 19 variables in the joined data. The number of coutries is the same, yay.

# Save the data

write.csv(human, file = "human.csv", row.names = FALSE)

#################### Exercise 5

# Read the data into R:
human <- read.table("human.csv", header = TRUE, sep = ",")

# Check that the data is ok and has the right dimensions: 195 observations and 19 variables.
str(human)
dim(human)

# 1. Transform gni to numeric:

# Look at the structure of the GNI column in 'human'
str(human$GNI)

# Make it numeric by removing the commas from GNI and using the pipe operator as.numeric
str_replace(human$GNI, pattern=",", replace ="") %>% as.numeric(human$GNI)
human$GNI <- as.numeric(human$GNI)

# 2. Exclude unnecessary variables and choose columns to keep:
keep <- c("Country", "Edu2.FM", "Labo.FM", "Life.Exp", "Edu.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")
human <- dplyr::select(human, one_of(keep))

# There should be 195 observations & 9 variables, and yes there are.
glimpse(human)

# 3. Remove missing values:

# Print out the dataframe along with a completeness indicator as the last column:
data.frame(human[-1], comp = complete.cases(human))

# Filter out all rows with NA (not available, i.e. nonexistent) values:
human_ <- filter(human, complete.cases(human))

# There are now 162 observations & 9 variables in our data: 
glimpse(human_)

# 4. Remove observations that are related to regions instead of countries:

# "Country" includes regions, which are the last 7 observations
human_$Country

# Define the last indice we want to keep:
last <- nrow(human_) - 7

# Choose everything until the last 7 observations
human_ <- human_[1:last, ]

# With the regions removed, there are 155 observations & 9 variables:
human_$Country
glimpse(human_)

# 5. Finishing touches: define country names as row names and remove the country name columm before saving the data

# Define countries as rownames and remove the Country variable
rownames(human_) <- human_$Country
human_ <- dplyr::select(human_, -Country)

# The data should now have 155 observations and 8 variables. It does.
glimpse(human_)

# Save the human data in your data folder including the row names. You can overwrite your old ‘human’ data. 

# Save the data set:
write.table(human_, file = "human.csv", sep = ",", col.names = TRUE, row.names = TRUE )

glimpse(human_)


