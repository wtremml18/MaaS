## This is the server code
library(plumber)
r <- plumb("xgboost_api.R")
r$run(port = 8080)