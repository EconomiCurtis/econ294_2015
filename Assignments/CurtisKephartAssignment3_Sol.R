#' Curtis Kephart
#' Winter 2016
#' CurtisKephartAssignment3Creator.R
#' 


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# 0 
print("Curtis Kephart")
print(0142214)
print("curtisk@ucsc.edu")


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# 1
library(foreign)
df.ex <- read.dta(
  "https://github.com/EconomiCurtis/econ294_2015/raw/master/data/org_example.dta"
) %>% tbl_df()
#loaded this way, it's a data frae
class(df.ex)


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# 2
require(dplyr)
df.ex.2 <- dplyr::filter(
  df.ex, 
  year == 2013 & month == 12
)
print(nrow(df.ex.2))

df.ex.2 <- dplyr::filter(
  df.ex,   year == 2013 & (month == 7 | month == 8 | month == 9) #many other ways to do this
)
print(nrow(df.ex.2))

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# 3
df.ex.3a <- df.ex %>%
  dplyr::arrange(
    year, month
  )

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# 4
df.ex.4a <- df.ex %>%
  select(year:age)

df.ex.4b <- df.ex %>%
  select(year, month, starts_with("i"))

print(distinct(select(df.ex, state)) %>% as.data.frame())
# since I loaded df.ex as a tbl_df, print only printed the top 10 rows, 
# convert to regular df with "%>% as.data.frame()"
unique(df.ex$state) #an alternative with fewer keystrokes 


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# 5

stndz <- function(x){
  (x - mean(x, na.rm = T))  /  sd(x, na.rm = T)
}

nrmlz <- function(x){
  (x - min(x, na.rm = T)) / (max(x, na.rm = T) - min(x, na.rm = T))
}

df.ex.5a <- df.ex %>%
  dplyr::mutate(
    rw.stndz = stndz(rw),
    rw.nrmlz = nrmlz(rw)
  )

df.ex.5b <- df.ex %>%
  dplyr::group_by(year, month) %>%
  dplyr::mutate(
    rw.stndz = stndz(rw),
    rw.nrmlz = nrmlz(rw),
    count    = n()
  )


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# 6

df.ex.6 <- df.ex %>%
  dplyr::group_by(year, month, state) %>%
  dplyr::summarise(
    rw.min = min(rw, na.rm = T),
    rw.1stq = quantile(rw, 0.25, na.rm = T),
    rw.mean = mean(rw, na.rm = T),
    rw.median = median(rw, na.rm = T),
    rw.3rdq = quantile(rw, 0.75, na.rm = T),
    rw.max = max(rw, na.rm = T),
    count = n()
  )

print(nrow(df.ex.6))

df.ex.6 %>%
  arrange(desc(rw.mean)) %>%
  head()
# is that right? -nope
# why not? -annoyingly, since the summarize is grouped by year/month/state, 
#           arrange only sorts by that group
# Basically, congrats if you caught that, 
#            and double congrats if you figured out a solution. 

df.ex.6 %>%
  ungroup() %>%  #remove any grouping
  arrange(desc(rw.mean)) %>%
  head()
print("2013, 12 DC has highest mean rw")


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# 7 bonus

str(df.ex$state)

df.ex.7a <- df.ex %>%
  arrange(year, month, desc(state))
distinct(select(df.ex.7a))