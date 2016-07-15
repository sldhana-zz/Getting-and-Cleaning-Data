# Register an application with the Github API here
# https://github.com/settings/applications. Access the API to get information on
# your instructors repositories (hint: this is the url you want
# "https://api.github.com/users/jtleek/repos"). Use this data to find the time
# that the datasharing repo was created. What time was it created?
# 
# This tutorial may be useful
# (https://github.com/hadley/httr/blob/master/demo/oauth2-github.r). You may
# also need to run the code in the base R package and not R studio.

setwd('/home/sldhana/Learning/Getting-and-Cleaning-Data/Week 2/')
library(httr)
library(jsonlite)

# 1. Find OAuth settings for github:
#    http://developer.github.com/v3/oauth/
#oauth_endpoints("github")

# 2. To make your own application, register at at
#    https://github.com/settings/applications. Use any URL for the homepage URL
#    (http://github.com is fine) and  http://localhost:1410 as the callback url
#
#    Replace your key and secret below.
CleaningData <- oauth_app("github",
                   key = "d51c1a07835ca948c4ba",
                   secret = "ebad2551e6caa527d1d8f87d3a9efcee8e20e141")

# 3. Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), CleaningData)

# 4. Use API
gtoken <- config(token = github_token)
json_df <- fromJSON("https://api.github.com/users/jtleek/repos", simplifyDataFrame=TRUE)
data_sharing_row <- subset(json_df, name=='datasharing')
data_sharing_row$created_at #2013-11-07T13:25:07Z
