# Lecture 3 notes, part 2
# Working Data Frames

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
## Loading and Saving Data
#just some setup

#loading .dta
library(foreign)
org_example <- read.dta(
  file = "https://github.com/EconomiCurtis/econ294_2015/raw/master/data/org_example.dta")

#Save as .RData
save(
  org_example,
  file = "data/org_example.RData"
)  

# load RData
load(
  file = "data/org_example.RData"
)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Describe your data

str(org_example)
# note all the different data types for the 33 variables


# list variable names
names(org_example)

summary(org_example) #helpful for numeric varaibles

# summarize one variable
# The "$" operator from lists
table(org_example$year) #table is a handy function, freq count

levels(org_example$educ)
table(org_example$educ)
sum(is.na(org_example$educ)) #however, it doesn't count NAs


#     View(org_example)  #open a snippet in RStudio
# lots of options for filter, sort. 

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Adding, removing, editing columns
# cbind function
df <- cbind(
  col1 = rnorm(100),
  col2 = runif(100)
) 
#beware recycling, length of new column should match length of old

# add column with assignment
# create new "colGrad" variable
# do they have College or Advanced? 
table(org_example$educ)
org_example$colGrad <- ifelse(
  (org_example$educ %in% c("College","Advanced")),
  yes = 1,
  no  = 0
  
)
table(org_example$educ)
table(org_example$colGrad) #tab completion
# 82307+164576 = 246883, looks good


# summarize by...
# summarize rw, by year
#with tapply
# a little messy

#vector of mean rw, by year
temp.4.mean <- tapply( 
  X = org_example$rw,
  INDEX = org_example$year,
  summary
)

temp.4.mean


# applying functions to data.frames
# lm example
glm_probit <- glm(
  unem ~ educ,
  family = (binomial(link = "probit")),
  data = subset(org_example, 
                  nilf == 0 & year == 2008)
)
summary(glm_probit)


org_example <- read.dta(
  file = "https://github.com/EconomiCurtis/econ294_2015/raw/master/data/org_example.dta")
d <- subset(org_example, year == 2008)
d <- subset(d, nilf == 0)
glm_probit<-glm(unem~educ,d,family=binomial(link="probit"))
summary(glm_probit)



# And a column as function of another
org_example$rw_log <- log(org_example$rw)
# vectorized operation (a for loop over a vector)



# standardize and normalize 
mean(org_example$rw, na.rm = T)
sd(org_example$rw, na.rm = T)

org_example$rw_std <- I(
  (org_example$rw - mean(org_example$rw, na.rm = T)) / sd(org_example$rw, na.rm = T)
  )
system.time({
  # but what about, standardize by year? year and education level?
  stndz <- function(x){
    (x - mean(x, na.rm = T))  /  sd(x, na.rm = T)
  }
  temp <- split(
    org_example$rw, c(org_example$year)
  )
  temp.2 <- lapply(
    temp, 
    stndz
  )
  temp.3 <- unsplit(
    temp.2,
    c(org_example$year)
  )
  org_example$rw_std.year <- temp.3
  mean(subset(org_example, year == 2013)$rw, na.rm = T) # [1] 21.84623
  sd(subset(org_example, year == 2013)$rw, na.rm = T)   # [1] 16.74968
  # (57.48-21.84) / 16.74       #  [1] 2.129032   # yep!!
})

# Using Aggregate
aggregate(
  
)



# Wow! Getting complicated!!, imagine this for year + educ!
# but don't fret
# introduce dplyr tools
require(dplyr)
system.time({
  org_example <- org_example %>%  # magrittr
    dplyr::group_by(year) %>%  # dplyr::group_by(year, educ) %>%
    dplyr::mutate(
      rw_std.year2 = stndz(rw)
    )
}) # almost 5 times faster
sum(org_example$rw_std.year == org_example$rw_std.year2, na.rm = T) / sum(!is.na(org_example$rw_std.year))
#all are exactly the same!


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# dplyr + tidyr
# your friend
install.packages("dplyr")
library(dplyr)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Select certain columns (dplyr::select)
# select certain variables
dim(org_example)
names(org_example)
# see str(org_example)
org_example.nu <- dplyr::select(
  org_example, 
  year, month, educ, rw  #list columns you want to keep
)
dim(org_example.nu)
names(org_example.nu)

# tons of great tools
?select #see special functions

org_example.nu <- dplyr::select(
  org_example, 
  year, month, matches("edu"), ends_with("w")
)
names(org_example.nu)

#easy way to change names of variales
org_example.nu <- dplyr::select(
  org_example, 
  YEAR = year, MO = month, matches("edu"), ends_with("w")
)
names(org_example.nu)



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Subsetting (dplyr::filter)
# filter (subset) rows/obs by matching conditions
# overloaded function name
?filter
?dplyr::filter


system.time({
  org_example.nu <- subset(
    org_example, 
    year == 2008 | rw > 10
  )
})

system.time({
  org_example.nu <- dplyr::filter(
    org_example, 
    year == 2008 | rw > 10
  )
}) #often much faster

# Multiple logic rules:
# <   Less than                    !=      Not equal to
# >   Greater than                 %in%    Group membership
# ==  Equal to                     is.na   is NA
# <=  Less than or equal to        !is.na  is not NA
# >=  Greater than or equal to     &,|,!   Boolean operators

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Sorting (dplyr::arrange)
?arrange
org_example.nu <- dplyr::arrange(
  org_example, 
  year, month
) 
View(org_example.nu)
# from earliest year, to more recent, down
# within year, sort month from earliest to biggest

org_example.nu <- dplyr::arrange(
  org_example, 
  -year, -month
) 
View(org_example.nu) #opposite of that sorting



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Adding or Changing Columns (dplyr::mutate)
# Creates new variables
stndz <- function(x){
  (x - mean(x, na.rm = T))  /  sd(x, na.rm = T)
}

org_example.nu <- dplyr::mutate(
  org_example, 
  rw.std = stndz(rw)
) 
View(org_example.nu)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Summarize (dplyr::summarize)
# summary stats on variables 
org_example.nu <- dplyr::filter(
  org_example, 
  year == 2008, state == "CA", educ == "College")

org_example.nu <- dplyr::summarise(
  org_example.nu, 
  rw_mean = mean(rw, na.rm = T),
  rw_sd   = sd(rw, na.rm = T),
  obs     = length(rw)
)
org_example.nu
# 2499 College CA obs in 2008
# mean wage 31.95


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Piping magrettr %>% operator
# the real power of dplyr (and tidyr ggplot to come) is combining multiple functions

# Example: 
# - just the year, month, rw, educ and age column
# - rename these columns
# - filter by a few conditions
# - add a new variable
# - sort it
# Do this: 
# - multiple assignments...?
org_example.nu <- dplyr::select(
  org_example,  YEAR = year, MO = month, RealWage = rw, Educ = educ, Age = age)
org_example.nu <- dplyr::filter(
  org_example.nu, YEAR > 1900 & !is.na(RealWage))
org_example.nu <- dplyr::mutate(
  org_example.nu, rw.std = stndz(RealWage))
org_example.nu <- dplyr::arrange(
  org_example.nu, YEAR, MO)
str(org_example.nu)

# - many functions ... odd orders
org_example.nu <- dplyr::arrange(
  dplyr::mutate(
    dplyr::filter(
      dplyr::select(
        org_example,
        YEAR = year, MO = month, RealWage = rw, Educ = educ, Age = age
      ),
      YEAR > 1900 & !is.na(RealWage)
    ),
    rw.std = stndz(RealWage)
  ),
  YEAR, MO
)
str(org_example.nu)



org_example.nu <- org_example %>%
  dplyr::select(
    YEAR = year, MO = month, RealWage = rw, Educ = educ, Age = age
  ) %>%
  dplyr::filter(
    YEAR > 1900 & !is.na(RealWage)
  ) %>%
  dplyr::mutate(
    rw.std = stndz(RealWage)
  ) %>%
  dplyr::arrange(
    YEAR, MO
  )
    
str(org_example.nu)
# walk through each step
# note the %>% operator must be on the same line!
# this is much much better!

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Grouping (dplyr::group_by)
# sort, add, summarize, by a grouping variable or variables. 
# Let's find average real wages by year, month, state, educ

org_example$state <- factor(
  org_example$state,
  levels(org_example$state)[order(levels(org_example$state))]
) #the state was out of order, it was annoying me

Wage.sum <- org_example %>%
  dplyr::group_by(year, month, state, educ) %>%
  dplyr::summarise(
    rw.mean = mean(rw, na.rm = T), 
    rw.median = median(rw, na.rm = T),
    count   = length(rw)
  )


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Merging (dplyr::join)
# full_join, left_join, right_join




# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Reshaping your data 
# tidyr















