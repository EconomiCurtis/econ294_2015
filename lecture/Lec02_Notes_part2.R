# Lecture 2, part 2
# data structures

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Functions to get to know more about any data-structure

?typeof
?class
?object.size
?str
?dim
?View
?names
?lenth
?ncol
?nrow

# We'll discuss
# - Vectors, 
# - matrices and arrays
# - lists
# - data.frame (a special version of a list)

# For each data structure, 
#' - we'll talk about tools to understand the data structure
#' - assign and extract values
#' - tools to work with the data structure. 
#' 

## VECTORS  
# Building block of other data structures
# a list of values

x <- 1
x
length(x)

#use the ":" sequence operators 
x <- 1:10
x
length(x)
str(x)
typeof(x)
class(x)
object.size(x)

# note that we assign a name to a vector
x <- c(1,2,3,4)
y <- c(x,5,6)
y # y contains the values in x, 
# x might update, but y won't unless we reassign it
x <- x*2
y

# Use the c function to create list
x <- c(1,2,3,4)
x
length(x)
str(x)
typeof(x)
class(x)
object.size(x)

# VECTORS contain individual objects, all of the same class
# here's integers
x <- c(1L,2L,3L,4L) #integers
x
typeof(x)
class(x)
object.size(x)

# here's character strings
x <- c("a","b","c","d") #character string
x
typeof(x)
class(x)
object.size(x) #note, character strings are much bigger

# here's complex
x <- c(i, 3i+4,2i,9) # complex 
x
typeof(x)
class(x)
object.size(x)

# here's booleans
x <- c(T,T,F,T) # Booleans 
x
typeof(x)
class(x)
object.size(x) 

#  switch from one vector-class to another can be hard to think about
x <- c(1,2,3,4)
class(x)
x <- c(x, "a")  
class(x) #coerced to character

x <- c(1,2,3,4)
x <- c(x, "5")
x
class(x) #coerced to character
as.numeric(x) #coerce it back, (if possible, "5" can be in this case)
as.numeric(c(1,2,3,"a")) #in this case 'a' can't coerce into numeric, so NA is produced


# vectors of length 0
x <- NULL
length(x)
x
x <- c()
length(x)
x
typeof(x)
class(x)
object.size(x)

# Adding to vectors
x <- c(1,2,3,4,7)

x.nu <- c(0,x)
x.nu

x.nu <- c(x,8)
x.nu

# Extracting vector elements
x[1]           #the first value of this vector
x[2:4]         #values 2 3 and 4 
x[c(2:4, 7)]   # 2, 3, 4 and 7
# negative sign, "all but"
x[-1]          # all but the first index value
x[-c(4:7)]     #all but the 4th, 5th, 6th and 7th values

# Logical Vectors
x <- c(1,2,3,4,5,6,7,8)
  x %% 2 == 0 # which are even? good old modulo
x[x %% 2 == 0]

# here's the negated boolean vector above
!(x < 7)
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


x <- x[1:7] #only keep the first 7 values
x


# for loop over a vector
x <- c(1,2,3,4,5,6,7,8)
x <- x[x %% 2 == 0] #only keep even values
for (i in x){print(i)} #print each value on x
#can be quite handle
for (i in 1:length(i)){print(x[i])} #print each value on x

## Some operations on vectors
# 1. Some operations change the values inside a vector
x <- c(1,2,3,4)
x^2
x - c(4,3,2,1)

# 2. Some map all values to another object (e.g mean, median, summary, range, etc)
x <- rnorm(n = 1000, mean = 0, sd = 1)
mean(x)              #arithmetic mean
summary(x)           #summary statistics
range(x)             #the min and max
sort(x)              #puts vector in order      
hist(x, breaks = 20) #creates a histogram plot
# too many functions to cover!

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
as.numeric(x)

x <- factor(
  c(rep(LETTERS[1:5], 2)),
  levels = LETTERS[1:10]
)
x #although values F G H I J don't exist yet, they might
# factors are very helpful in spliting, and grouping by
# emphasize this point, it'll be very useful later!

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
  v1 = rnorm(10)
)
# use the "$" sign
myList$firstName
myList$lastName
myList$studentID
myList$v1       # tab completion is handy

# extracting values, use double brackets
myList[[1]]
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

# extract values from data frame
# 1. index, just col
df[1]  #col1
df[3]

# 2. row,col
df[1,3] #row1, col3
df[,3] #col3 #all row, col3 (note comma!)
df[1,] #row1, all columns (note comma!)
df[c(2,4,6,8,10),] # even rows (note comma!)
df[c("col1","col3")] # extract col by name
df$col1 #use $ to call column name
df$col3

# errors
df[4]    #col4 doesn't exist
df[1,4,] #
df$poobar 

#operations and functions



