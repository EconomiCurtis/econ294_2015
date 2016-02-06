## Lecture 5 Notes
# Tidy Data
#' tidyr package
#' 
#' A nice video: https://youtu.be/40tyOFMZUSM?t=11m6s
#' Vignette and data: https://github.com/hadley/tidyr/tree/master/vignettes
#' https://cran.r-project.org/web/packages/tidyr/vignettes/tidy-data.html
#' 2-page cheatsheet: http://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf
#' {I borrow heavily from above}

# PAGE references below: 
# bit.ly/wrangling-webinar

# Tidy Data Intro
# Page 14 - 28

require(tidyr)
require(dplyr)

# load adta
# WHO tuberculosis cases dataset
tb <- read.csv("data/tidyr/tb.csv", 
                 stringsAsFactors = FALSE) %>%
  tbl_df()
tb
# page 6 on tbl_df()

# can you figure out the meaning of these variables?
{#' iso2 is country
#' m/f refers to sex
#' numbers in variable columns refer to age ranges
#' e.g. m04 is men aged 0-1. e.g. f1524 are females 15-24
#' numbers are counts of tb cases in this country, in this demographic. 
}

# How is this data not tidy?
{
#' "m04" represents two variables, sex and age range. 
#' this data has five variables: 
#' - country, year, sex, and age and number of cases. 
#' - two vars are columns (1:2)
#' - two are intertwined over many column-names
}



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
## gather
# page 30 - 53
?gather
# gather(data, 
#            key, 
#            value, 
#            ..., 
#            na.rm = FALSE, 
#            convert = FALSE,
#            factor_key = FALSE
#            )


tb2 <- tb %>%
  gather(demo, n, 
         ... = -iso2, -year, 
         na.rm = T) %>%
  arrange(iso2, year)
# name key "demo", demographic
# name value "n", count
# na.rm = T, removes all missing values. Note, that can be a serious issue in practice
# ... "-is02, year" says "gather all but iso2 and year"
# tricky syntax, but fast and powerful result. 

# New issue?
{
# sex and age range are still muddled
  }

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
## separate
# page 75
?separate
#' separate(data, col, into, sep = "[^[:alnum:]]+", remove = TRUE,
#'          convert = FALSE, extra = "warn", fill = "warn", ...)

tb3 <- tb2 %>%
  separate(
    demo, #column to separate
    c("sex", "age_range"), #name of new column(s)
    1 # read "sep" argument, if numeric: index position to split at.
  )
tb3

# general tidying to make easier to read
tb3 <- tb3 %>%
  rename(country = iso2) %>%
  arrange(country, year, sex, age_range)
tb3

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# spread() - basically compliment/opposite of gather
# page 54 - 73
?spread

df <- data.frame(
  year     = rep(2005:2015, 2) ,
  treatment = c(rep("treatment_1", 11), rep("treatment_2", 11)),              # another vector recycling example
  value    = c(
    rnorm(n = 11, mean = 5, sd = 1),
    rnorm(n = 11, mean = 10, sd = 1))
) %>%
  tbl_df() %>%
  arrange(year, treatment)
df

df <- df %>% 
  spread(
    key = treatment,
    value = value
  )
df

#undo:

df %>% gather(
  key = treatment,      # Names of key columns to create in output.
  value = value,        # Names of value columns to create in output.
  ... = -year           # "all but year" - Specification of columns to gather.
) %>% 
  arrange(year, treatment)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# unite() basically opposite of separate
# page 76
?unite

tb3

tb3 %>%
  unite(
    col = demo, 
    ... = sex, age_range,
    sep = ""
  )

tb3 %>%
  unite(
    col = demo, 
    ... = sex, age_range,
    sep = "---"
  )

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Recap
# page 77
#' This lecture designed so that this cheatsheet is now easy to grasp: 
#' http://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#' Good style, %>%
#' the power of the pipe

tb <- read.csv("data/tidyr/tb.csv", 
               stringsAsFactors = FALSE) %>%
  tbl_df() %>%
  gather(demo, n, -iso2, -year, na.rm = T) %>%
  separate(demo, c("sex", "age"), 1) %>%
  rename(country = iso2) %>%
  arrange(country, year, sex, age)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

