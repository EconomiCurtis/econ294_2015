#' ---
# title: Assignment 1 example script. 
# author: "Curtis Kephart"
# date: "Winter 2016"
# assignment: https://github.com/EconomiCurtis/econ294_2015/blob/master/Assignments/Econ_294_Assignment_1.pdf
# ---


# Here's an example of how to get the assignment started. 

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
#' it should return results that look like this: 
# > source('C:/Users/OKComputer/Dropbox/R Lab/econ294_2015/Assignments/CurtisKephartAssignment1.R')
# [1] "Curtis Kephart"
# [1] "0142214"
# > 

