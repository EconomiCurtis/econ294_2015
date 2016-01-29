# Assignment 2 Grader
#' Curtis Kephart
#' Jan 22 2016
#' Econ 294 Masters R Lab

library(dplyr)
library(stringr)
rm(list = ls())

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Collect assignments
Assignment.2.files <- list.files("/Users/OKComputer/Dropbox/R Lab/Econ 294 Assignment 2 Turned in/")
Assignment.2.files <- Assignment.2.files[str_detect(tolower(Assignment.2.files),".rdata")]

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Load answers 
load(
  file = "Assignments/CurtisKephartAssignment2.RData"
)
CurtisKephartAssignment2$s4 <- dplyr::arrange(CurtisKephartAssignment2$s4, year, month, educ)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Set up grade sheet
GradesAss2 <- data.frame(
  firstName  = rep(NA, 50),
  lastName  = rep(NA, 50) ,
  email  = rep(NA, 50) ,
  studentID  = rep(NA, 50) ,
  objectName = rep(NA, 50) ,
  s1a  = rep(NA, 50) ,
  s1b  = rep(NA, 50) ,
  s1c  = rep(NA, 50) ,
  s1d  = rep(NA, 50) ,
  s2b  = rep(NA, 50) ,
  s2a  = rep(NA, 50) ,
  s2c  = rep(NA, 50) ,
  s2d  = rep(NA, 50) ,
  s2e  = rep(NA, 50) ,
  s2f  = rep(NA, 50) ,
  s2g  = rep(NA, 50) ,
  s2h  = rep(NA, 50) ,
  s2i  = rep(NA, 50) ,
  s3a  = rep(NA, 50) ,
  s3b  = rep(NA, 50) ,
  s3c  = rep(NA, 50) ,
  s3d  = rep(NA, 50) ,
  s3e  = rep(NA, 50) ,
  s4  = rep(NA, 50)
)


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# 1. Loop through all assignments
#    For each assignment:
#    - open RData
#'   - check each answer:
#'   --- is answer in approved list of answers?  
#'   --- one point per answer
#'   - maps answers to grade

cnt = 1
for (FILE in 1:length(Assignment.2.files)){
  
  myDIR <- "/Users/OKComputer/Dropbox/R Lab/Econ 294 Assignment 2 Turned in/"
  listToGrade <- get(
    load(
      paste(myDIR,Assignment.2.files[FILE],
            sep = "")
    )
  )
  
  if (!(class(listToGrade) == "list")){
    GradesAss2$objectName[cnt] <- Assignment.2.files[FILE]
  } else {
    GradesAss2$firstName[cnt] <- listToGrade[[1]]
    GradesAss2$lastName[cnt]  <- listToGrade[[2]]
    GradesAss2$email[cnt]     <- listToGrade[[3]]
    GradesAss2$studentID[cnt] <- listToGrade[[4]]
    GradesAss2$objectName[cnt] <- Assignment.2.files[FILE]
    
    
    print(
      paste(
        FILE, listToGrade[[1]], listToGrade[[2]]
      )
    )
    
    
    GradesAss2$s1a[cnt] <- listToGrade$s1a == CurtisKephartAssignment2$s1a
    GradesAss2$s1b[cnt] <- listToGrade$s1b %in% c(CurtisKephartAssignment2$s1b,5)
    GradesAss2$s1c[cnt] <- all(CurtisKephartAssignment2$s1c  %in% listToGrade$s1c)
    GradesAss2$s1d[cnt] <- any(CurtisKephartAssignment2$s1d == listToGrade$s1d)
    
    GradesAss2$s2a[cnt] <- ifelse(
      test = !is.null(listToGrade$s2a),
      yes = any(CurtisKephartAssignment2$s2a == listToGrade$s2a),
      no  = F)
    GradesAss2$s2b[cnt] <- ifelse(
      test = !is.null(listToGrade$s2b),
      any(CurtisKephartAssignment2$s2b == listToGrade$s2b),
      no  = F)
    GradesAss2$s2c[cnt] <- ifelse(
      test = !is.null(listToGrade$s2c),
      any(CurtisKephartAssignment2$s2c == listToGrade$s2c),
      no  = F)
    GradesAss2$s2d[cnt] <- ifelse(
      test = !is.null(listToGrade$s2d),
      any(CurtisKephartAssignment2$s2d == listToGrade$s2d),
      no  = F)
    GradesAss2$s2e[cnt] <- ifelse(
      test = !is.null(listToGrade$s2e),
      any(CurtisKephartAssignment2$s2e == listToGrade$s2e),
      no  = F)
    GradesAss2$s2f[cnt] <- ifelse(
      test = !is.null(listToGrade$s2f),
      any(CurtisKephartAssignment2$s2f == listToGrade$s2f, na.rm = T),
      no  = F)
    GradesAss2$s2g[cnt] <- ifelse(
      test = !is.null(listToGrade$s2g),
      any(CurtisKephartAssignment2$s2g == listToGrade$s2g, na.rm = T),
      no  = F)
    GradesAss2$s2h[cnt] <- ifelse(
      test = !is.null(listToGrade$s2h),
      identical(CurtisKephartAssignment2$s2h[1:6], listToGrade$s2h[1:6]),
      no  = F)
    GradesAss2$s2i[cnt] <- ifelse(
      test = !is.null(listToGrade$s2i),
      identical(CurtisKephartAssignment2$s2i[1:6], listToGrade$s2i[1:6]),
      no  = F)

    
    
    
    GradesAss2$s3a[cnt] <- any(CurtisKephartAssignment2$s3a == listToGrade$s3a)
    GradesAss2$s3b[cnt] <- all(tolower(str_sub(listToGrade[[1]],1,3)) == tolower(listToGrade$s3b))
    GradesAss2$s3c[cnt] <- any(CurtisKephartAssignment2$s3c == listToGrade$s3c)
    GradesAss2$s3d[cnt] <- any(CurtisKephartAssignment2$s3d == listToGrade$s3d)
    GradesAss2$s3e[cnt] <- ifelse(
      test = !is.null(listToGrade$s3e),
      yes = tolower(str_sub(listToGrade[[1]],1,3)) == tolower(listToGrade$s3e),
      no = F
      
    )
    
    if (!is.null(listToGrade$s4)){
      if (class(listToGrade$s4) == "data.frame"){
        if (nrow(listToGrade$s4) == 420){
          
#           names(listToGrade$s4) <- tolower(names(listToGrade$s4))
#           listToGrade$s4 <- dplyr::arrange(
#             listToGrade$s4, 1, 2, 3
#           )
          GradesAss2$s4[cnt] <- 1
          
        } else {GradesAss2$s4[cnt] <- 0}
        
      } else {GradesAss2$s4[cnt] <- 0}
      
    } else {GradesAss2$s4[cnt] <- 0}
    
    
    
    
    
  }
  cnt = cnt + 1  
}
# 
# rm(listToGrade)


