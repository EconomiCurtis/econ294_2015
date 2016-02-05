# dplyr two-table verbs. 

# Borrow heavily from the dplyr two-table verbs vignette 
# console:   browseVignettes("dplyr")
# also bit.ly/wrangling-webinar pg 131

library(dplyr)

library("nycflights13") # some data
# go to Envirnment Tab >> "Global Environment" >> package:nyxflights13

flights %>% tbl_df() # obs are single flights, with some stats
flights2 <- flights %>% select(year:day, hour, origin, dest, tailnum, carrier)
flights2

airlines %>% tbl_df() # obs are airports

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# dplyr::left_join()
# a couple of examples
?left_join
# note: takes two tables are arguments

flights2 %>% 
  left_join(airlines)
# first table is flights2
# 2nd table is airlines

# if no "by" argument given, note NULL
# joins by all shared columns
# in this case, by carrier
# we know have the full name of hte carrier

## Controlling how the tables are matched

#natural join - join by all shared colum s
weather %>% tbl_df # shared five columns
flights2 %>% 
  left_join(weather) 
# this is a "natural" join

# join by one column
planes %>% tbl_df
names(planes) %in% names(flights2) #note, they share two variable names
flights2 %>% 
  left_join(planes, 
            by = "tailnum")
# join ONLY BY tailnum

# Join by variable name, but name isn't identical?
flights2; distinct(select(flights2, dest))
airports; distinct(select(airports, faa))
# join dest in flights2 and faa in airports
flights2 %>% 
  left_join(airports, 
            by = c("dest" = "faa")) #slightly annoying with the need for quote marks

# but you have options:
flights2 %>% 
  left_join(airports, 
            by = c("origin" = "faa"))

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# THREE FAMILIES OF JoiNS
# - Mutating joins, which add new variables to one table from matching rows in another.
# - Filtering joins, which filter observations from one table based on whether or not they match an observation in the other table.
# - Set operations, which combine the observations in the data sets as if they were set elements.


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# #MUTATING JOINS
# which add new variables to one table from matching rows in another.
# Four types of mutating joins
# see bit.ly/wrangling-webinar pg 131

# setup
df1 <- data_frame(x = 1:2, y = c(1L, 1L))
df2 <- data_frame(x = 1:2, y = 1:2)



# left_join 
df2 %>% left_join(df1)
# left_join(x, y) includes all observations in x, regardless of whether they match or not. 
# very commonly used join - it ensures  you don’t lose obs from your primary (1st) table.
# also see page 137-141

# right join
df1 %>% right_join(df2)
# right_join(x, y) includes all observations in y. 
# It’s equivalent to left_join(y, x), but the columns will be ordered differently.
df2 %>% left_join(df1)

# full_join
df1 %>% full_join(df2)
# full_join() includes all observations from x and y.
# see page 

# inner_join
df1 %>% inner_join(df2)
# inner_join(x, y) only includes observations that match in both x and y.
# see page 142

# Extra 1
# Outter join?
# The left, right and full joins are collectively know as outer joins. 
# When a row doesn’t match in an outer join, the new variables are filled in with missing values.

# Extra 2 - beware!
df1 <- data_frame(x = c(1, 1, 2), y = 1:3)
df2 <- data_frame(x = c(1, 1, 2), z = c("a", "b", "a"))

df1
df2 
df1 %>% left_join(df2)
# what if: joins by shared "x" variable, but there are multiple rows with that name. 
# If a match is not unique, a join will add all possible combinations (the Cartesian product) 
# of the matching observations. That may not be what you want!!

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Filtering Joins
# which filter observations from one table based on whether 
#  or not they match an observation in the other table.

# Two types of filtering joins
# - semi_join(x, y) keeps all observations in x that have a match in y.
# - anti_join(x, y) drops all observations in x that have a match in y.

# e.g see page 143 & 144

# These are most useful for diagnosing join mismatches.
# e.g. many flights in the nycflights13 dataset don’t have a matching tail number in `planes`
flights %>% 
  anti_join(planes, by = "tailnum") %>% 
  count(tailnum, sort = TRUE) #
# these are all planes in flights that are not in planes. 



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# SET OPERATIONS
# combine the observations in the data sets as if they were set elements.
# - intersect(x, y): return only observations in both x and y
# - union(x, y): return unique observations in x and y
# - setdiff(x, y): return observations in x, but not in y.
# Might help: https://rickscraftofaudit.files.wordpress.com/2014/10/sets.png

# setup
df1 <- data_frame(x = 1:2, y = c(1L, 1L))
df2 <- data_frame(x = 1:2, y = 1:2)

# intersect - only observations in both x and y
# see page 135
df1;df2
intersect(df1, df2)

# union - unique observations in x and y
# see page 134
union(df1, df2)

# setdiff() - observations in x, but not in y.
# see page 136
setdiff(df1,df2)


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
## Some extras

# basics
# dplyr::bind_cols()
df1 <- data_frame(x = 1:2, y = c(1L, 1L))
df2 <- data_frame(x = 1:2, y = 1:2)
bind_cols(df1, df2)

# dplyr::bind_rows()
bind_rows(df1, df2)

# what if cols don't match?
bind_rows(
  data.frame(
    x1 = 1:3,
    x2 = LETTERS[1:3]
  ),
  data.frame(
    x1 = 5:7,
    NEWCOL = LETTERS[5:7]
  )
)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Coercion rules
# merge by columns of same name, but different primitive type? 

# FACTOR + CHAR
# merge factor column with character string column?
# unless factor levels perfectly match, 
# join will coerce to string.    

# Otherwise:
# - logicals will be silently upcast to integer, 
# - and integer to numeric, 
# - but coercing (log, num, int) to character will raise an error

