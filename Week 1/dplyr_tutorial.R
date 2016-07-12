library(nycflights13)
library(ggplot2)
#check the dimensions
dim(flights)

# filter() allows you to select a subset of rows in a data frame. The first
# argument is the name of the data frame. The second and subsequent arguments
# are the expressions that filter the data frame

#filter all January 1 flights
jan_flights <- filter(flights, month==1, day==1)

#filter with or
jan_feb_flights <- filter(flights, month==1 | month == 2)

#select rows by position
first_10 <- slice(flights, 1:10)


# arrange() works similarly to filter() except that instead of filtering or
# selecting rows, it reorders them. It takes a data frame, and a set of column
# names (or more complicated expressions) to order by. If you provide more than
# one column name, each additional column will be used to break ties in the
# values of preceding columns

# arrange a column in descending order.  Order by flight delay
most_delayed <- arrange(flights, desc(arr_delay))

# Order by flight delay, airline
most_delayed_and_airline <- arrange(flights, desc(arr_delay), carrier)



#Often you work with large datasets with many columns but only a few are
#actually of interest to you. select() allows you to rapidly zoom in on a useful
#subset using operations that usually only work on numeric variable positions

# select columns by name
sub_flights <- select(flights, year, month, day)

# select a range of columns inclusive from year and day
select(flights, year:day)

# select all columns, minus year to day
select(flights, -(year:day))

#rename a variable in a table
flights <- rename(flights, tail_num=tailnum)

# extract unique rows
distinct(flights, tailnum)

#extract unique carriers
distinct(flights, carrier)

# extract unique origina and destination
distinct(flights, origin, dest)



#Besides selecting sets of existing columns, it’s often useful to add new
#columns that are functions of existing columns. This is the job of mutate()
#mutate also allows you to select newsly created columns.  You cannot do that with 
#transform.

mutate(flights, gain=arr_delay - dep_delay, speed = distance/air_time*60)

#only want a table with new variables, use transmute
transmute(flights, gain=arr_delay - dep_delay, speed = distance/air_time*60)



# The last verb is summarise(). It collapses a data frame to a single row (this
# is exactly equivalent to plyr::summarise()):

summarise(flights, delay=mean(dep_delay, na.rm=TRUE))

#randomly sample rows
sample_n(flights, 10)

#sample with fixed fractions
sample_frac(flights, 0.01)



#These verbs are useful on their own, but they become really powerful when you
#apply them to groups of observations within a dataset. In dplyr, you do this by
#with the group_by() function. It breaks down a dataset into specified groups of
#rows. When you then apply the verbs above on the resulting object they’ll be
#automatically applied “by group”. Most importantly, all this is achieved by
#using the same exact syntax you’d use with an ungrouped object.

# In the following example, we split the complete dataset into individual planes
# and then summarise each plane by counting the number of flights (count = n())
# and computing the average distance (dist = mean(Distance, na.rm = TRUE)) and
# arrival delay (delay = mean(ArrDelay, na.rm = TRUE)). We then use ggplot2 to
# display the output.
by_tailnum <- group_by(flights, tailnum)
delay <- summarise(by_tailnum, 
                   count = n(),
                   dist = mean(distance, na.rm=TRUE),
                   delay = mean(arr_delay, na.rm=TRUE))

delay <- filter(delay, count > 20, dist < 2000)

ggplot(delay, aes(dist, delay)) +
  geom_point(aes(size = count), alpha = 1/2) +
  geom_smooth() +
  scale_size_area()


# You use summarise() with aggregate functions, which take a vector of values
# and return a single number. There are many useful examples of such functions
# in base R like min(), max(), mean(), sum(), sd(), median(), and IQR(). dplyr
# provides a handful of others

#For example, we could use these to find the number of planes and the number of
#flights that go to each possible destination

destination <- group_by(flights, dest)
summarise(destination,
          planes = n_distinct(tailnum),
          flights=n())