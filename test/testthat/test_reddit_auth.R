# Load testthat framework
if (!require(testthat)) install.packages("testthat", dependencies = TRUE)
library(testthat)
library(httr)

# Load authentication script
source(file.path(getwd(), "R", "reddit_auth.R"))
# Define Reddit API credentials
client_id <- Sys.getenv("CLIENT_ID")
client_secret <- Sys.getenv("CLIENT_SECRET")
username <- Sys.getenv("REDDIT_USERNAME")
password <- Sys.getenv("REDDIT_PASSWORD")
print(paste("DEBUG: CLIENT_ID =", Sys.getenv("CLIENT_ID")))
print(paste("DEBUG: REDDIT_USERNAME =", Sys.getenv("REDDIT_USERNAME")))


test_that("Reddit authentication works correctly", {
  
  # Authenticate and get access token
  token <- reddit_auth(client_id, client_secret, username, password)
  token <- as.character(token)  # Ensure it's a character string

  # Assertions for authentication success
  expect_type(token, "character")  # Ensure access_token is a string
  expect_true(nchar(token) > 0)  # Ensure access_token is not empty
  
  print(paste("Access Token:", token))
})
