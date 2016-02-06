library(dplyr)

df <- read.delim("C:/Users/OKComputer/Downloads/Data.tex")
# data, see data.tex from Ciril

# From Ciril:
#' Let me explain;
#' I am trying to bootstrap some data. In short bootstrapping means just picking 
#' random samples of the available data. The thing is that I need to cluster my 
#' data because it is composed by several observations of the same subjects under 
#' different treatments (So say subject 1 is observed in treatment 1, 3, 5, and 6, 
#' subject 2 is observed in treatments 2,3,5 and 6 etc.). What I had done until 
#' now was a simple bootstrapping technique which works for individual 
#' observations:
#' 
#' 
#' 1) Creating a random index: index = sample(1:N, N, replace = TRUE))
#' which picks N values between 1:N. With N being the total number of 
#' observations I have.
#' 
#' 2) Then using the index created by the above command pick the observations: 
#' newdata=data[index,]. This was my bootstrapping technique for each iteration 
#' of the loop.
#' 
#' What I need to do now is to pick my random data by "clusters" 
#' (i.e., by subject) instead of individual entries, but for the love of God 
#' that I am not able to do so. I have tried several methods, but I don't seem 
#' able to build the one or two lines of instructions necessary to do this :( 
#' could you help a brother out by giving me some pointers? I am very naive with 
#' R and struggle quite a bit even with restructuring my datasets 

str(data)
distinct(select(data,sender)) # 112 unique subjects

# hide: 
{
data.boots <- df %>%
  group_by(sender) %>%
  sample_n(2, replace = T) %>%
  ungroup() %>% #to make str() easier to read
  tbl_df() # still a data.frame, but nicer to work with

# with 112 subjects and n 500, I expect 500 * 112 = 56000 obs data frame
data.boots
str(data.boots)

}
# this is likely wrong. 


{

data.s <- split(df, df$sender) %>% 
  sample(112,replace = T) %>%
  bind_rows()
data.s

}

