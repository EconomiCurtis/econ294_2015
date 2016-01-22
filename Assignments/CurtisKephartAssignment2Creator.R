#' ---
# title: Assignment 2 example script. 
# author: "Curtis Kephart"
# date: "Winter 2016"
# assignment: https://github.com/EconomiCurtis/econ294_2015/blob/master/Assignments/Econ_294_Assignment_2.pdf
# ---


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Question 0

CurtisKephartAssignment2 <- list(
  firstName = "Curtis",
  lastName  = "Kephart",
  email     = "curtisk@ucsc.edu",
  studentID = 0142214
)


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Question 1

# 
require(RCurl) ; #install.packages("RCurl")
diamondsURL <- getURL("https://raw.githubusercontent.com/EconomiCurtis/econ294_2015/master/data/diamonds.CSV")
diamonds <- read.csv(  
  text = diamondsURL
)
rm(diamondsURL)

CurtisKephartAssignment2$s1a <- nrow(diamonds)
CurtisKephartAssignment2$s1b <- ncol(diamonds)
CurtisKephartAssignment2$s1c <- names(diamonds)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#    save(CurtisKephartAssignment2,
#         file = "Assignments/CurtisKephartAssignment2.RData")


