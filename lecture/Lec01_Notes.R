#' Lecture 1 Notes
#' Curtis Kephart
#' Econ 294 R-lab for UCSC Finance Masters
#' Jan 8th 2016


# Today, R quick notes
# We've just got introduced to R, Rstudio. 
# after these notes, we discuss RStudio a bit more
# and set up a github repo. 


# Intro to R

# Assignment 
# Use the "<-" operator
# on the left is the name
#on the right is the data you want assigned to the name
x <- 1
y <- "Hey there"


# Case sensitive
X # cap X
x # lower case x

Y
y

# In this context, you technically could use the "=" symbol for assignment. 
x = 1
x
x <- 1
x
# but in other contexts you cannot, 
# and in some context you'll only want to use the "=" equal sign. 
# so, for assignment, just stick wtih the "<-" operator. 

# Note also that the "#" pound symbol allow for comments in your script. 
# R will ignore any lines in the console or your scripts after a #, to teh end of the line. 
x <- 1 #so you can comment after code too
#' in RStudio scripts, if you type "#'" (with the apostrophe), it'll automatically set up the next line
#' for a comment too. 
#' It's handy. 

# Overwriting values
x <- 1
x
x <- 2
x

# Assgining one value at relationship with another
y <- 1
x <- y + 1
# x is set to y (1) plus 1
x
# but, what if we update y to something else. Does x get automatically updated? 
y <- 2
x
# nope. x is assigned to the end result of the data
# this is unlike some other programming langauges like C

# You'll get errors if you refer to objects that haven't been assigned yet
x + y + Hey + 1
# Returns: Error: object 'Hey' not found
# in this case, "Hey" isn't assigned to anything yet. 

# There are rules about naming objects. 
# Your object name must start with a letter (upper or lower)
y1 <- 1
y_1 <- 1
y.1 <- 1
# if you update an object, perhaps append numbers with a "." or "_"
# it cannot start with a number
1y <- 1
# there are a bunch of protected special characters. 
# object named cannot include these characters ^ !@#$%^&*()

# Scripts
# You can work in scripts for interactive programming 
# as we have in this lecture.
# To OPen a new script, click "File" >> "New File" >> "R Script"
# you can also run these .R script files. 
# use the `source` function. on my file system: 
source("C:/Users/OKComputer/Dropbox/R Lab/Lec01 Notes.R")
#it returns an Error because of the problematice code above. 
# Note also, you can click the "Source" button in the upper right of this pane. 
# that will save the .R script to file, and run it all. 

# Run Code in a Script Window
# - you can also just run a single line of your script by moving your cursor to the line you want to run
#   and clicking ctrl+enter together. 
# - You can run multiple lines by selecting all teh lines you want to run, 
#   and clicking ctrl+enter together. 

# Objects in your workspace
# We've created a number of objects. 
# to look at them all, run
ls()
# to remove one, use the rm() function. 
x <- 1
ls()
rm(x)
ls()
#note x is removed from the object list
#you may want to do this if you are working with big data and need the memory. 

# R Data Primitives
# Numerics
typeof(1)
typeof(3.14)
#double stands for Double-precision floating-point.
typeof(1L)
# another number type can be an integer. 
# an integer of the same size can count quite a bit higher than a floating point number. 
# however, floating point numbers are quite handy. 
# R will let you work with numerics, appying many operators on them. 
1 + 2 # addition
1 - 2 # subtraction
3 * 6 # multiplication
2^16 #exponent
10 / 6 # division
10 %/% 6 #integer division
10 %% 6 # modulo
# https://stat.ethz.ch/R-manual/R-devel/library/base/html/Arithmetic.html

# Switchign between numeric types
# R will automatically handle numeric type switching
# usually converting ints into doubles when needed. 
typeof(1L + 2.5)


# You can also work with character strings. 
# Surround your character with quotation marks. ""
#You can use quotes ""
x <- "poo"
#Or you can use apostrophies. ''
x <- 'poo'
y <- "bar"

# When cutting and pasting code!
# Be careful
# "Straight quotes" and “smart quotes” are different
# look at the quotation marks above carefully
# they are very different. 
# Many word processors will automatically convert straight quotes into smart quotes (that look better
x <-  "Straight quotes" 
x <- “smart quotes” # error!
x <- "“smart quotes”"

# There are a ton of tools to work with characters and strings in R. 
# - print, of you run the script, it'll print this into your console. 
print("hello world")
# - paste, concactinate multiple strings
paste("hey","world")
# R and its universe of packages have a ton of tools to work with strings. 

# Object types
# note objects have strict types, 
# certain operations can only be done on certain types
x = "4"
typeof(x)
x + 1 # your can't add a string to a number
as.numeric(x) #coerce the numeric string into a number. 
as.numeric(x) + 1 #works....
typeof(1)
typeof(1.0)
typeof(1L) 
typeof("1")
typeof(3i+2) #note you can also work with complex numbers. hazzah. 

# Booleans and Logical operations
#- 1. First, introduce boolean: T or TRUE or 1
TRUE
T
typeof(T)
T == 1
#- .2 F or FALSE or 0
FALSE
F
0
0 == F
#- 3. == test "is equivolent?"
#- & ampersand   
#- | "vertical bar"
F & F
T & F
T | F
#- think: AND is return TRUE if all are TRUE
#- OR is return TRUE if any are TRUE. 

# R has a ton of Math functions built into it. 
log(10) #natural log
log10(10) #log base ten
exp(1) # e
# check out general and maths sections: 
# http://www.sr.bham.ac.uk/~ajrs/R/r-function_list.html

# Help with function
# read documentation
# google it. 
?read.table
# note this opens a file under "Help"
# it has loads of documentation on opening CSV, tab deliniated, space seperated files. 
# you have a nice homework assignment to try to load these



# Loading Data
# let's load data from Alan's website: http://people.ucsc.edu/~aspearot/Econ217.htm
# note the "org_example.dta" file. 
# ".dta" is a special STATA file. 
# we need a special function to load it. 
# if you google how to load this file, there's a handy function "load.dta"
df.dta <- read.dta(
  file = "http://people.ucsc.edu/~aspearot/Econ_217_Data/org_example.dta"
)
# YOu may have gotten an error "Error: could not find function "read.dta""
# read.dta is a special function in the "foreign" package. 
# "packages" in R are basically libraries in any other language 
# collectiosn of functions, data and documentation to extend R's basic functionality 
library(foreign) #package with read.dta in it
df.dta <- read.dta(
  file = "http://people.ucsc.edu/~aspearot/Econ_217_Data/org_example.dta"
)
# I get an error, but it loads. the error has to do wtih certain variables/columns from the STATA file. 
# Let's get a sense of what this data looks like. 
View(df.dta)
str(df.dta)
length(df.dta)
names(df.dta)
dim(df.dta)
class(df.dta)
typeof(df.dta)


# Load a CSV File
# Load a tab seperated file. 


# Subset
table(df.dta$year)
table(df.dta$lfstat)
df.dta.2 <- subset(                  #calling subset function, see ?subset for dets
  df.dta,                            #subsetting object df.dta, loaded above
  (year == 2013 & lfstat == "NILF")  #some logical tests to define which rows I want to keep
)

# Add column
df.dta.2$nuCol1 <- df.dta.2$year +  1  #create new colunm/variable called "nuCol1"
df.dta.2$nuCol2 <- df.dta.2$year +  df.dta.2$month
#Not sure why you'd add these columns, but you can. 

