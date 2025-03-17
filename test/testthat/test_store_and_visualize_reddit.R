# Load testthat framework
if (!require(testthat)) install.packages("testthat", dependencies = TRUE)
library(testthat)
library(httr)
library(tidyverse)

# Load Reddit API functions and the main function to test
source("C:/Users/zefen/Desktop/MDS/534/Reddit_API/R/reddit_auth.R")
source("C:/Users/zefen/Desktop/MDS/534/Reddit_API/R/get_subreddit_posts.R")
source("C:/Users/zefen/Desktop/MDS/534/Reddit_API/R/get_post_comments.R")
source("C:/Users/zefen/Desktop/MDS/534/Reddit_API/R/store_and_visualize_reddit.R")

# Use fixed Reddit API credentials for testing
client_id <- "PeAknuUXpERmde8cC-sSEQ"
client_secret <- "3uy3ngtkPB0vlnCogMpeemmnaMEqaA"
username <- "Fantastic_Snow_7640"
password <- "bay_reddit"

test_that("store_and_visualize_reddit() should correctly store and process data", {

  # 1️⃣ Authenticate and obtain an access token
  access_token <- reddit_auth(client_id, client_secret, username, password)
  access_token <- as.character(access_token)  # Ensure it's a string

  # Assertions for authentication success
  expect_type(access_token, "character")  # Ensure access_token is a string
  expect_true(nchar(access_token) > 0)  # Ensure access_token is not empty
  print(paste("Access Token:", substr(access_token, 1, 20), "..."))  # Print part of token for security

  # 2️⃣ Run the function with test parameters
  subreddit_name <- "programming"  # Change as needed
  limit <- 5  # Fetch 5 posts to make it faster

  store_and_visualize_reddit(subreddit_name, access_token, username, limit)

  # 3️⃣ Validate stored CSV files
  posts_file <- paste0("reddit_posts_", subreddit_name, ".csv")
  comments_file <- paste0("reddit_comments_", subreddit_name, ".csv")
  sentiment_file <- paste0("reddit_sentiment_", subreddit_name, ".csv")

  # Ensure the files exist
  expect_true(file.exists(posts_file))
  expect_true(file.exists(comments_file))
  expect_true(file.exists(sentiment_file))

  # 4️⃣ Validate data structure
  posts <- read_csv(posts_file)
  comments <- read_csv(comments_file)
  sentiment_scores <- read_csv(sentiment_file)

  expect_true(is.data.frame(posts))
  expect_true(is.data.frame(comments))
  expect_true(is.data.frame(sentiment_scores))

  # Ensure there is at least some data
  expect_true(nrow(posts) > 0)
  expect_true(nrow(comments) > 0)
  expect_true(nrow(sentiment_scores) > 0)

  # 5️⃣ Validate column names
  expect_true(all(c("id", "Title", "Author", "Subreddit", "Upvotes", "Comments", "URL", "Created") %in% colnames(posts)))
  expect_true(all(c("Author", "Comment", "Upvotes", "Replies", "post_id") %in% colnames(comments)))
  expect_true(all(c("Author", "Sentiment_Score") %in% colnames(sentiment_scores)))

  # 6️⃣ Validate sentiment scores are numeric
  expect_type(sentiment_scores$Sentiment_Score, "double")

  # 7️⃣ Validate PNG files for visualization
  posts_image <- paste0("reddit_top_posts_", subreddit_name, ".png")
  sentiment_image <- paste0("reddit_top_sentiment_", subreddit_name, ".png")

  expect_true(file.exists(posts_image))
  expect_true(file.exists(sentiment_image))

  print("✅ Test completed successfully. Data stored, processed, and visualized correctly.")

})
