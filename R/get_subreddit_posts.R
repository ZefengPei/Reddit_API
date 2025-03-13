#' Retrieve Hot Posts from a Subreddit
#'
#' This function fetches the hottest posts from a specified subreddit using the Reddit API.
#'
#' @param subreddit A string specifying the subreddit name (without the "/r/").
#' @param access_token A string representing the access token obtained via Reddit API authentication.
#' @param limit An integer specifying the number of posts to retrieve.
#' @param username A string representing the Reddit username used for the User-Agent header.
#'
#' @return A data frame containing details of the retrieved posts, including:
#' \item{id}{The post ID.}
#' \item{Title}{The title of the post.}
#' \item{Author}{The Reddit username of the post author.}
#' \item{Subreddit}{The name of the subreddit.}
#' \item{Upvotes}{The number of upvotes the post received.}
#' \item{Comments}{The number of comments on the post.}
#' \item{URL}{The URL of the post.}
#' \item{Created}{The timestamp of when the post was created.}
#'
#' @examples
#' \dontrun{
#' access_token <- reddit_auth("your_client_id", "your_client_secret", "your_username", "your_password")
#' posts <- get_subreddit_posts("rstats", access_token, limit = 5, username = "your_username")
#' print(posts)
#' }
#'
#' @export
get_subreddit_posts <- function(subreddit, access_token, limit, username) {
  url <- paste0("https://oauth.reddit.com/r/", subreddit, "/hot?limit=", limit)

  response <- GET(
    url,
    add_headers(Authorization = paste("bearer", access_token)),
    "User-Agent" = paste0("R:RedditAPI:v1.0 (by /u/", username, ")")

  )

  # Check if API response is successful
  if (http_status(response)$category != "Success") {
    stop("Failed to fetch subreddit posts")
  }

  # Parse JSON response
  posts <- content(response, as = "parsed", simplifyVector = TRUE)

  # Extract relevant data
  ids <- posts$data$children$data$id
  titles <- posts$data$children$data$title
  authors <- posts$data$children$data$author
  upvotes <- posts$data$children$data$ups
  comments <- posts$data$children$data$num_comments
  urls <- posts$data$children$data$url
  created <- as.POSIXct(posts$data$children$data$created_utc, origin = "1970-01-01") # Convert timestamp
  subreddit <- posts$data$children$data$subreddit

  # Create a data frame
  df <- data.frame(
    id = ids,
    Title = titles,
    Author = authors,
    Subreddit = subreddit,
    Upvotes = upvotes,
    Comments = comments,
    URL = urls,
    Created = created,
    stringsAsFactors = FALSE
  )

  #return(posts$data$children)  # Return only the list of posts
  return(df)
}
