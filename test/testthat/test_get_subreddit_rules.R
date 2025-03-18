# Load testthat framework
if (!require(testthat)) install.packages("testthat", dependencies = TRUE)
library(testthat)
library(httr)

# Load authentication and subreddit rules retrieval scripts
source("C:/Users/zefen/Desktop/MDS/534/Reddit_API/R/reddit_auth.R")
source("C:/Users/zefen/Desktop/MDS/534/Reddit_API/R/get_subreddit_rules.R")
source(file.path(getwd(), "R", "reddit_auth.R"))
source(file.path(getwd(), "R", "get_subreddit_posts.R"))


# Define Reddit API credentials
client_id <- Sys.getenv("CLIENT_ID")
client_secret <- Sys.getenv("CLIENT_SECRET")
username <- Sys.getenv("REDDIT_USERNAME")
password <- Sys.getenv("REDDIT_PASSWORD")
print(paste("DEBUG: CLIENT_ID =", Sys.getenv("CLIENT_ID")))
print(paste("DEBUG: REDDIT_USERNAME =", Sys.getenv("REDDIT_USERNAME")))


test_that("get_subreddit_rules() should return valid rules for a subreddit", {
  
  # 1️⃣ Authenticate and obtain access token
  access_token <- reddit_auth(client_id, client_secret, username, password)
  access_token <- as.character(access_token)  # Ensure it's a character string
  
  # Assertions for authentication success
  expect_type(access_token, "character")  # Ensure access_token is a string
  expect_true(nchar(access_token) > 0)  # Ensure access_token is not empty
  
  print(paste("Access Token:", access_token))

  # 2️⃣ Retrieve subreddit rules
  subreddit_name <- "kelowna"  
  rules <- get_subreddit_rules(subreddit_name, access_token)

  # Assertions for subreddit rules retrieval
  expect_true(is.data.frame(rules))  # Ensure the output is a data frame

  if (nrow(rules) > 0) {
    # Ensure the dataframe is not empty if the subreddit has rules
    expect_true(nrow(rules) > 0)

    # Check column names
    expected_columns <- c("Title", "Description", "Priority", "Violation_Reason")
    expect_true(all(expected_columns %in% colnames(rules)))  # Ensure all expected columns exist

    # Check data types
    expect_type(rules$Title, "character")
    expect_type(rules$Description, "character")
    expect_type(rules$Priority, "integer")
    expect_type(rules$Violation_Reason, "character")
  }

  # 3️⃣ Debugging output
  print("Test completed successfully. Subreddit rules:")
  print(rules)
})
