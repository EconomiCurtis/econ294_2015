#' ---
# title: Assignment 1 example script. 
# author: "Curtis Kephart"
# date: "Winter 2016"
# assignment: https://github.com/EconomiCurtis/econ294_2015/blob/master/Assignments/Econ_294_Assignment_1.pdf
# ---

# Grading
# Out of 10 points
# On time: 2 points (this will be much more important on next assignments)
# Script runs, 1 point
# Point on each question (7 questions). 0.5 points for minor error or incomplete
# 2 bonus points for having it turned in on git on time. 
# bonus points tox a few people that helped others out with RStudio+GitHub

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# 0
firstName <- "Curtis"
lastName  <- "Kephart"

print(
  paste(            #paste concactinates mult strings, check out ?paste for det.s
    firstName,
    lastName
  )
)

studentID <- "0142214"
print(studentID)

#' when I save this, and run `source(".../CurtisKephartAssignment1.R")` (with the correct file path)
#' it should return results that look --something-- like this: 
# > source('C:/Users/OKComputer/Dropbox/R Lab/econ294_2015/Assignments/CurtisKephartAssignment1.R')
# [1] "Curtis Kephart"
# [1] "0142214"
# > 

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# 1. 
library(foreign)
df.dta <- read.dta(
  "https://github.com/EconomiCurtis/econ294_2015/raw/master/data/NHIS_2007_dta.dta"
)

df.csv <- read.csv(
  "https://github.com/EconomiCurtis/econ294_2015/raw/master/data/NHIS_2007_CSV.csv",
  header = T
)

df.td <- read.table(
  file = "https://github.com/EconomiCurtis/econ294_2015/raw/master/data/NHIS_2007_TSV.txt",
  sep = "\t",
  header = T
) #few seemed to notice there was a header on this file

load(file = url("https://github.com/EconomiCurtis/econ294_2015/raw/master/data/NHIS_2007_RData.RData"))
# but what was this object's name?
# load opens the object, doesn't give you a chance to assign a value to it

#find the name
rdataName <- load(file = url("https://github.com/EconomiCurtis/econ294_2015/raw/master/data/NHIS_2007_RData.RData"))

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# 2
print(
  paste(
    "you could have just looked these up in your file explorer"
  )
)

FileSizes <- data.frame(
  Files = list.files("data"),
  FileSize = rep(NA,length(list.files("data")))
)

for (i in 1:length(FileSizes$Files)){
  FileSizes$FileSize[i] <- file.size(
    paste(
      "data/",
      FileSizes$Files[i],
      sep = ""
    )
  )
}

FileSizes

smallestFile <- which.min(FileSizes$FileSize)

print(
  paste(
    "The smallest file is",
    FileSizes$Files[smallestFile]
  )
)

print(
  paste(
    "What accounts for variability in size?",
    "If you open these files, note the various use of characters.",
    "CSV and Tab sep values by single char",
    "space sep using many white space chars",
    ".rdata, you can't see, but uses space much more efficiently"
  )
)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# 3. there was no object called "df.rdata"
df.rdata <- NHIS_2007_RData
df.rdata <- get(
  load(file = url("https://github.com/EconomiCurtis/econ294_2015/raw/master/data/NHIS_2007_RData.RData"))
)

print(
  typeof(df.rdata)
)

print(
  class(df.rdata)
)

print(
  paste(
    "length:",length(df.rdata)
  )
)
print(
  paste(
    "dim:",dim(df.rdata)
  )
)
print(
  paste(
    "nrow:",nrow(df.rdata)
  )
)
print(
  paste(
    "ncol:",ncol(df.rdata)
  )
)

summary(df.dta)



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# 4. 

df <- read.dta(
  "https://github.com/EconomiCurtis/econ294_2015/raw/master/data/org_example.dta"
)
str(df)
print(
  paste(
    "observations:",nrow(df)
  )
)
print(
  paste(
    "variables:",ncol(df)
  )
)

summary(df$rw)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# 5. 

v <- c(1,2,3,4,5,6,7,4,NULL,NA)
print(
  paste(
  "length",length(v)," - the NULL value was dropped"
  )
)

print(
  paste(
    "typeof:",typeof(v),"- class:",class(v)
  )
)

print(
  paste(
    "mean:", mean(v,na.rm = T)
  )
)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# 6.

x <- matrix(
  c(1,2,3,4,5,6,7,8,9),
  nrow = 3,
  byrow = T
)

t(x)
print("t(x), I googled it")

x.eng <- eigen(x)

print(
  x.eng$values
)

print(
  x.eng$vectors
)

y <- matrix(
  c(1,2,3,3,2,1,2,3,0),
  nrow = 3,
  byrow = T
)

y.inverse <- solve(y)

y %*% y.inverse

print("The identity matrix")

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# 7.
#other people in this class did this way better than me!

diamonds <- read.table(header = TRUE, text = '
                       carat cut clarity price
                       5 "fair" "SI1" 850
                       2 "good" "I1" 450
                       0.5 "very good" "VI1" 450
                       1.5 "good" "VS1" NULL
                       5 "fair" "IF" 750
                       NA "Ideal" "VVS2" 980
                       3 "fair" NA 420
                       ')

diamonds
class(diamonds)
class(diamonds$carat)
class(diamonds$cut)
class(diamonds$clarity)
class(diamonds$price)

diamonds$price # this looks wrong
diamonds$price <- c(850,450,450,NA,750,980,420) #NA handles this better

mean((diamonds$price))
mean((diamonds$price), na.rm = T)

diamonds.2 <- subset(
  diamonds,
  cut == "fair"
)
print(mean(diamonds.2$price))


diamonds.3 <- subset(
  diamonds,
  cut == "good" | cut == "very good" | cut == "Ideal"
)
print(mean(diamonds.3$price, na.rm = T))

diamonds.4 <- subset(
  diamonds,
  carat > 2 & (cut == "Ideal" | cut == "very good")
)
diamonds.4
print(
  "no diamonds meet this condition"
)
