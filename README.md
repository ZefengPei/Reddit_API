# Reddit API R Package

![Workflow Status](https://github.com/ZefengPei/Reddit_API/actions/workflows/test.yml/badge.svg)

This R package provides an interface to interact with the Reddit API, allowing users to retrieve various types of Reddit data such as posts, comments, user profiles, and subreddit details. It also includes sentiment analysis for Reddit comments and data visualization.

## Features

- **Authenticate using OAuth2**: Obtain an access token with Reddit credentials.
- **Fetch Subreddit Posts**: Retrieve the latest posts from a given subreddit.
- **Fetch Top Posts**: Get top posts from a subreddit for different time periods.
- **Fetch Post Comments**: Retrieve comments for a specific post.
- **Get User Information**: Fetch Reddit user profile details such as karma, moderator status, etc.
- **Fetch Subreddit Information**: Retrieve details about a subreddit, including its description, creation date, and subscriber count.
- **Analyze Reddit Comments**: Perform sentiment analysis on Reddit comments using the AFINN sentiment lexicon.
- **Store and Visualize Reddit Data**: Save subreddit data to CSV files and generate visualizations using base R.

## Installation

To install the package, clone the repository and install the necessary dependencies.

### Steps:

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/reddit-api-r-package.git
   ```
2. Install required dependencies in R:
   ```r
   install.packages(c("httr", "tidyverse", "tidytext"))
   ```
3. Load the package functions:
   ```r
   source("path-to-repo/reddit_auth.R")
   source("path-to-repo/get_subreddit_info.R")
   source("path-to-repo/get_subreddit_posts.R")
   source("path-to-repo/get_post_comments.R")
   source("path-to-repo/get_user_info.R")
   source("path-to-repo/analyze_reddit_comments.R")
   source("path-to-repo/store_and_visualize_reddit.R")
   ```

## Usage

### **1️⃣ Authenticate and Obtain Access Token**
```r
access_token <- reddit_auth(client_id, client_secret, username, password)
```
This function authenticates the user using Reddit API credentials and returns an access token.

### **2️⃣ Fetch Subreddit Information**
```r
info <- get_subreddit_info("rstats")
print(info)
```
This function retrieves general information about a subreddit, including its description, subscriber count, and creation date.

### **3️⃣ Fetch Subreddit Posts**
```r
subreddit <- "programming"
posts <- get_subreddit_posts(subreddit, access_token, limit = 10)
print(posts)
```
Retrieves the most recent posts from the specified subreddit.

### **4️⃣ Fetch Comments for a Specific Post**
```r
post_id <- "1jcfchv"
comments <- get_post_comments(subreddit, post_id, access_token, username)
print(comments)
```
Retrieves all comments from a specific Reddit post.

### **5️⃣ Fetch User Information**
```r
user_info <- get_user_info(reddit_username, access_token)
print(user_info)
```
This function retrieves details about a Reddit user, including their karma, moderator status, and account age.

### **6️⃣ Analyze Reddit Comments**
```r
sentiment_results <- analyze_reddit_comments(subreddit, post_id, access_token, username)
print(sentiment_results)
```
Performs sentiment analysis on the comments of a specified post using the AFINN sentiment lexicon.

### **7️⃣ Store and Visualize Reddit Data**
```r
store_and_visualize_reddit(subreddit, access_token, username, limit = 10)
```
This function will:
- Save posts and comments to CSV files.
- Perform sentiment analysis on comments.
- Generate bar plots for top upvoted posts and sentiment scores.

## Output Files
After running `store_and_visualize_reddit()`, the following files will be created in the current working directory:
- `reddit_posts_<subreddit>.csv`
- `reddit_comments_<subreddit>.csv`
- `reddit_sentiment_<subreddit>.csv`
- `reddit_top_posts_<subreddit>.png`
- `reddit_top_sentiment_<subreddit>.png`

## Example Output
### **Reddit Sentiment Analysis Result**
```
| Author      | Sentiment_Score |
|------------|----------------|
| user_1     | 12             |
| user_2     | -5             |
| user_3     | 7              |
```

### **Generated Visualizations**
- **`reddit_top_posts_<subreddit>.png`**: A bar chart of the most upvoted posts.
- **`reddit_top_sentiment_<subreddit>.png`**: A bar chart showing the top users by sentiment score.

## Dependencies
This package requires the following R libraries:
- `httr` (for API requests)
- `tidyverse` (for data manipulation)
- `tidytext` (for sentiment analysis)

Make sure these packages are installed before using the package.

## License
This package is open-source and distributed under the MIT License.
