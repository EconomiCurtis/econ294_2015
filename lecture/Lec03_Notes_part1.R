# Lecture 3 Notes - R Data Structures continued. 
# picking up where we left off in Lec03 part2

# Logical Vectors
x <- c(1,2,3,4,5,6,7,8)
x %% 2 == 0 # which are even? good old modulo
x[x %% 2 == 0]

# here's the negated boolean vector above
!(x < 7)
View(data.frame(
  x.initial = x,
  x.test    = !(x < 7)
)) #to help you visualize what's going on
x[!(x < 7)]
#very flexible

# Deleting and Changing Vector Elements
x <- c(1,2,3,4,5,6,7,8)
x[8] <- 9
x

#assign a value insdie a vector
x <- c(1,2,3,NA,5,6)
x
x[4] <- 4

x <- c(x,7)
x <- c(0,x)



x <- rnorm(100)
x <- x[1:7] #only keep the first 7 values
x

# Recycling and Vectors
x <- 1:10
y <- c(1,0)
x * y #note the y values are recycled, repeated over the x
View(data.frame(
  x = 1:10,
  y = c(1,0)
)) #to help visualize what's going on
View(data.frame(
  x = 1:11,        #a little longer
  y = c(1,0)
)) #to help visualize what's going on
# beware, note, no error or warning messages!

# for loop over a vector
x <- c(1,2,3,4,5,6,7,8)
x <- x[x %% 2 == 0] #only keep even values
for (i in x){print(i)} #print each value on x
#can be quite handle

## Some operations on vectors
# 1. Some operations change the values inside a vector
x <- c(1,2,3,4)
x^2
x - c(4,3,2,1)
x - c(1,0)

# 2. Some map all values to another object (e.g mean, median, summary, range, etc)
x <- rnorm(n = 1000, mean = 0, sd = 1)
mean(x)              #arithmetic mean
summary(x)           #summary statistics
range(x)             #the min and max

# 3. Other functions do something else
sort(x)              #puts vector in order      
hist(x, breaks = 50) #creates a histogram plot
diff(x)

# 4. too many functions to cover!

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Factor vectors
# important, useful, and sometimes annoying. 
#  ‘category’ and ‘enumerated type’ 
x <- c(rep(LETTERS, each = 2))
x
x <- as.factor(x)
x
str(x)
class(x)  #factor
typeof(x) #interger...? 
unclass(x)#reveals int 
levels(x)
as.numeric(x) #note, they are all numbers

x <- factor(
  c(rep(LETTERS[1:5], 2)),
  levels = LETTERS[1:10]
)
x #although values F G H I J don't exist yet, they might
# factors are very helpful in spliting, and grouping by
# emphasize this point, it'll be very useful later!

#

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
## MATRICES AND ARRAYS

# setting up a matrix
matrix(c(1,2,3,4,5,6,7,8,9,10), nrow = 2, byrow = F)

# str of matrix
x <- matrix(c(1,2,3,4,5,6,7,8,9,10), nrow = 2, byrow = T)
x
str(x)
dim(x)
typeof(x)
class(x)

# also create with rbind, row bind
x <- rbind(
  c(1,2),
  c(3,4))
x
class(x)

# create matrix with cbind, column bind
x <- cbind(
  c(1,2),
  c(3,4))
x
class(x)


#matrix operations
x * 2 # times all elements by...
x * c(2,5) #element wise, with recycling
as.vector(x)

x %*% c(1,1) # %*% for inner multiplication

x %o% c(1,1) # %o% for outer multiplication

# many more matrix operations
# http://www.statmethods.net/advstats/matrix.html

## Extracting values from matrix
# note intexing, row, then column
x <- matrix(
  1:9,
  nrow = 3
)
x
x[1,] #first row
x[,2] #2nd column
x[1,2]
x[2,2]
x[c(1,3),-2] #same vector indexing rules, apply over matrix dimensions
diag(x)


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
## Arrays
# basically, matrices with additional dimensions
x <- array(
  1:27,
  dim = c(3,3,3)
)
x
x[1]   #just first value
x[1,,] #first row from each matrix
x[1,2,3] #1st row, 2nd col, 3rd matrix
x[3,2,1] #3rd row, 2nd col, 1st matrix


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
## LISTS
# A collector of various objects

myList <- list(
  firstName = "Curtis",
  lastName  = "Kephart",
  studentID = 0142214,
  v1 = rnorm(10)
)
myList
str(myList)
typeof(myList)
class(myList)
length(myList)
names(myList)

# use "=" for component assignment, "<-" won't work
myList
myList <- list(
  firstName = "Curtis",
  lastName  = "Kephart",
  studentID = 0142214,
  v1 <- rnorm(10)            #nope
)
myList
str(myList)
typeof(myList)
class(myList)
names(myList)

## for component naming, 
# standard naming conventiosn apply
myList <- list(
  `first Name` = "Curtis", #nope
  lastName  = "Kephart"
)
str(myList)


# accessing values in a list
myList <- list(
  firstName = "Curtis",
  lastName  = "Kephart",
  studentID = 0142214,
  v1 = list(
    sample1 = rnorm(10),
    sample2 = runif(100)
    )
)
# use the "$" sign
myList$firstName
myList$lastName
myList$studentID
myList$v1       # tab completion is handy
myList$v1$sample1

# extracting values, use double brackets
myList[[4]]
myList[["studentID"]]

## adding list elements
myList
myList$v2 <- LETTERS
str(myList)

## deleting list elements
myList$v1 <- NULL 
str(myList)
# note, element after v1 is moved up by one
myList[[4]]

## applying functions to lists
# apply family of functions
?apply
myList <- list(
  a = rnorm(10,0,1),
  b = rnorm(1000,0,1),
  c = rnorm(1000,-1,3)
)
str(myList)
lapply(myList,summary)
lapply(myList,sd)


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# DATA FRAMES   
# the workhorse
# a list, with special characteristics

df <- data.frame(
  col1 = rep(NA,10),
  col2 = 1:10,
  col3 = rnorm(10)
)

df
str(df)
typeof(df)
class(df)
length(df)
names(df)

# Warning 1 -- data frame variables (columns) must have same length
# cbind, one way to add a column to a data.frame
df <- data.frame(
  col1 = rep(NA,10),
  col2 = 1:11          #wrong length
)
# see error

# Warning 2 -- Note recycling may occur if lengths don't match
# this can be confusing, no warning or error message
df <- data.frame(
  col1 = rep(NA,10),
  col2 = 1:10,
  col3 = rnorm(10)
) #df of nrow == 10

df <- cbind(
  df,
  col4 = rnorm(100)  #adding vector of length 100
) 
View(df)  #note, the 10 df rows are repeated!


# extract values from data frame
df <- data.frame(
  col1 = rep(NA,10),
  col2 = 1:10,
  col3 = rnorm(10)
) #df of nrow == 10

# 1. index, just col
df[1]  #col1
df[3]
df['col3']

# 2. row,col
df[1,3] #row1, col3
df[ ,3] #col3 #all row, col3 (note comma!)
df[1, ] #row1, all columns (note comma!)
df[c(2,4,6,8,10),] # even rows (note comma!)
df[df$col3 < 0,] # 
df[c("col1","col3")] # extract col by name
df$col1 #use $ to call column name
df$col3

# errors
df[4]    #col4 doesn't exist
df[1,4,] #
df$poobar 

#operations and functions



