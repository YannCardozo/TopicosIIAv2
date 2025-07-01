# plumber.R
# API REST for NUMDEFECTS prediction

#' @apiTitle NUMDEFECTS Prediction API
#' @apiDescription Returns predicted number of defects for a given class.

library(jsonlite)

# Load pre‑trained regression model
model <- readRDS("defect_model.rds")
required_vars <- names(model$coefficients)[-1]  # predictors

#' Health‑check endpoint
#' @get /ping
function() {
  list(status = "ok", time = Sys.time())
}

#' Predict NUMDEFECTS
#' @param body:json A JSON object containing numeric values for each predictor variable.
#' @post /predict
function(req, res){
  # Parse JSON body
  newdata <- tryCatch({
    as.data.frame(jsonlite::fromJSON(req$postBody))
  }, error = function(e){
    res$status <- 400
    return(list(error = "Invalid JSON."))
  })

  # Check required variables
  missing <- setdiff(required_vars, names(newdata))
  if (length(missing) > 0){
    res$status <- 400
    return(list(error = paste("Missing variables:", paste(missing, collapse = ", "))))
  }

  # Prediction
  pred <- predict(model, newdata = newdata)
  list(prediction = pred)
}
