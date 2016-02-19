# Lecture 07 Notes ----
# ggplot2

# Setup -------------------------------
# install.packages("ggplot2")
library(ggplot2)
# ggplot2 has the diamonds and mpg dataframes we'll be working with. 
# ggplot2.org for docs

# Motivation - Grammar of Graphics is Awesome ------------------------------
#' Consise, consistent language for mapping data to visuals
#' leads to ggvis (interactive plots) and other languages (python etc.)


# Simple Example ---------------------------------------------------------------
#' How to make a plot?

df <- data.frame(
  length = c(2,1,4,9),
  width  = c(3,2,5,10),
  depth  = c(4,1,15,80),
  trt    = c("a","a","b","b")
)
df


# Scaterplot =================================================================
#' We want a scatter plot, length vs width
#' What is a scatterplot?
{
  #' geom   - Geometric Representation - represent observations with points
  #' scales - x and y axes
  #' colors - for treatment
  #' Cartesian coordinate system
}

# Mapping =================================================================
#' map our data to something our plotter can use
df

# step one - new column names
data.frame(
  x = c(2,1,4,9),
  y = c(3,2,5,10),
  color = c("a","a","b","b")
)

# step two - scales that fit the plot area
data.frame(
  x = c(25,0,75,200),
  y = c(11,0,53,300),
  color = c("red","red","blue","blue")
)

# What's with this mapping?
# http://ggplot2.org/resources/2007-vanderbilt.pdf#page=17
# The plot space has it's own coordinate system. 
# geoms  - mapping of input data to visual 
# guides - visual tools to understand scales
# plot   - plot frame

# Bring it all together: 
# http://ggplot2.org/resources/2007-vanderbilt.pdf#page=18

#' So what makes a plot? 
#' Data
#' geommetric object (geom)
#' statistical transformation (stat)
#' scales
#' coordinate system
#' + position adjustment, facetting, 
#' + labeling, themes, further adjustments

# examples ====================

p <- ggplot(
  data = mpg,
  aes(x = hwy)
) + 
  geom_histogram()
p
# geom: bar
# stat: bin
# scales: linear
# coordinate system: Cartesian


p <- ggplot(
  data = mpg, 
  aes(x = displ, 
      y = hwy)
)
p <- p + geom_point(aes(color = class))
p
# geom: point
# stat: identity
# scales: linear
# coordinate system: Cartesian

# Plot Definition ====================================
#' a plot is: Layer + scales + coordinate system

# Layers ====================================
# Layer:
# - data
# - mapping
# - geom
# - stat
# - position

# p$.... check it out
p

# You can fully specify the layer
# or use helpper functions. geom_...
ggplot(data = mpg,
       aes(x = displ, y = hwy)) +
  layer(
    geom = "point", 
    stat = "identity", 
    position = "identity",
    params = list(na.rm = FALSE)
  )

# geom shortcuts set defaults!
ggplot(data = mpg,
       aes(x = displ, y = hwy)) +
  geom_point()

# geoms: 
# every geom has a default statistics
# and every statistics has a default geom
# and you can adjust these 

# there are a lot of geoms set up: 
# http://docs.ggplot2.org/current/
  
# examples, continued ====================
d <- ggplot(diamonds,
            aes(x=carat, y=price))
d + geom_point()
d + geom_point(aes(colour = clarity))
d + geom_point(aes(colour = carat))
+ scale_colour_brewer()

ggplot(diamonds) +
  geom_histogram(aes(x=price))
  

#' Note that Data plus Mapping are usually the same on plots
#' 'd' in this case is data + mapping. 
#' and we then explore over different views
#' aes defines relationships, not data. 

# Factors ######################################################################

ggplot(diamonds,
       aes(x=cut, y=price)) +
  geom_boxplot()
# note the order in which the different cuts appear
# it matches cut's factor levels
levels(diamonds$cut)


{
  #reverse those levels: 
  levels(diamonds$cut) <- rev(levels(diamonds$cut))
  ggplot(diamonds,
         aes(x=cut, y=price)) +
  geom_boxplot()
  
  levels(diamonds$cut) <- rev(levels(diamonds$cut))
}


# Geoms ########################################################################
#' geommetric shape of the elements of the plot
#'   (summarized nicely by simple visuals)
#' e.g. 
#' basic: point, line, line segments, polygon, bar, text, 
#' composites: boxplot, pointrange 
#' statistic: histogram, smooth, density

# Statistics ########################################################################
# The values represented in the plot are the product of various statistics. 
# for example: 
# - point: identity statistic
# - bar: mean, or median statistic
# - histogram: binned count, or density statistic

# Variations of a histogram: 
p <- ggplot(diamonds, aes(x=price))
p + geom_histogram()
p + stat_bin(geom="area")
p + stat_bin(geom="point")
p + stat_bin(geom="line")
p + geom_histogram(aes(fill = clarity))
p + geom_histogram(aes(y = ..density..))

# Some stats create new variables that you can then refer to in the geom
# http://docs.ggplot2.org/current/geom_histogram.html
# see "Computed variables"
# - count, density, ncount, ndensity

p <- ggplot(diamonds, aes(x=price))
p + geom_histogram()
p + geom_histogram(aes(fill = ..count..))
p + geom_histogram(aes(y = ..density..))  #i love this one
p + geom_histogram(aes(y = ..ncount..))
p + geom_histogram(aes(y = ..ndensity..))

# Parameters #######################
# Parameters modify appearance of geoms and operation of statistics
# + geom_smooth(method=lm)     add line from linear model
ggplot(mpg, aes(x=displ, y=hwy)) + geom_point() + stat_smooth(method = lm)
ggplot(mpg, aes(x=displ, y=hwy)) + geom_point() + stat_smooth(method = loess)

# + stat_bin(binwidth = 100)    adjust binwidth
ggplot(diamonds, aes(x=price)) + stat_bin(binwidth = 100)
# + stat_summary(fun="mean_cl_boot")     see docs, Mean Standard error from bootstrap
# + geom_boxplot(outlier.colour = "red")    

# each geom and stat may have a variety of params, see docs

# ASTHETICS AS PARAMS
# Any aesthetic can also be used as a parameter
# + geom_point(colour = "red", size = 5)
# + geom_line(linetype = 3)
p + stat_bin(colour = "red")
p + stat_bin(colour = "red", fill = "blue")
p + stat_bin(alpha = 0.5) #alpha refers to transparency

# Setting vs Mapping ###########################################################
# Tricky to get this right, play around, see docs
p <- ggplot(diamonds, aes(x=carat,y=price))
p + geom_point()

# what will each do?
p + geom_point(aes(colour = "green"))  # basically a new variable... all green
p + geom_point(colour = "green")       # make all points here, green
p + geom_point(colour = colour)        # oops


# Points and Lines ==================
p + geom_point()

# add a line: 
ggplot(mpg, aes(displ, hwy))+
  geom_point() +
  geom_line()
# what's going on?
View(mpg)

# vary scatter points color
ggplot(mpg, aes(displ, hwy))+
  geom_point(aes(color = factor(cyl)))+
  geom_line()

# vary lines by color
ggplot(mpg, aes(displ, hwy))+
  geom_point()+
  geom_line(aes(color = factor(cyl)))

# vary all colors 
ggplot(mpg, aes(displ, hwy, color = factor(cyl)))+
  geom_point()+
  geom_line()

# Categorical Variables and Bars and Boxplots 

table(mpg$class) #car types

ggplot(mpg, aes(class, hwy)) +
  stat_summary(fun.y = mean, geom = "bar")


ggplot(mpg, aes(class, hwy)) +
  geom_boxplot()

# Quickly view http://docs.ggplot2.org/current/
# so many examples!

# Time Series Example ---------------------------------------------------------
library(foreign)
org_example <- read.dta("data/org_example.dta")

ggplot(
  sample_n(org_example, 50000), 
  aes(
    x = age, 
    y = rw,
    colour = educ
  )
) + 
  geom_point(alpha = 0.2)



# working with Dates =========

library(dplyr)
org_example <- org_example %>% 
  mutate(
    date = paste(year, month, "01", sep = "-"),
    date = as.Date(date, format = "%Y-%m-%d")
  ) %>%
  filter(!is.na(rw)) %>%
  tbl_df()




p <- ggplot(
  data = org_example,
  aes(
    x = date, 
    y = rw
  )
) 

p + geom_point()

p + geom_boxplot(
  aes(x = as.factor(date))
)

p + stat_smooth()

p + stat_smooth(
  aes(colour = educ)
)


p + stat_smooth(
  aes(colour = as.factor(female))
)


ggplot(
  data = (
    org_example %>%
      mutate(
        sex = as.factor(ifelse(female, "Female", "Male"))
      )
  ),
  aes(
    x = date, 
    y = rw,
    group =  interaction(sex, educ),
    colour = interaction(sex, educ)
  )
) +
  stat_smooth(span = 3)

# Time Series Scales =========================================================
library(scales)

ggplot(
  data = (
    org_example %>%
      mutate(
        sex = as.factor(ifelse(female, "Female", "Male"))
      )
  ),
  aes(
    x = date, 
    y = rw,
    group = interaction(educ, sex),
    colour = interaction(educ, sex)
  )
) +
  stat_smooth(span = 3) 


+
  scale_x_date(labels = date_format("%b-%Y"), 
               breaks = "6 month", 
               minor_breaks = "1 month")
