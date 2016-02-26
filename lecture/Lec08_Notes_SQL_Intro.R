# Intro to SQL with dplyr
# based on Lukas Eder's "10 Easy Steps to a Complete Understanding of SQL"
# and dplyr's databases tutorial 

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Setting up a SQLlite db ----

library("dplyr")  #for dplyr
library("RSQLite") #for sqllite
library("nycflights13") #for data

my_db <- src_sqlite("my_db.sqlite3", create = T)

# creates `flights_sqlite` db table
flights_sqlite <- copy_to(
  my_db, flights, temporary = FALSE, 
  indexes = list(
    c("year", "month", "day"), 
    "carrier", 
    "tailnum")
  )

airlines_sqlite <- copy_to(
  my_db, airlines, temporary = FALSE, 
  indexes = list("carrier")
)

airports_sqlite <- copy_to(
  my_db, airports, temporary = FALSE, 
  indexes = list("faa")
)

planes_sqlite <- copy_to(
  my_db, planes, temporary = FALSE, 
  indexes = list("tailnum")
)

weather_sqlite <- copy_to(
  my_db, weather, temporary = FALSE, 
  indexes = list(
    c("year", "month","day","hour"),
    "origin")
)


#' discuss:
#' - sqllite (support for mysql, portgres, bigquery)
#' - src
#' - index

#' nycflights13 has a built-in src that will cache flights (and the rest) 
#' in a standard location: 
nycflights13_sqlite()
my_db
flights_sqlite <- tbl(my_db, "flights")
flights_sqlite
?tbl # creates a data frame table from a src query

# dplyr: Return an actual tbl_df data.frame with collect
tbl(my_db, sql("SELECT * FROM flights")) %>% 
  collect()
# dplyr waits until it absolutely has to return the spl query. 
# collect runs the query on the sql db

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# 1. SQL is declaritive --------

# return 
tbl(my_db, sql("SELECT * FROM flights"))
?sql # sql query to return to for tbl. 


# declaritive
#' "The only paradigm where you "just" declare the nature of the results that you 
#' would like to get. Not how your computer shall compute those results. 
#' Isn't that wonderful?"
tbl(my_db, 
    sql("SELECT year, month, day, tailnum, dep_delay 
        FROM flights 
        where dep_delay > 30"))
#' "Easy to understand. 
#' You don't care where flight records physically come from. 
#' You just want those that have big departure delays.."


#' "What do we learn from this?
#' If this is so simple, what's the problem? 
#' The problem is that most of us intuitively think in terms of imperative programming. 
#' As in: "machine, do this, and then do that, but before, run a check and fail 
#' if this-and-that". This includes storing temporary results in variables, 
#' writing loops, iterating, calling functions, etc. etc.
#' 
#' Forget about all that. Think about how to declare things. 
#' Not about how to tell the machine to compute things.

# dplyr's select, mutate
tbl(my_db, 
    sql("SELECT tailnum, dep_delay, arr_delay, flights.dep_delay + flights.arr_delay as z
        FROM flights")
    )

# basically: dplyr's mutate, filter, select
tbl(my_db, 
    sql("SELECT tailnum, dep_delay, arr_delay, flights.dep_delay + flights.arr_delay as z
        FROM flights
        WHERE z > 50")
    )
# doesn't work this way in all sql implementations. 

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# basic select commands --------------
# SELECT [ DISTINCT ]
# FROM
# WHERE
# GROUP BY
# HAVING
# UNION
# ORDER BY

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# 3. SQL is about table references -----

tbl(my_db, 
    sql("SELECT * from planes")
    ) %>% 
  collect()
# 3322 rows, 9 columns

tbl(my_db, 
    sql("SELECT * from airports")
    )%>% 
  collect()
# 1397 rows, 7 columns


temp <- tbl(my_db, 
    sql("SELECT *
        from airports, planes")
    ) %>% 
  collect()
temp
#' note:
#' - 4640834 rows, that's 3322*1397
#' - 16 columns, that's 7+9

#' Think: this big table is the starting point from which your query is then 
#' cut down, mutated, filtered, summarized, etc etc. 

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# 4. SQL table references can be rather powerful -----

flights_planes1 <- tbl(my_db, 
            sql("select *
                 from flights join planes 
                 ON flights.tailnum = planes.tailnum")
) %>% 
  collect()
flights_planes1
# note names of identically named columns

# from dply, this is an inner_join
flights_planes2 <- inner_join(flights, planes, by = "tailnum") %>% tbl_df
flights_planes2
# note names

flights_planes3 <- inner_join(
  tbl(my_db, "flights"),
  tbl(my_db, "planes"),
  by = "tailnum") %>%
  collect() 
flights_planes3
# note names

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# you get all the joins

# mutating joins:
# recall left_join, right_join, full_join, inner_join

lefty <- left_join(
  tbl(my_db, "flights"),
  tbl(my_db, "planes"),
  by = "tailnum")
explain(lefty)

# note the full SQL query:
tbl(my_db, 
    sql(
      '(SELECT * FROM (SELECT "year" AS "year.x", "month" AS "month", "day" AS "day", "dep_time" AS "dep_time", "dep_delay" AS "dep_delay", "arr_time" AS "arr_time", "arr_delay" AS "arr_delay", "carrier" AS "carrier", "tailnum" AS "tailnum", "flight" AS "flight", "origin" AS "origin", "dest" AS "dest", "air_time" AS "air_time", "distance" AS "distance", "hour" AS "hour", "minute" AS "minute"
      FROM "flights") AS "zzz78"
      
      LEFT JOIN 
      
      (SELECT "tailnum" AS "tailnum", "year" AS "year.y", "type" AS "type", "manufacturer" AS "manufacturer", "model" AS "model", "engines" AS "engines", "seats" AS "seats", "speed" AS "speed", "engine" AS "engine"
      FROM "planes") AS "zzz79"
      
      USING ("tailnum")) AS "zzz80"'
      )
    ) %>% 
  collect()



inny <- inner_join(
  tbl(my_db, "flights"),
  tbl(my_db, "planes"),
  by = "tailnum")
explain(inny)

# not all joins are implemented: 
righty <- right_join(
  tbl(my_db, "flights"),
  tbl(my_db, "planes"),
  by = "tailnum")


# Two types of filtering joins
# - semi_join(x, y) keeps all observations in x that have a match in y.
# - anti_join(x, y) drops all observations in x that have a match in y.


anty <- anti_join(
  tbl(my_db, "flights"),
  tbl(my_db, "planes"),
  by = "tailnum"
)
explain(anty)


semy <- semi_join(
  tbl(my_db, "flights"),
  tbl(my_db, "planes"),
  by = "tailnum"
)
explain(semy)


# set operations
# combine the observations in the data sets as if they were set elements.
# - intersect(x, y): return only observations in both x and y
# - union(x, y): return unique observations in x and y
# - setdiff(x, y): return observations in x, but not in y.
# Might help: https://rickscraftofaudit.files.wordpress.com/2014/10/sets.png

# the planes (by unique tailnum) in both flights and planes
length(unique(flights$tailnum)) #4044
length(unique(planes$tailnum))  #3322
intersect(
  tbl(my_db, "flights") %>% select(tailnum),
  tbl(my_db, "planes") %>% select(tailnum)
) %>% collect()
# returns 3322 results

# the planes in both flights and planes
union(
  tbl(my_db, "flights") %>% select(tailnum),
  tbl(my_db, "planes") %>% select(tailnum)
) %>% collect()
# 4044 planes

# the planes in flights, but not in planes
setdiff(
  tbl(my_db, "flights") %>% select(tailnum),
  tbl(my_db, "planes") %>% select(tailnum)
) %>% collect()
# 722 tailnums in flights but not in planes  

# the planes in flights, but not in planes
setdiff(
  tbl(my_db, "planes") %>% select(tailnum),
  tbl(my_db, "flights") %>% select(tailnum)
) %>% collect()
# no tailnums in planes that aren't in flights

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Group by ----

# in dplyr
flights.delaysum.df <- flights %>%
  group_by(year, month, day) %>%
  summarize(
    delaymean = mean(dep_delay, na.rm = T)
  )
flights.delaysum.df

# in sqllite dplyr
flights.delaysum.sql <- tbl(my_db, "flights") %>%
  group_by(year, month, day) %>%
  summarize(
    delaymean = mean(dep_delay)    # NOTE THE NA.RM....., INCLUDE AND SEE ERROR
  ) %>% collect()
flights.delaysum.sql

# do they match?  yes, prettimuch
# 365 rows, and: 
sum(flights.delaysum.df$delaymean == flights.delaysum.sql$delaymean)
flights.delaysum.df[flights.delaysum.df$delaymean != flights.delaysum.sql$delaymean,]
flights.delaysum.sql[flights.delaysum.df$delaymean != flights.delaysum.sql$delaymean,]
# issue only with floating point arithmatic


flights.delaysum.sql.ex <- tbl(my_db, "flights") %>%
  group_by(year, month, day) %>%
  summarize(
    delaymean = mean(dep_delay)    # NOTE THE NA.RM....., INCLUDE AND SEE ERROR
  )
explain(flights.delaysum.sql.ex)



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# R to SQL translation is currently limited. --------
# issues, you can't do in sql all that you can do in R. 

# let's try to calc the geometric mean in a summarize in sql.
mean.geom <- function(x, ...){
  sqrt(prod(x,...))
}
flights.delaysum.sql.ex <- tbl(my_db, "flights") %>%
  group_by(year, month, day) %>%
  summarize(
    delaymean = mean(dep_delay),
    delaymean.geom = mean.geom(dep_delay)
  ) %>% collect()
explain(flights.delaysum.sql.ex)
# Error in sqliteSendQuery(conn, statement) : 
# error in statement: no such function: mean.geom
# sql is (mostly) not a functional programming language. 


# dplyr knows how to convert the following R functions to SQL:
# - basic math operators: +, -, *, /, %%, ^
# - math functions: abs, acos, acosh, asin, asinh, atan, atan2, atanh, ceiling, cos, cosh, cot, coth, exp, floor, log, log10, round, sign, sin, sinh, sqrt, tan, tanh
# - logical comparisons: <, <=, !=, >=, >, ==, %in%
# - boolean operations: &, &&, |, ||, !, xor
# - basic aggregations: mean, sum, min, max, sd, var
# but that's it

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Basic dplyr verbs ------

select(flights_sqlite, year:day, dep_delay, arr_delay)

filter(flights_sqlite, dep_delay > 240)

arrange(flights_sqlite, year, month, day)

mutate(flights_sqlite, 
       speed = air_time / distance)

summarise(flights_sqlite, 
          delay = mean(dep_time))


#' The most important difference is that the expressions in select(), filter(), 
#' arrange(), mutate(), and summarise() 
#' are translated into SQL so they can be run on the database. 
#' 
#' This translation is almost perfect for the most common operations but there
#' are some limitations, which you’ll learn about later.


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# laziness ------
#' When working with databases, dplyr tries to be as lazy as possible. 
#' 
#' It’s lazy in two ways:
#' - It never pulls data back to R unless you explicitly ask for it.
#' - It delays doing any work until the last possible minute, 
#'   collecting together everything you want to do then sending 
#'   that to the database in one step.


c1 <- filter(flights_sqlite, year == 2013, month == 1, day == 1)
c2 <- select(c1, year, month, day, carrier, dep_delay, air_time, distance)
c3 <- mutate(c2, speed = distance / air_time * 60)
c4 <- arrange(c3, year, month, day, carrier)
#' Suprisingly, this sequence of operations never actually touches the database. 
#' It’s not until you ask for the data (e.g. by printing c4) that dplyr 
#' generates the SQL and requests the results from the database, and even then 
#' it only pulls down 10 rows.
c4

# To pull down all the results use collect(), which returns a tbl_df():
c4 %>% collect()

c4$query #the query we'll eventually run, when collect is run

explain(c4) # the plan to execute the query

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Forcing computation
#' There are three ways to force the computation of a query:
#' - collect() executes the query and returns the results to R.
#' - compute() executes the query and stores the results in a temporary table 
#'   in the database.
#' - collapse() turns the query into a table expression.

#' dplyr tries to prevent you from accidentally performing expensive query operations:
#' - nrow() is always NA: in general, there’s no way to determine how many rows a query will return unless you actually run it.
#' - Printing a tbl only runs the query enough to get the first 10 rows
#' - You can’t use tail() on database tbls: you can’t find the last rows without executing the whole query.

# You are most likely to use collect(): once you have interactively converged on 
# the right set of operations, use collect() to pull down the data into a local 
# tbl_df(). 


#' SQL queires can take quite long, 
#' this pre-collect tools can be quite handy





















