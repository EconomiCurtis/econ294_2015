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

# <- get(load(...)) is a handy way to load an .RData file and rename it at the same time
diamonds <- get(  
  load(
    file = url("https://github.com/EconomiCurtis/econ294_2015/raw/master/data/diamonds.RData")
  )
)

CurtisKephartAssignment2$s1a <- nrow(diamonds)
CurtisKephartAssignment2$s1b <- ncol(diamonds)
CurtisKephartAssignment2$s1c <- names(diamonds)
CurtisKephartAssignment2$s1d <- summary(diamonds$price)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Question 2

NHIS_2007_TSV <- read.table(
  file = "https://github.com/EconomiCurtis/econ294_2015/raw/master/data/NHIS_2007_TSV.txt",
  sep = "\t",
  header = T
) 
#read.delim() also works
#name doesn't matter

CurtisKephartAssignment2$s2a <- nrow(NHIS_2007_TSV)
CurtisKephartAssignment2$s2b <- ncol(NHIS_2007_TSV)
CurtisKephartAssignment2$s2c <- names(NHIS_2007_TSV)
CurtisKephartAssignment2$s2d <- mean(NHIS_2007_TSV$weight, na.rm = T)
CurtisKephartAssignment2$s2e <- median(NHIS_2007_TSV$weight)

NHIS_2007_TSV$weight <- ifelse(
  NHIS_2007_TSV$weight < 800,
  NHIS_2007_TSV$weight,
  NA
)

CurtisKephartAssignment2$s2f <- mean(NHIS_2007_TSV$weight, na.rm = T)
CurtisKephartAssignment2$s2g <- median(NHIS_2007_TSV$weight, na.rm = T)


CurtisKephartAssignment2$s2h <- summary(
  subset(NHIS_2007_TSV,
         SEX == 1)$weight)


CurtisKephartAssignment2$s2i <- summary(
  subset(NHIS_2007_TSV,
         SEX == 2)$weight)


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Question 3

vec <- c(letters,LETTERS)

CurtisKephartAssignment2$s3a <- vec[seq(2,52, by = 2)]
CurtisKephartAssignment2$s3b <- paste(vec[c(29,21,18)],collapse="")


arr <- array(
  c(letters,LETTERS),
  dim = c(3,3,3)
)

CurtisKephartAssignment2$s3c <- arr[,1,2]
CurtisKephartAssignment2$s3d <- arr[2,2,]
CurtisKephartAssignment2$s3e <- paste(arr[3,1,1],arr[3,1,3],arr[3,3,2],  sep = "")

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Question 4

library(foreign)
org_example <- read.dta(
  file = "https://github.com/EconomiCurtis/econ294_2015/raw/master/data/org_example.dta"
)

# very niave, slow
# takes about 214.55s on this system
system.time({
  allYears  <- sort(unique(org_example$year))
  allMonths <- sort(unique(org_example$month))
  allEduc   <- sort(unique(org_example$educ))
  rowsToMake <- length(allYears) * length(allMonths) * length(allEduc)
  df.1 <- data.frame(
    year = rep(NA,rowsToMake), 
    month = rep(NA,rowsToMake),
    educ = rep(NA,rowsToMake),
    rw_mean = rep(NA,rowsToMake)
  )
  rowCnter <- 1
  for (Year in allYears){
    for (Month in allMonths){
      for (Educ in allEduc){
        df.1$year[rowCnter]  = Year
        df.1$month[rowCnter] = Month
        df.1$educ[rowCnter]  = Educ
        
        df.sub <- subset(
          org_example, 
          year == Year & month == Month & educ == Educ)
        
        rw.mean <- mean(df.sub$rw, na.rm = T)
        df.1$rw_mean[rowCnter] = rw.mean
        rowCnter <- rowCnter + 1
      }
    }
  }

})

# using aggregate
# takes about 3.71s on this system
system.time({
  df.2 <- aggregate(
    org_example$rw,
    by = list(
      year = org_example$year,
      month = org_example$month,
      educ = org_example$educ
    ),
    FUN = mean, na.rm = T
  )
  names(df.2)[4] <- "rw_mean"
  
})

# actually adding this to the list "CurtisKephartAssignment2"
CurtisKephartAssignment2$s4 <- df.2

# using dplyr
# takes about 0.38s on my system. 
require(dplyr)
system.time({
  df.3 <- org_example %>%
    dplyr::group_by(year, month, educ) %>%
    dplyr::summarize(
      rw_mean = mean(rw, na.rm = T)
    )
})

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Save solutions
save(
  CurtisKephartAssignment2, 
  file = "Assignments/CurtisKephartAssignment2.RData"
)

