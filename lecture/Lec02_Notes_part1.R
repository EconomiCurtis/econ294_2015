# Notes for Lecture 2

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Some Repeat

# Working with scripts
# - # for line commenting
# - #' for multiline commenting
# - Ctrl+Enter to run the line your cersor is at in the script
# - Run a group of lines by highlighting them, and entering Ctrl+Enter
# - Run the whole script with source
source("lecture/Lec01_Ex_Script.R")

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Workign with packages
# - extra functions, data and tools, extending R
# To get access to package:
# 1. install package to local machine (you prob dont want all 8000+ libraries!)
# 2. load package to memory (you might not want to load all 8000+ into memeory!)

# FInd all currently installed packages
dir(.libPaths())

# List all currently loaded into memory
search()

# Intsall package (puts package onto local machine, requires internet)
install.packages("ggplot2")

# Load the package (get access to the package's tools)
library("ggplot2")

require("ggplot2") #use this inside functions you create
#returns warning if the package isn't installed

# remove package from memory
detach("package:ggplot2", unload=TRUE)

#update your packages
update.packages() 

# Remove packages with remove.packages()


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#' Working with functions
#' - syntax
#' - name, arguments in paranthesis, returns. 
#' - help
#' - multiple arguments
#' - default arguments

# There are many useful functions, 
# I cannot cover them all. 
# Here are two examples

# Repeat Function Example #
?rep
rep(x = 5,      # use equal sign to assign argument values
    times = 10) # seperate multiple arguments by commans

x <- c(1,2,3,4)
rep(x = x, times = 2)

rep(a1 = 5, a2 = 10) #misnamed arguments
rep(5,10) #unnamed arguements, goes by order
rep(1:4,6)

# functions often have many options
rep(c(1,2,3),each=2) #extra options
rep_len(x, length.out = 13) #extra options

# Sequence Function Example #
?seq
seq(from = 0,        # use equal sign to assign argument values
    to = 1, 
    length.out=11)   # seperate multiple arguments by commans

seq(1, 9, by = 2)  # some arguments are unnamed, that's okay if order still works. 
seq(1, 10, by = 2) # note, ends at or before "to" argument
seq()


# random normal and # random uniform
# draw a number from a random uniform distribution
# or a random normal distribution
rnorm(
  n = 10,
  mean = 0,
  sd = 1
)

runif(
  n = 10,
  min = 0,
  max = 1
)



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Families of useful functions
# Handy ref: http://www.sr.bham.ac.uk/~ajrs/R/r-function_list.html

?Arithmetic #common operators
?Comparison #common operators for comparisons
?Control    #programming control structures
?Extract    #tools for extracting values from data structures
?Math       #S3 base: long list of math functions
?NA
?NULL
?Constants  #several commonly used constants
?Paren      #using parantheses () and open braces {}
?Quotes     #uses of quotes in R, includes escape characters
?Syntax     #order of operations and other notes

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Control structures
#' - if
#' - if else
#' - for loops
#' - while loops
#' - repeat
#' - break
#' - next

# if statements
# if (cond){expr}
# returns "expr", if "cond" is TRUE
if (TRUE) print("The condition was TRUE")   
if (FALSE){print("The condition was TRUE")} 

x <- 100 >= 10
if (x){
  print(
    paste(
      x,
      "is TRUE"
    )
  )# use curly braces for multi line expressions
} 

# Conditions, list them all
?Comparison
# and  combine these using the & or && operators for AND. | or || are the operators for OR.


# if and else statements
# else allows you to create an additional option
x <- 100 >= 10
if (x){
  print(
    paste(
      x,
      "is TRUE"
    )
  )# use curly braces for multi line expressions
} else {
  print(
    paste(
      x,
      "is FALSE"
    )
  )
}


# ifelse() function, very useful for vectorized conditional statements
x <- data.frame(c1 = 1:10)
?ifelse
x$c2 <- ifelse(test = x$c1 < 5 | x$c1 > 8, 
               yes  = x$c1, 
               no   = 0)
x
x$c2 <- ifelse(x$c1 < 5 | x$c1 > 8, 
               x$c1, 
               0)
x


## for loops - Part 1, Slow explicit loops
# for ("variable" in "sequence"){"expression"}
for (i in 1:5){ 
  # i is the varaible
  # the sequence is 1 to 5
  print(i) # print i
}
# use seq and rep for 
# in R, these for loops can be quite slow

## for loops - Part 2, Faster implicit loops
#' the apply family of functions
#' apply() can apply a function to elements of a matrix or an array. This may be the rows of a matrix (1) or the columns (2).
#' lapply() applies a function to each column of a dataframe and returns a list.
#' sapply() is similar but the output is simplified. It may be a vector or a matrix depending on the function.
#' tapply() applies the function for each level of a factor.

df <- data.frame(
  x1 = rnorm(1000, mean = 100, sd = 10),
  x1 = rnorm(1000, mean = 0,   sd = 1)
) # two different random normal distribution

lapply(df, mean) #find mean of both samples
lapply(df, sd)   #find standard deviation of both samples

## While loops
# while (cond){expr}
x <- 1
while (x <= 5){
  print(x)
  # x <- rnorm(1, mean = 0, sd = 1)
  x = x + 1 
}
print(x)
# can be quite useful alternative to for loops
# in fact, for-loops are usually implementations of the while loop

# Repeat
# be careful, these may never stop
# repeat expr
# basically repeats until you get a break!
# "break" stop a for loop, while loop and repeat
x <- 0
bin <- c()
repeat{
  print(x)
  bin <- c(bin,x)
  x <- rnorm(1, mean = 0, sd = 1)
  if (x > 2){break}
}
print(x)
bin

# "break" stop a for loop, while loop and repeat
for (i in 1:10){
  print(i)
  if (i==5){break}
}


