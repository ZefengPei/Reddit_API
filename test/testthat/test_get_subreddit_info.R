# Load testthat framework
if (!require(testthat)) install.packages("testthat", dependencies = TRUE)
library(testthat)
library(httr)

# Load authentication and subreddit info retrieval scripts
source("C:/Users/zefen/Desktop/MDS/534/Reddit_API/R/reddit_auth.R")
source("C:/Users/zefen/Desktop/MDS/534/Reddit_API/R/get_subreddit_info.R")

# Define Reddit API credentials
client_id <- "PeAknuUXpERmde8cC-sSEQ"
client_secret <- "3uy3ngtkPB0vlnCogMpeemmnaMEqaA"
username <- "Fantastic_Snow_7640"
password <- "bay_reddit"

test_that("get_subreddit_info() should return valid subreddit details", {
  
  # 1️⃣ Authenticate and obtain access token
  access_token <- reddit_auth(client_id, client_secret, username, password)
  access_token <- as.character(access_token)  # Ensure it's a character string
  
  # Assertions for authentication success
  expect_type(access_token, "character")  # Ensure access_token is a string
  expect_true(nchar(access_token) > 0)  # Ensure access_token is not empty
  
  print(paste("Access Token:", access_token))

  # 2️⃣ Retrieve subreddit information
  subreddit_name <- "programming"  # Change to any subreddit of interest
  subreddit_info <- get_subreddit_info(subreddit_name, access_token)

  # Assertions for subreddit info retrieval
  expect_true(is.data.frame(subreddit_info))  # Ensure the output is a data frame
  expect_true(nrow(subreddit_info) > 0)  # Ensure the data frame is not empty
  
  # Check column names
  expected_columns <- c(
    "title", "description", "subscribers", "active_users",
    "created_utc", "over18", "community_type", "language",
    "icon_img", "banner_img", "primary_color", "allow_images",
    "allow_videos", "is_default", "quarantine", "submission_type",
    "wiki_enabled"
  )
  expect_true(all(expected_columns %in% colnames(subreddit_info)))  # Ensure all expected columns exist

  # Check data types
  expect_type(subreddit_info$title, "character")
  expect_type(subreddit_info$description, "character")
  expect_type(subreddit_info$subscribers, "integer")
  expect_type(subreddit_info$active_users, "integer")
  expect_s3_class(subreddit_info$created_utc, "POSIXct")  # Ensure created_utc is a timestamp
  expect_type(subreddit_info$over18, "logical")
  expect_type(subreddit_info$community_type, "character")
  expect_type(subreddit_info$language, "character")
  expect_type(subreddit_info$icon_img, "character")
  expect_type(subreddit_info$banner_img, "character")
  expect_type(subreddit_info$primary_color, "character")
  expect_type(subreddit_info$allow_images, "logical")
  expect_type(subreddit_info$allow_videos, "logical")
  expect_type(subreddit_info$is_default, "logical")
  expect_type(subreddit_info$quarantine, "logical")
  expect_type(subreddit_info$submission_type, "character")
  expect_type(subreddit_info$wiki_enabled, "logical")

  # 3️⃣ Debugging output
  print("Test completed successfully. Subreddit information:")
  print(subreddit_info)
})
