# Load testthat framework
if (!require(testthat)) install.packages("testthat", dependencies = TRUE)
library(testthat)
library(httr)

# Load authentication script
source("C:/Users/zefen/Desktop/MDS/534/Reddit_API/R/reddit_auth.R")

# Define Reddit API credentials (hardcoded for local testing)
client_id <- "PeAknuUXpERmde8cC-sSEQ"
client_secret <- "3uy3ngtkPB0vlnCogMpeemmnaMEqaA"
username <- "Fantastic_Snow_7640"
password <- "bay_reddit"


test_that("Reddit authentication works correctly", {
  
  # Authenticate and get access token
  token <- reddit_auth(client_id, client_secret, username, password)
  token <- as.character(token)  # Ensure it's a character string

  # Assertions for authentication success
  expect_type(token, "character")  # Ensure access_token is a string
  expect_true(nchar(token) > 0)  # Ensure access_token is not empty
  
  print(paste("Access Token:", token))
   succeed()
})
