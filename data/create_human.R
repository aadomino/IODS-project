# Data wrangling
# R Exercise 4 (but data for the next week), 29.11.2017, Agata Dominowska

library(dplyr)

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

# There are 10 variables and 195 observations in gi, countries' ranking based on gender inequality index.

# Rename the columns of hd and then gi.

colnames(hd)
colnames(hd) <- c("hdrank", "country", "hdi", "le", "expedu", "meanedu", "gni", "gnihdi")
colnames(hd)

colnames(gii)
colnames(gii) <- c("giirank", "country", "gii", "matmort", "adolbirthrate", "parliament", "f2edu", "m2edu", "flabour", "mlabour")
colnames(gii)

# Ratios of gender vs secondary education and labour force participation in the gi data.

gii <- mutate(gii, edu2ratio = f2edu / m2edu)
gii <- mutate(gii, labratio = flabour / mlabour)

# Join the two data sets by country.

human <- inner_join(hd, gii, by = "country")

# Look at the joined data.

str(human)
dim(human)

# There are now 19 variables in the joined data. The number of coutries is the same, yay.

#Save the data

write.csv(human, file = "human.csv", row.names = FALSE)