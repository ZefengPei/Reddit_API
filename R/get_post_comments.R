#' Retrieve Comments from a Reddit Post
#'
#' This function fetches the top-level comments for a specified Reddit post.
#'
#' @param subreddit A string specifying the subreddit name where the post is located.
#' @param post_id A string representing the Reddit post ID.
#' @param access_token A string containing the access token obtained via Reddit API authentication.
#' @param username A string containing the Reddit username (used in User-Agent header).
#'
#' @return A data frame containing the following columns:
#' \describe{
#'   \item{Author}{The username of the comment author.}
#'   \item{Comment}{The text content of the comment (or "[Deleted]" if removed).}
#'   \item{Upvotes}{The number of upvotes the comment has received.}
#'   \item{Replies}{The number of direct replies to the comment.}
#' }
#'
#' If no comments are found, the function returns a data frame with a message indicating that no comments are available.
#' If the response structure is unexpected, the function returns a message indicating an issue with the response format.
#'
#' @examples
#' \dontrun{
#' access_token <- "your_access_token_here"
#' comments <- get_post_comments("programming", "abc123", access_token, "your_username")
#' print(comments)
#' }
#'
#' @export
get_post_comments <- function(subreddit, post_id, access_token, username) {
  
  # Construct the API URL
  url <- paste0("https://oauth.reddit.com/r/", subreddit, "/comments/", post_id)

  # Make the API request
  response <- GET(url, add_headers(
    Authorization = paste("bearer", access_token),
    `User-Agent` = paste("R:RedditPackage:v1.0 (by /u/", username, ")", sep = "")
  ))

  # Check if the request was successful
  if (status_code(response) == 200) {
    # Parse JSON response safely
    data <- suppressWarnings(content(response, as = "parsed", type = "application/json"))

    # Ensure response has expected structure
    if (length(data) >= 2 && "data" %in% names(data[[2]]) && "children" %in% names(data[[2]]$data)) {
      comments <- data[[2]]$data$children

      if (length(comments) > 0) {
        # Extract relevant fields using vapply (to avoid length mismatch issues)
        df <- data.frame(
          Author = vapply(comments, function(x) if (!is.null(x$data$author)) x$data$author else "Unknown", character(1)),
          Comment = vapply(comments, function(x) if (!is.null(x$data$body)) x$data$body else "[Deleted]", character(1)),
          Upvotes = vapply(comments, function(x) if (!is.null(x$data$ups)) as.integer(x$data$ups) else 0, integer(1)),
          Replies = vapply(comments, function(x) {
            if (!is.null(x$data$replies) && "data" %in% names(x$data$replies) && "children" %in% names(x$data$replies$data)) {
              return(as.integer(length(x$data$replies$data$children)))  # 确保返回 `integer`
            } else {
              return(0L)  
            }
          }, integer(1)),
          stringsAsFactors = FALSE
        )

        return(df)
      } else {
        return(data.frame(Message = paste("No comments available for post ID:", post_id), stringsAsFactors = FALSE))
      }
    } else {
      return(data.frame(Message = paste("Unexpected response structure for post ID:", post_id), stringsAsFactors = FALSE))
    }
  } else {
    stop(paste("Failed to fetch comments. HTTP Status:", status_code(response)))
  }
}
