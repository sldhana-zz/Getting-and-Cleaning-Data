# Tidy data is a standard way of mapping the meaning of a dataset to its
# structure. A dataset is messy or tidy depending on how rows, columns and
# tables are matched up with observations, variables and types. In tidy data:
# 
# Each variable forms a column.
# Each observation forms a row.
# Each type of observational unit forms a table.

# Real datasets can, and often do, violate the three precepts of tidy data in
# almost every way imaginable. While occasionally you do get a dataset that you
# can start analysing immediately, this is the exception, not the rule. This
# section describes the five most common problems with messy datasets, along
# with their remedies:
# 
# Column headers are values, not variable names.
# Multiple variables are stored in one column.
# Variables are stored in both rows and columns.
# Multiple types of observational units are stored in the same table.
# A single observational unit is stored in multiple tables.

pew <- tbl_df(read.csv("/home/sldhana/Learning/Getting-and-Cleaning-Data/Week 1/pew.csv", stringsAsFactors = FALSE, check.names = FALSE))

# This dataset has three variables, religion, income and frequency. To tidy it,
# we need to gather the non-variable columns into a two-column key-value pair.
# This action is often described as making a wide dataset long (or tall), but
# I’ll avoid those terms because they’re imprecise.

# When gathering variables, we need to provide the name of the new key-value
# columns to create. The first argument, is the name of the key column, which is
# the name of the variable defined by the values of the column headings. In this
# case, it’s income. The second argument is the name of the value column,
# frequency. The third argument defines the columns to gather, here, every
# column except religion.
updated <- pew %>%
  gather(income, frequency, -religion)



billboard <- tbl_df(read.csv("/home/sldhana/Learning/Getting-and-Cleaning-Data/Week 1/billboard.csv", stringsAsFactors = FALSE))
# To tidy this dataset, we first gather together all the wk columns. The column
# names give the week and the values are the ranks

# Here we use na.rm to drop any missing values from the gather columns. In this
# data, missing values represent weeks that the song wasn’t in the charts, so
# can be safely dropped.
billboard2 <- gather(billboard, week, rank, wk1:wk76, na.rm=TRUE)

# In this case it’s also nice to do a little cleaning, converting the week
# variable to a number, and figuring out the date corresponding to each week on
# the charts

billboard3 <- billboard2 %>%
  mutate(
  week= extract_numeric(week),
  date= as.Date(date.entered) + 7 * (week - 1)) %>%
  select(-date.entered)

# Finally, it’s always a good idea to sort the data. We could do it by artist,
# track and week
billboard3 %>% arrange(artist, track, week)


# After gathering columns, the key column is sometimes a combination of multiple
# underlying variable names. This happens in the tb (tuberculosis) dataset,
# shown below. This dataset comes from the World Health Organisation, and
# records the counts of confirmed tuberculosis cases by country, year, and
# demographic group. The demographic groups are broken down by sex (m, f) and
# age (0-14, 15-25, 25-34, 35-44, 45-54, 55-64, unknown).
tb <- tbl_df(read.csv("/home/sldhana/Learning/Getting-and-Cleaning-Data/Week 1/tb.csv", stringsAsFactors = FALSE))

#First we gather up the non-variable columns:
tb2 <- tb %>%
  gather(demo, n, -iso2, -year, na.rm=TRUE)

#Column headers in this format are often separated by a non-alphanumeric
#character (e.g. ., -, _, :), or have a fixed width format, like in this
#dataset. separate() makes it easy to split a compound variables into individual
#variables. You can either pass it a regular expression to split on (the default
#is to split on non-alphanumeric columns), or a vector of character positions.
#In this case we want to split after the first character
tb3 <- tb2 %>%
    separate(demo, c("sex", "age"), 1)


#The most complicated form of messy data occurs when variables are stored in
#both rows and columns. The code below loads daily weather data from the Global
#Historical Climatology Network for one weather station (MX17004) in Mexico for
#five months in 2010.
weather <- tbl_df(read.csv("/home/sldhana/Learning/Getting-and-Cleaning-Data/Week 1/weather.csv", stringsAsFactors = FALSE))

# It has variables in individual columns (id, year, month), spread across
# columns (day, d1-d31) and across rows (tmin, tmax) (minimum and maximum
# temperature). Months with fewer than 31 days have structural missing values
# for the last day(s) of the month.
# 
# To tidy this dataset we first gather the day columns:

weather2 <- weather %>%
  gather(day, value, d1:d31, na.rm=TRUE)

weather3 <- weather2 %>%
  mutate(day=extract_numeric(day)) %>%
  select(id, year, month, day, element, value) %>%
  arrange(id, year, month, day)

# This dataset is mostly tidy, but the element column is not a variable; it
# stores the names of variables. (Not shown in this example are the other
# meteorological variables prcp (precipitation) and snow (snowfall)). Fixing
# this requires the spread operation. This performs the inverse of gathering by
# spreading the element and value columns back out into the columns
weather3 <- weather3 %>% spread(element, value)
