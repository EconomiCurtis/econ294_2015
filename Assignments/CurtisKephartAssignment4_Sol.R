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
print(paste("2a:", nrow(flights.2a))) #3508


flights.2b <- flights %>%
  dplyr::filter(
    dep_delay >= 60 | arr_delay >= 60
  )
print(paste("2b:", nrow(flights.2b))) #11920

flights.2c <- flights %>%
  dplyr::filter(
     arr_delay > 2 * dep_delay
  )
print(paste("2c:", nrow(flights.2c))) #70772


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
  print() #CO 1 HNL, AA 1740 DFW, MQ 3786 ORD, UA 855 DFO, MQ 3859 ORD
#         date  hour minute   dep   arr dep_delay arr_delay carrier flight  dest  plane cancelled  time  dist    speed delta
#       (date) (int)  (int) (int) (int)     (int)     (int)   (chr)  (int) (chr)  (chr)     (int) (int) (int)    (dbl) (int)
# 1 2011-08-01     1     56   156   452       981       957      CO      1   HNL N69063         0   461  3904 508.1128    24
# 2 2011-12-12     6     50   650   808       970       978      AA   1740   DFW N473AA         0    49   224 274.2857    -8
# 3 2011-11-08     7     21   721   948       931       918      MQ   3786   ORD N502MQ         0   120   925 462.5000    13
# 4 2011-06-21    23     34  2334   124       869       861      UA    855   SFO N670UA         0   216  1635 454.1667     8
# 5 2011-06-09    20     29  2029  2243       814       793      MQ   3859   ORD N6EAMQ         0   117   925 474.3590    21

print("5b:")
flights %>%
  arrange(arr_delay - dep_delay) %>%
  head(5) %>%
  print()
#         date  hour minute   dep   arr dep_delay arr_delay carrier flight  dest  plane cancelled  time  dist    speed delta
#       (date) (int)  (int) (int) (int)     (int)     (int)   (chr)  (int) (chr)  (chr)     (int) (int) (int)    (dbl) (int)
# 1 2011-07-03    19     14  1914  2039        -1       -70      XE   2804   MEM N12157         0    66   468 425.4545    69
# 2 2011-12-24    12      9  1209  1346        54        -3      CO   1669   SFO N73406         0   201  1635 488.0597    57
# 3 2011-12-24    21     29  2129  2337        -1       -55      CO   1552   SEA N37437         0   234  1874 480.5128    54
# 4 2011-12-24    21     17  2117  2258         2       -51      CO   1712   SFO N74856         0   200  1635 490.5000    53
# 5 2011-12-25     7     41   741   926        -4       -57      OO   4591   SLC N814SK         0   147  1195 487.7551    53

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
  arrange(desc(speed)) %>%
  head(5) %>%
#   print()
#         date  hour minute   dep   arr dep_delay arr_delay carrier flight  dest  plane cancelled  time  dist delaydiff    speed delta deltaloss
#       (date) (int)  (int) (int) (int)     (int)     (int)   (chr)  (int) (chr)  (chr)     (int) (int) (int)     (int)    (dbl) (int)     (int)
# 1 2011-08-31    12     55  1255  1346         0        -7      CO   1646   AUS N11612         0    11   140         7 763.6364    -7        -7
# 2 2011-01-08    16     20  1620  1730         0       -27      EV   5229   MEM N451CA         0    42   469        27 670.0000   -27       -27
# 3 2011-02-21     8     34   834  1156       -11       -10      US    944   CLT N409US         0    85   913        -1 644.4706     1         1
# 4 2011-10-09    11      4  1104  1117        -1       -13      XE   4634   HOB N11121         0    47   501        12 639.5745   -12       -12
# 5 2011-03-09    19      5  1905  2225         0       -10      CO    500   IND N19638         0    82   845        10 618.2927   -10       -10

print("6b:")
flights %>% 
  mutate(
    speed  = dist / (time / 60),
    delta = arr_delay - dep_delay) %>%
  arrange(delta) %>%
  head(5) %>%
  print()
#         date  hour minute   dep   arr dep_delay arr_delay carrier flight  dest  plane cancelled  time  dist delaydiff    speed delta deltaloss
#       (date) (int)  (int) (int) (int)     (int)     (int)   (chr)  (int) (chr)  (chr)     (int) (int) (int)     (int)    (dbl) (int)     (int)
# 1 2011-07-03    19     14  1914  2039        -1       -70      XE   2804   MEM N12157         0    66   468        69 425.4545   -69       -69
# 2 2011-12-24    12      9  1209  1346        54        -3      CO   1669   SFO N73406         0   201  1635        57 488.0597   -57       -57
# 3 2011-12-24    21     29  2129  2337        -1       -55      CO   1552   SEA N37437         0   234  1874        54 480.5128   -54       -54
# 4 2011-12-24    21     17  2117  2258         2       -51      CO   1712   SFO N74856         0   200  1635        53 490.5000   -53       -53
# 5 2011-12-25     7     41   741   926        -4       -57      OO   4591   SLC N814SK         0   147  1195        53 487.7551   -53       -53



print("6c:")
flights %>% 
  mutate(
    speed  = dist / (time / 60),
    delta = arr_delay - dep_delay) %>%
  arrange(-delta) %>%
  head(5) 

#         date  hour minute   dep   arr dep_delay arr_delay carrier flight  dest  plane cancelled  time  dist delaydiff    speed delta deltaloss
#       (date) (int)  (int) (int) (int)     (int)     (int)   (chr)  (int) (chr)  (chr)     (int) (int) (int)     (int)    (dbl) (int)     (int)
# 1 2011-09-29    16     32  1632  2203         7       160      XE   2216   TYS N14998         0   105   771      -153 440.5714   153       153
# 2 2011-01-10    17     52  1752  2335        22       166      US   1944   CLT N417US         0   107   913      -144 511.9626   144       144
# 3 2011-09-29    16     27  1627  2015        27       170      WN    113   LAX N510SW         0   192  1390      -143 434.3750   143       143
# 4 2011-11-15    13     31  1331  1657         6       149      CO   1418   SAT N27722         0    54   191      -143 212.2222   143       143
# 5 2011-09-29    16     27  1627  2159        -8       134      XE   2496   SDF N14558         0   109   788      -142 433.7615   142       142
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
print(flights.7a) # 
#    carrier can_flights n_flights prct_flights_cancelled delta_min delta_q25 delta_med  delta_avg delta_q75 delta_q90 delta_max
#      (chr)       (int)     (int)                  (dbl)     (int)     (dbl)     (dbl)      (dbl)     (dbl)     (dbl)     (int)
# 1       EV          76      2204            0.034482759       -91     -1.00       6.0  5.0744932     12.00      18.0        40
# 2       MQ         135      4648            0.029044750      -128     -1.00       5.0  3.9027531     11.00      17.0        40
# 3       B6          18       695            0.025899281       -93     -4.00       6.0  3.5423477     13.00      20.0        37
# 4       AA          60      3244            0.018495684      -125      1.00       7.0  5.5160478     12.00      16.0        32
# 5       UA          34      2072            0.016409266      -132     -4.00       4.0  2.4530251     12.00      18.0        47
# 6       DL          42      2641            0.015903067      -115     -2.00       5.0  3.1918178     11.00      16.0        32
# 7       WN         703     45343            0.015504047      -143      2.00       6.0  5.8493129     10.00      16.0        45
# 8       XE        1132     73053            0.015495599      -153     -5.00       1.0 -0.5015000      6.00      10.0        69
# 9       OO         224     16061            0.013946828      -130     -6.00       1.0  0.1420696      7.00      14.0        53
# 10      YV           1        79            0.012658228       -61     -6.75       0.0 -2.4743590      6.75       9.3        23
# 11      US          46      4082            0.011268986      -144     -4.00       3.0  2.1702233     10.00      15.0        36
# 12      FL          21      2139            0.009817672       -91     -1.00       4.0  2.6669825      9.00      12.0        22
# 13      F9           6       838            0.007159905       -62     -8.00      -2.0 -2.5564904      4.00       9.0        25
# 14      CO         475     70032            0.006782614      -143     -3.00       4.0  3.1563000     11.00      17.0        57
# 15      AS           0       365            0.000000000       -71     -8.00       1.5  0.5439560     11.00      19.0        39
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
# 8.
day_delay <- flights %>%
  dplyr::filter(!is.na(dep_delay)) %>%
  group_by(date) %>%
  summarize(
    delay = mean(dep_delay),
    n = n()
    ) %>%
  ungroup() %>%
  mutate(
    day_delay = delay - lag(delay)) %>%
  arrange(desc(day_delay))

day_delay
#          date    delay     n day_delay
#        (date)    (dbl) (int)     (dbl)
# 1  2011-10-09 59.52586   580  54.85173
# 2  2011-06-22 62.30979   623  45.52492
# 3  2011-12-31 54.17137   461  44.47917
# 4  2011-05-12 64.52039   613  42.94578
# 5  2011-03-03 38.20064   628  35.97656
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
df.9a.
#     dest arr_delay.avg flights.arrdelayNAs flights                                name                 city state      lat
#    (chr)         (dbl)               (int)   (int)                               (chr)                (chr) (chr)    (dbl)
# 1    ANC      26.08065                   1     125 Ted Stevens Anchorage International            Anchorage    AK 61.17432
# 2    CID      17.80049                   4     410                       Eastern Iowa          Cedar Rapids    IA 41.88459
# 3    DSM      15.95110                  13     647            Des Moines International           Des Moines    IA 41.53493
# 4    SFO      14.89036                  18    2818         San Francisco International        San Francisco    CA 37.61900
# 5    BPT      14.33333                   0       3            Southeast Texas Regional Beaumont/Port Arthur    TX 29.95083
# 6    GRR      13.71729                  12     677           Kent County International         Grand Rapids    MI 42.88082
# 7    DAY      13.67117                   7     451             James M Cox Dayton Intl               Dayton    OH 39.90238
# 8    VPS      12.45718                  16     880                Eglin Air Force Base           Valparaiso    FL 30.48325
# 9    ECP      12.42222                   9     729                                  NA                   NA    NA       NA
# 10   SAV      12.33137                  12     863              Savannah International             Savannah    GA 32.12758
# ..   ...           ...                 ...     ...                                 ...                  ...   ...      ...



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
#' pretty clear that thunderstorms and heavy rain are associated with the 
#' biggests delays
#' wonder what cancelations are associated with. 

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

