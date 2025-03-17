# Load testthat framework
if (!require(testthat)) install.packages("testthat", dependencies = TRUE)
library(testthat)
library(httr)

# Load authentication and subreddit post retrieval scripts
source("C:/Users/zefen/Desktop/MDS/534/Reddit_API/R/reddit_auth.R")
source("C:/Users/zefen/Desktop/MDS/534/Reddit_API/R/get_subreddit_posts.R")

# Define Reddit API credentials
client_id <- "PeAknuUXpERmde8cC-sSEQ"
client_secret <- "3uy3ngtkPB0vlnCogMpeemmnaMEqaA"
username <- "Fantastic_Snow_7640"
password <- "bay_reddit"

test_that("Reddit authentication and subreddit post retrieval work correctly", {
  
  # 1️⃣ Test authentication and access token retrieval
  access_token <- reddit_auth(client_id, client_secret, username, password)
  access_token <- as.character(access_token)  # Ensure it's a character string

  # Assertions for authentication success
  expect_type(access_token, "character")  # Ensure access_token is a string
  expect_true(nchar(access_token) > 0)  # Ensure access_token is not empty
  
  print(paste("Access Token:", access_token))

  # 2️⃣ Test subreddit post retrieval
  subreddit_name <- "rstats"  # Change this to any subreddit of interest
  limit <- 5  # Number of posts to fetch

  posts <- get_subreddit_posts(subreddit_name, access_token, limit)

  # Assertions for subreddit post retrieval
  expect_true(is.data.frame(posts))  # Ensure the output is a data frame
  expect_true(nrow(posts) > 0)  # Ensure there are posts retrieved

  print("Fetched Posts:")
  print(posts)
})
