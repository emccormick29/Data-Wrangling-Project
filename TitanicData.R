library(dplyr)
#1: Port of embarkation
#The embarked column has some missing values, which are known to correspond to passengers who 
#actually embarked at Southampton. Find the missing values and replace them with S. 
#(Caution: Sometimes a missing value might be read into R as a blank or empty string.)
titanic <- tbl_df(titanic3)
titanic1 <- titanic %>% mutate(embarked = ifelse(is.na(embarked), 'S', embarked))

#2 Age
#You’ll notice that a lot of the values in the Age column are missing. 
#While there are many ways to fill these missing values, using the mean or median of the rest 
#of the values is quite common in such cases.
#Calculate the mean of the Age column and use that value to populate the missing values
#Think about other ways you could have populated the missing values in the age column. 
#Why would you pick any of those over the mean (or not)?
mean_age <- mean(titanic1$age, na.rm = TRUE)
median_age <- median(titanic1$age, na.rm = TRUE)
titanic2 <- titanic1 %>% mutate (age = ifelse(is.na(age), mean_age, age))

#Other ways to populate- is there a way to populate with a distribution of the other values we have? This 
#could be more accurate than a mean.

#3:You’re interested in looking at the distribution of passengers in different lifeboats, 
#but as we know, many passengers did not make it to a boat :-( 
#This means that there are a lot of missing values in the boat column. 
#Fill these empty slots with a dummy value e.g. the string 'None' or 'NA'

titanic3 <- titanic2 %>%mutate(boat, ifelse(is.na(boat), 'None', boat))

#4:You notice that many passengers don’t have a cabin number associated with them.
#Does it make sense to fill missing cabin numbers with a value?
#What does a missing value here mean?
#You have a hunch that the fact that the cabin number is missing might be a useful indicator of survival. 
#Create a new column has_cabin_number which has 1 if there is a cabin number, and 0 otherwise.

#It doesn't make sense to fill cabin numbers with a value because perhaps they were crew? If we think that a cabin number missing
#is an indicator of survival, we can create a boolean for the cabin number variable rather than assigning a 'random' one.

titanic4 <- titanic3 %>% mutate(is_cabin_number = ifelse(is.na(cabin), 0,1))

write.csv(titanic4, 'titanic_clean.csv')