# Load testthat framework
if (!require(testthat)) install.packages("testthat", dependencies = TRUE)
library(testthat)
library(httr)

# Load authentication and user info retrieval scripts
source("C:/Users/zefen/Desktop/MDS/534/Reddit_API/R/reddit_auth.R")
source("C:/Users/zefen/Desktop/MDS/534/Reddit_API/R/get_user_info.R")

# Define Reddit API credentials
client_id <- "PeAknuUXpERmde8cC-sSEQ"
client_secret <- "3uy3ngtkPB0vlnCogMpeemmnaMEqaA"
username <- "Fantastic_Snow_7640"
password <- "bay_reddit"

test_that("get_user_info() should return valid user details", {
  
  # 1️⃣ Authenticate and obtain access token
  access_token <- reddit_auth(client_id, client_secret, username, password)
  access_token <- as.character(access_token)  # Ensure it's a character string
  
  # Assertions for authentication success
  expect_type(access_token, "character")  # Ensure access_token is a string
  expect_true(nchar(access_token) > 0)  # Ensure access_token is not empty
  
  print(paste("Access Token:", access_token))

  # 2️⃣ Retrieve user information
  reddit_username <- "example_user"  # Change this to a real Reddit username for testing
  user_info <- get_user_info(reddit_username, access_token)

  # Assertions for user info retrieval
  expect_true(is.data.frame(user_info))  # Ensure the output is a data frame
  expect_true(nrow(user_info) > 0)  # Ensure the data frame is not empty
  
  # Check column names
  expected_columns <- c(
    "Username", "Link_Karma", "Comment_Karma", "Created_At",
    "Is_Mod", "Is_Gold", "Verified"
  )
  expect_true(all(expected_columns %in% colnames(user_info)))  # Ensure all expected columns exist

  # Check data types
  expect_type(user_info$Username, "character")
  expect_type(user_info$Link_Karma, "integer")
  expect_type(user_info$Comment_Karma, "integer")
  expect_s3_class(user_info$Created_At, "POSIXct")  # Ensure Created_At is a timestamp
  expect_type(user_info$Is_Mod, "logical")
  expect_type(user_info$Is_Gold, "logical")
  expect_type(user_info$Verified, "logical")

  # 3️⃣ Debugging output
  print("Test completed successfully. User information:")
  print(user_info)
})
