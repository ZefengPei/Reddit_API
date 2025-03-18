# Load testthat framework
if (!require(testthat)) install.packages("testthat", dependencies = TRUE)
library(testthat)
library(httr)
library(tidyverse)

# Load Reddit API and Sentiment Analysis function
source("C:/Users/zefen/Desktop/MDS/534/Reddit_API/R/reddit_auth.R")
source("C:/Users/zefen/Desktop/MDS/534/Reddit_API/R/get_subreddit_posts.R")
source("C:/Users/zefen/Desktop/MDS/534/Reddit_API/R/get_post_comments.R")
source("C:/Users/zefen/Desktop/MDS/534/Reddit_API/R/analyze_reddit_comments.R")

# Use fixed Reddit API credentials for testing
client_id <- "PeAknuUXpERmde8cC-sSEQ"
client_secret <- "3uy3ngtkPB0vlnCogMpeemmnaMEqaA"
username <- "Fantastic_Snow_7640"
password <- "bay_reddit"


test_that("analyze_reddit_comments() works correctly", {

  # 1️⃣ Authenticate and obtain an access token
  access_token <- reddit_auth(client_id, client_secret, username, password)
  access_token <- as.character(access_token)  # Ensure it's a character string

  # Assertions for authentication success
  expect_type(access_token, "character")  # Ensure access_token is a string
  expect_true(nchar(access_token) > 0)  # Ensure access_token is not empty
  print(paste("Access Token:", substr(access_token, 1, 20), "..."))  # Print part of token for security

  # 2️⃣ Fetch posts from a subreddit
  subreddit_name <- "programming"  # Change as needed
  limit <- 10  # Fetch 10 posts to increase chances of finding comments

  posts <- get_subreddit_posts(subreddit_name, access_token, limit)

  # Assertions for successful post retrieval
  expect_true(is.data.frame(posts))
  expect_true(nrow(posts) > 0)  # Ensure subreddit has posts
  posts_with_comments <- posts %>% filter(Comments > 0)

  if (nrow(posts_with_comments) == 0) {
    skip("No posts with comments found. Skipping test.")
  }

  post_id <- posts_with_comments$id[1]  
  expect_true(length(post_id) > 0)
  print(paste("Selected Post ID with Comments:", post_id))

  # 3️⃣ Run sentiment analysis on the post's comments
  sentiment_results <- analyze_reddit_comments(subreddit_name, post_id, access_token, username)

  # Assertions for sentiment analysis results
  expect_true(is.data.frame(sentiment_results))  # Ensure output is a data frame
  expect_true(ncol(sentiment_results) == 2)  # Should have 2 columns: "Author" & "Sentiment_Score"

  if (nrow(sentiment_results) > 0) {
    expect_true("Author" %in% colnames(sentiment_results))
    expect_true("Sentiment_Score" %in% colnames(sentiment_results))

    # Check data types
    expect_type(sentiment_results$Author, "character")
    expect_type(sentiment_results$Sentiment_Score, "double")
  }

  # 4️⃣ Debugging output
  print("Test completed successfully. Sentiment analysis results:")
  print(sentiment_results)
  succeed()
})
