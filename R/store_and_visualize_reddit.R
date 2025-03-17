#' Store and Visualize Reddit Data
#'
#' This function retrieves Reddit posts and comments, saves them to CSV files,
#' performs sentiment analysis, and generates simple visualizations using Base R.
#'
#' @param subreddit The subreddit name.
#' @param access_token The Reddit API access token.
#' @param username Your Reddit username (for user-agent).
#' @param limit Number of posts to retrieve (default: 10).
#'
#' @return Saves posts, comments, and sentiment analysis to CSV and generates plots.
#'
#' @export
store_and_visualize_reddit <- function(subreddit, access_token, username, limit = 10) {
  
  # Load required libraries
  library(tidyverse)
  library(tidytext)

  # Load Reddit API functions
  source("C:/Users/zefen/Desktop/MDS/534/Reddit_API/R/get_subreddit_posts.R")
  source("C:/Users/zefen/Desktop/MDS/534/Reddit_API/R/get_post_comments.R")
  
  # 1️⃣ Fetch Posts
  print(paste("Fetching top", limit, "posts from r/", subreddit, "..."))
  posts <- get_subreddit_posts(subreddit, access_token, limit)
  
  if (nrow(posts) == 0) {
    stop("No posts retrieved. Check subreddit name or API access.")
  }

  # Save Posts to CSV
  posts_file <- paste0("reddit_posts_", subreddit, ".csv")
  write_csv(posts, posts_file)
  print(paste("Saved posts to:", posts_file))
  
  # 2️⃣ Fetch Comments
  all_comments <- tibble()
  for (post_id in posts$id) {
    print(paste("Fetching comments for post ID:", post_id))
    comments <- get_post_comments(subreddit, post_id, access_token, username)
    
    if (is.data.frame(comments) && nrow(comments) > 0) {
      comments$post_id <- post_id
      all_comments <- bind_rows(all_comments, comments)
    }
  }

  # Save Comments to CSV
  comments_file <- paste0("reddit_comments_", subreddit, ".csv")
  write_csv(all_comments, comments_file)
  print(paste("Saved comments to:", comments_file))

  # 3️⃣ Perform Sentiment Analysis
  afinn <- get_sentiments("afinn")
  sentiment_scores <- all_comments %>%
    unnest_tokens(word, Comment) %>%
    inner_join(afinn, by = "word") %>%
    group_by(Author) %>%
    summarise(Sentiment_Score = sum(value, na.rm = TRUE)) %>%
    arrange(desc(Sentiment_Score))

  # Save Sentiment Analysis to CSV
  sentiment_file <- paste0("reddit_sentiment_", subreddit, ".csv")
  write_csv(sentiment_scores, sentiment_file)
  print(paste("Saved sentiment analysis to:", sentiment_file))

  # 4️⃣ Basic Visualization using Base R
  print("Generating visualizations...")

  # 🔹 Top 10 Most Upvoted Posts
  if (nrow(posts) > 0) {
    top_posts <- posts %>% top_n(10, Upvotes)
    
    png(filename = paste0("reddit_top_posts_", subreddit, ".png"), width = 800, height = 600)
    barplot(
      top_posts$Upvotes,
      names.arg = substr(top_posts$Title, 1, 20),  # Truncate title for readability
      las = 2, col = "steelblue",
      main = "Top 10 Most Upvoted Posts",
      xlab = "Post Titles", ylab = "Upvotes"
    )
    dev.off()
    
    print(paste("Saved visualization: reddit_top_posts_", subreddit, ".png"))
  }

  # 🔹 Sentiment Analysis Visualization
  if (nrow(sentiment_scores) > 0) {
    top_sentiment <- sentiment_scores %>% top_n(10, Sentiment_Score)
    
    png(filename = paste0("reddit_top_sentiment_", subreddit, ".png"), width = 800, height = 600)
    barplot(
      top_sentiment$Sentiment_Score,
      names.arg = top_sentiment$Author,
      las = 2, col = "darkred",
      main = "Top 10 Users by Sentiment Score",
      xlab = "Users", ylab = "Sentiment Score"
    )
    dev.off()
    
    print(paste("Saved visualization: reddit_top_sentiment_", subreddit, ".png"))
  }

  print("✅ Data storage, analysis, and visualization completed successfully.")
}
