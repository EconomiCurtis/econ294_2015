#' SOlutions to Assignment 4
#' Curtis Kephart
#' Winter 2014
#' Econ 294

library(dplyr)
library(tidyr)


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# 0. 
print("Curtis Kephart")
print("0142214")

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# 1. load data

flights <- read.csv(
  "data/flights.csv",
  stringsAsFactors = F) %>%
  tbl_df()
flights  

planes <- read.csv(
  "data/planes.csv",
  stringsAsFactors = F) %>%
  tbl_df()
planes

weather <- read.csv(
  "data/weather.csv",
  stringsAsFactors = F) %>%
  tbl_df()
weather

airports <- read.csv(
  "data/airports.csv",
  stringsAsFactors = F) %>%
  tbl_df()
airports

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# 2.

flights <- flights %>%
  mutate(date = as.Date(date))        # using mutate
weather$date <- as.Date(weather$date) # just as easy
flights$date <- as.Date(flights$date)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# 3.

airports.2a <- airports %>%
  dplyr::filter(
    city %in% c("San Francisco", "Oakland") & state == "CA")

flights.2a <- flights %>%
  dplyr::filter(dest %in% airports.2a$iata)
print(paste("2a:", nrow(flights.2a)))


flights.2b <- flights %>%
  dplyr::filter(
    dep_delay >= 60 | arr_delay >= 60
  )
print(paste("2b:", nrow(flights.2b)))

flights.2c <- flights %>%
  dplyr::filter(
     arr_delay > 2 * dep_delay
  )
print(paste("2c:", nrow(flights.2c)))


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# 4.

select(flights, dep_delay, arr_delay)
select(flights, dep_delay:arr_delay)
select(flights, ends_with("delay"))
select(flights, contains("_delay"))
select(flights, 6:7)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# 5.

print("5a:")
flights %>% 
  arrange(-dep_delay) %>%
  head(5) %>%
  print()

print("5b:")
flights %>%
  arrange(arr_delay - dep_delay) %>%
  head(5) %>%
  print()

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# 6.

flights <- flights %>% 
  mutate(
    speed  = dist / (time / 60),
    delta = arr_delay - dep_delay)

print("6a:")
flights %>% 
  mutate(
    speed  = dist / (time / 60),
    delta = arr_delay - dep_delay) %>%
  arrange(speed) %>%
  head(5) %>%
  print()

print("6b:")
flights %>% 
  mutate(
    speed  = dist / (time / 60),
    delta = arr_delay - dep_delay) %>%
  arrange(delta) %>%
  head(5) %>%
  print()

print("6c:")
flights %>% 
  mutate(
    speed  = dist / (time / 60),
    delta = arr_delay - dep_delay) %>%
  arrange(-delta) %>%
  head(5) 


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# 7.


flights.7a <- flights %>%
  group_by(carrier) %>%
  summarize(
    can_flights = sum(cancelled),
    n_flights   = n(),
    prct_flights_cancelled = can_flights / n_flights,
    delta_min = min(delta, na.rm = T),
    delta_q25 = quantile(delta, 0.25, na.rm = T),
    delta_med = median(delta, na.rm = T),
    delta_avg = mean(delta, na.rm = T),
    delta_q75 = quantile(delta, 0.75, na.rm = T),
    delta_q90 = quantile(delta, 0.9, na.rm = T),
    delta_max = max(delta, na.rm = T)
  ) %>%
  arrange(desc(prct_flights_cancelled))
print(flights.7a)

print("7b:")
cat("
      day_delay <- flights %>%
        dplyr::filter(!is.na(dep_delay)) %>%
        group_by(date) %>%
        summarize(
          delay = mean(dep_delay),
          n = n()) %>%
        filter(n > 10)
    ")



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# 9.
dest_delay <- flights %>%
  group_by(dest) %>%
  summarize(
    arr_delay.avg = mean(arr_delay, na.rm = T),
    flights.arrdelayNAs = sum(is.na(arr_delay)),
    flights = n()
  )

print(
  paste(
    "dest_delay has ", nrow(dest_delay), "obs",
    "and airports has", nrow(airports), "obs"
  )
)

df.9a. <- left_join(
  dest_delay, 
  select(airports, dest = iata, name = airport, everything()), 
  by = "dest"
) %>% 
  arrange(desc(arr_delay.avg))

df.9b. <- inner_join(
  dest_delay, 
  select(airports, dest = iata, name = airport, everything()), 
  by = "dest"
)

nrow(df.9b.) == nrow(df.9a.)
print("Rows don't match, there are airports in flights that don't appear in the airports dataset")

df.9c. <- right_join(
  dest_delay, 
  select(airports, dest = iata, name = airport, everything()), 
  by = "dest"
)
nrow(df.9c.)
print("df.9c. has the same number of rows as the airports df")
print("that isn't surprising since airports is the 2nd table of this right_join")
sum(is.na(df.9c.$arr_delay.avg))
print(
  paste(
    "there are ",sum(is.na(df.9c.$arr_delay.avg)),"NAs in average arr_delay",
    "in the newly merged data frame",
    "The non-NAs are all the 114 obs merged over from dest_delay"
  )
)


df.9d. <- full_join(
  dest_delay, 
  select(airports, dest = iata, name = airport, everything()), 
  by = "dest"
)
nrow(df.9d.)
print("there are now 3378 rows in df.9d.")
print("the 3376 obs from the airports df")
print("plus two more airports that were in flights but not in airports")





# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# 10.

hourly_delay <- flights %>%
  dplyr::filter(!is.na(dep_delay)) %>%
  group_by(date, hour) %>%
  summarize(
    delay = mean(dep_delay),
    n = n()) %>%
  filter(n > 10)

hourly_delay <- hourly_delay %>%
  left_join(weather) %>%
  arrange(delay) %>% arrange(delay)

hourly_delay %>% 
  group_by(conditions) %>%
  summarize(
    delay_avg = mean(delay),
    delay_med = median(delay),
    n = n()
  ) %>%
  arrange(-delay_avg)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# 11

##
print("11a.")
#start
df <- data.frame(treatment = c("a", "b"), subject1 = c(3, 4), subject2 = c(5, 6))

#end:
data.frame(
  subject = c(1,1,2,2),
  treatment = c("a","b","a","b"),
  value = c(3,4,5,6)
)

df %>% gather(subject, value, -treatment) %>%
  mutate(subject = extract_numeric(subject)) %>%
  select(subject, treatment, value) %>%
  arrange(subject, treatment)

##
print("11b.")
df <- data.frame(
  subject = c(1,1,2,2),
  treatment = c("a","b","a","b"),
  value = c(3,4,5,6)
)

df %>% spread(subject, value) %>%
  rename(subject1 = `1`,
         subject2 = `2`)

##
print("11c")

df <- data.frame(
  subject = c(1,1,2,2),
  treatment = c("a","b","a","b"),
  value = c(3,4,5,6)
)
df

## 
print("11d")
df <- data.frame(
  subject = c(1,2,3,4),
  sex = c("f","f","m",NA),
  age = c(11,55,65,NA),
  city = c("DC","NY","WA",NA),
  value = c(3,4,5,6),
  stringsAsFactors = F
)
df




















df <- df %>%
  unite(
  demo, 
  ... = sex, age, city, 
  sep = "."
) %>% replace(
    . == "NA.NA.NA",
    NA
  )

