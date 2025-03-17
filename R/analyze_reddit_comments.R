#' Analyze Reddit Comments for Sentiment
#'
#' This function retrieves comments for a specific Reddit post, performs sentiment analysis,
#' and returns a summary of sentiment scores by author.
#'
#' @param subreddit The name of the subreddit.
#' @param post_id The Reddit post ID.
#' @param access_token The Reddit API access token.
#' @param username Your Reddit username (for API request headers).
#'
#' @return A data frame containing sentiment scores per author.
#'
#' @export
analyze_reddit_comments <- function(subreddit, post_id, access_token, username) {
  
  # Load required libraries
  if (!requireNamespace("tidyverse", quietly = TRUE)) install.packages("tidyverse", dependencies = TRUE)
  if (!requireNamespace("tidytext", quietly = TRUE)) install.packages("tidytext", dependencies = TRUE)
  
  library(tidyverse)
  library(tidytext)

  # Load Reddit API function for getting comments
  source("C:/Users/zefen/Desktop/MDS/534/Reddit_API/R/get_post_comments.R")

  # Fetch comments for the given post
  print(paste("Fetching comments for post ID:", post_id))
  comments <- get_post_comments(subreddit, post_id, access_token, username)
  
  # Check if comments were retrieved
  if (nrow(comments) == 0) {
    stop("No comments retrieved. Cannot perform sentiment analysis.")
  }

  # Perform sentiment analysis using AFINN lexicon
  afinn <- get_sentiments("afinn")

  sentiment_scores <- comments %>%
    unnest_tokens(word, Comment) %>%  # Tokenize words
    inner_join(afinn, by = "word") %>%  # Match words with sentiment lexicon
    group_by(Author) %>%
    summarise(Sentiment_Score = sum(value, na.rm = TRUE)) %>%
    arrange(desc(Sentiment_Score))

  # Return sentiment scores
  return(sentiment_scores)
}
