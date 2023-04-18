## Run once
#install.packages("plumber")
#install.packages("xgboost")

#Save this file as "xgboost_api.R"
library(plumber)
library(xgboost)

# Load or create your XGBoost model
# In this example, we'll use the built-in 'mtcars' dataset to predict 'mpg' (miles per gallon)
data(mtcars)

# Prepare the data
train_data <- mtcars[, -1]  # Exclude 'mpg' from the input features
train_labels <- mtcars$mpg

# Train the XGBoost model
xgb_data <- xgb.DMatrix(data = as.matrix(train_data), label = train_labels)
params <- list(objective = "reg:linear", nrounds = 50)
xgb_model <- xgb.train(params, xgb_data)

# Plumber API definition
#* @apiTitle XGBoost API

#* @param data: A JSON array of input features (as a list)
#* @post /predict
function(req, res, data) {
  # Decode the input data from JSON
  input_data <- jsonlite::fromJSON(data)
  
  # Convert the data to a matrix
  input_matrix <- as.matrix(data.frame(input_data))
  
  # Make predictions using the XGBoost model
  xgb_input <- xgb.DMatrix(data = input_matrix)
  predictions <- predict(xgb_model, xgb_input)
  
  # Return the predictions as JSON
  return(list(predictions = predictions))
}
