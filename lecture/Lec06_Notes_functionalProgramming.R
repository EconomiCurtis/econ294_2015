# Lecture 6
# Functional programming
# working with functions

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Recap - 


# R is a Block structure language:   
# A "single statement" is a single line, or grouped by curly braces
1 + 1
1 + 2
#, note, use a new line to separate single statments
#RUN:          1 + 1 1 + 2  # nope, error


# Use a semi-colon to separate multiple (but distinct) statments
1 + 1 ; 1 + 2
# or use multiple lines

# A "block" 
# 	- a block of code is a group of statements
#   - grouped by braces {}
#   - use indentation for good style. 
{
  1 + 1
  1 + 2
}
{
  1 + 1 ; 1 + 2
}


# Control Structures
for (i in 1:10){
  print(i * 2)
} #note the use of blocks

# while loop
cnt <- 1
while(cnt <= 10){
  print(cnt * 2)
  cnt <- cnt + 1
}

# very flexible
for(FILE in list.files("data")){
  print(FILE)
} #on my computer, this reads out everything in the folder "data"


# Loopoing over non-vectors
# - note that in the loops above, we could over iterate over a vector
# apply family of functions
NHIS_2007 <- read.csv(file = "data/NHIS_2007_CSV.csv")
summary(NHIS_2007)
?apply
apply(
  NHIS_2007,
  2,
  FUN = summary
) #applies "summary" function to each object


# get() 
# - how do we loop over object names?
x <- rnorm(10)
y <- rnorm(10, 50,10)
#how loop over x, y and others? 
for (v in c(x,y)){
  print(mean(v))
} # nope, what went wrong? 

for (v in c("x","y")){ #note, objects by character name
  print(v)
  v.2 <- get(v)
  print(mean(v.2))
} # yes






# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Creating a function

# Name, assignment, arguments, return
mean.nu <- function(x){
  sum(x) / length(x)
}

x.1 <- rnorm(1000, mean = 0, sd = 1)
mean.nu(x.1)
mean.nu(
  rnorm(1000, mean = 1000, sd = 10)
  )



# Default arguements
mean.nu() # error
mean.nu <- function(x = rnorm(100)){  #note , default argument given
  sum(x) / length(x)
}
mean.nu() #works with default arguement
mean.nu(rnorm(1000, mean = 500)) #override default arguement

# Multiple arguements
# - weighted mean
mean.w.nu <- function(x, w){
  x.w <- x * w #need to be same length 
  sum(x.w) / sum(w)
}
mean.w.nu(c(1,2,3,4),
          c(10,1,1,10))
mean(
  rep(c(1,2,3,4),
      c(10,1,1,10))
)


# "..." What does that do?
stndz <- function(x, ...){
  (x - mean(x, ...)) / (sd(x, ...))
}

stndz(1:10)

stndz(c(1:10, NA))

stndz(c(1:10, NA), na.rm = T)


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Return
# what value or object or objects will your function return?
# without "return()", the func will return the last value of the last executed statment
# (see all examples above)

oddcount <- function(x) {
  # count the number of odd numbers in a vector
  k <- 0
  for (n in x) {
    if (n %% 2 == 1) k <- k+1
  }
  return(k)
}
oddcount(c(1,2,3,4,5,6,7,8,9,10))

#now, without the return statement
oddcount <- function(x) {
  # count the number of odd numbers in a vector
  k <- 0
  for (n in x) {
    if (n %% 2 == 1) k <- k+1
  }
}
oddcount(c(1,2,3,4,5,6,7,8,9,10))
# nothing returned - the last statement is for, returnning NULL
x <- oddcount(c(1,2,3,4,5,6,7,8,9,10))
x


# When to explicitly use return() ?
# - when you def need to, 
# - calling return can slow your function, no don't call it unless you have to
oddcount.return <- function(x) {
  # count the number of odd numbers in a vector
  k <- 0
  for (n in x) {
    if (n %% 2 == 1) k <- k+1
  }
  return(k)
}
system.time({
  oddcount.return(1:5000000)
}) # aboot 9.25s

oddcount.noReturn <- function(x) {
  # count the number of odd numbers in a vector
  k <- 0
  for (n in x) {
    if (n %% 2 == 1) k <- k+1
  }
  k
}
system.time({
  oddcount.noReturn(1:5000000)
}) #aboot 14.9s

# "oddcount.return" will tend to runa bit slower
# this can add up,
# convention to not call return unless you have to (say, if/else statments)


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# functions as objects
# - note, you called the function "function" to build the "g" function
oddcount <- function(x = 1:10) {
  # count the number of odd numbers in a vector
  k <- 0
  for (n in x) {
    if (n %% 2 == 1) k <- k+1
  }
  return(k)
}

# what's in your function? 
formals(oddcount)
body(oddcount)
View(oddcount) # in R
oddcount
page(oddcount) # edit the function - be careful



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Function Environment and Scope

rm(list = ls()) #just clearing workspace
x <- 10                  # x global
f <- function(y) {       # f() global, y is local to f(), and global to h()
  z <- 8                 # z local to f(), but global to h()   
  h <- function() {      # h() local to f()
    return(z*(x+y))
  }
  return(h())
}
environment(f)
# note "<environment: R_GlobalEnv>" 

ls() #lists objects in an environment (in this case, the top level environment)
ls.str() #more detailed info

# Scope hierarchy
# - we created f, and the function h() and variable z inside of f
# - f() and x are global now
# - we say that h() and z are local to f
# - the hierarchy now has z global to h
# - y (an argument to f) is local to f(), and global to h()
# THink of these layers of the onion!

f(100)
# z * ( x +   y)
# 8 * (10 + 100)

h #note, h doesn't exist any more

# Note the local environment
rm(list = ls()) #just clearing workspace
x <- 10                  # x global
f <- function(y) {       # f() global, y is local to f(), and global to h()
  z <- 8                 # z local to f(), but global to h()   
  h <- function() {      # h() local to f()
    return(z*(x+y))
  }
  print(environment(h))
  print(ls.str())
  print("")
  print(ls.str(envir=parent.frame(n=1)))
  return(h())
}
f(2) # 8 * (10 + 2)
environment(f)

#now changing global variable x
x <- 500
f(2) # 8 * (500 + 2)
# be careful!


# Discuss "lazy evaluation" 
# - compiled vs scripting language
# - interactive language

# Discuss function side effects
# - functions don't change non-local variables
# - (unless told to)
x <- 10
f <- function(y){
  z <- 8
  x <- x + 1 #new local x
  print(paste("x is now:",x))
  h <- function(){return(z * (y+x))}
  return(h())
}
f(4)
x #note, x wasn't updated in the global environment
# only the copy of x in the local environemnt to f was changed. 
# there are ways to change global variables in a function, we'll not teach them
# be thankful you aren't programming in javascript

# Pointers in R
# - R doesn't have any pointers or references like those in C (some experimental features...)
# in python: 
# >>> x = [13,5,12]
# >>> x.sort()
# >>> x
# [5, 12, 13]
# note: x changed
x <- c(13,5,12)
sort(x)
x # x is unchanged
x <- sort(x) #this dupblicates the vector x
x 

# Return lists
# - if you have a lot for your function to return
# - then return a list
summarize.vec <- function(x){
  result <- list(
    mean       = mean(x),
    sd         = sd(x),
    median     = median(x),
    length     = length(x)
  )
}
x <- c(rnorm(1000, mean = 100, sd = 50))
x.sum <- summarize.vec(x)
x.sum
x.sum$mean
x.sum$sd
x.sum$median
x.sum$length

  
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

