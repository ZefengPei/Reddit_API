# Load test framework
if (!require(testthat)) install.packages("testthat", dependencies = TRUE)
library(testthat)
library(httr)

# Load Reddit API functions
source("C:/Users/zefen/Desktop/MDS/534/Reddit_API/R/reddit_auth.R")
source("C:/Users/zefen/Desktop/MDS/534/Reddit_API/R/get_subreddit_posts.R")
source("C:/Users/zefen/Desktop/MDS/534/Reddit_API/R/get_post_comments.R")

# Set Reddit API credentials
client_id <- "PeAknuUXpERmde8cC-sSEQ"
client_secret <- "3uy3ngtkPB0vlnCogMpeemmnaMEqaA"
username <- "Fantastic_Snow_7640"
password <- "bay_reddit"

# Run the test
test_that("get_post_comments() should return a valid response", {

  # 1️⃣ Authenticate and obtain access_token
  access_token <- reddit_auth(client_id, client_secret, username, password)
  access_token <- as.character(access_token)  # Ensure access_token is a string
  expect_type(access_token, "character")  # Assert access_token is a string
  expect_true(nchar(access_token) > 0)  # Ensure access_token is not empty

  # 2️⃣ Retrieve the latest posts from a subreddit
  subreddit_name <- "programming"  # Change this to any subreddit
  limit <- 5  # Retrieve 5 posts for debugging

  posts <- get_subreddit_posts(subreddit_name, access_token, limit)

  # Assert that posts were successfully retrieved
  expect_true(is.data.frame(posts))
  expect_true(nrow(posts) > 0)  # Ensure there are available posts
  
  # Select the latest post ID
  post_id <- posts$id[1]  # Select the first post
  print(paste("Fetching comments for post ID:", post_id))

  # 3️⃣ Retrieve comments for the selected post
  comments <- get_post_comments(subreddit_name, post_id, access_token)

  # 4️⃣ Check the response
  expect_true(is.list(comments) || is.data.frame(comments))  # The result should be a list or data.frame
  expect_true(length(comments) > 0)  # The result should not be empty

  # 5️⃣ Further validate the data structure (if returned as a data.frame)
  if (is.data.frame(comments)) {
    expect_true("Author" %in% colnames(comments))
    expect_true("Comment" %in% colnames(comments))
    expect_true("Upvotes" %in% colnames(comments))
    expect_true("Replies" %in% colnames(comments))

    expect_type(comments$Author, "character")
    expect_type(comments$Comment, "character")
    expect_type(comments$Upvotes, "integer")
    expect_type(comments$Replies, "integer")
  }

  # 6️⃣ Debugging output
  print("Test completed successfully. Here are some comments:")
  print(comments)

})
