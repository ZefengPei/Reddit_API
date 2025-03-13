#' Retrieve Subreddit Rules
#'
#' This function fetches the moderation rules for a specified subreddit.
#'
#' @param subreddit A string specifying the subreddit name.
#' @param access_token A string containing the access token obtained via Reddit API authentication.
#' @param username A string specifying the Reddit username (used in the User-Agent header).
#'
#' @return A data frame containing the following columns:
#' \describe{
#'   \item{Title}{The short name of the rule.}
#'   \item{Description}{A detailed description of the rule.}
#'   \item{Priority}{The priority ranking of the rule.}
#'   \item{Violation_Reason}{The reason provided for a rule violation.}
#' }
#'
#' @examples
#' \dontrun{
#' access_token <- "your_access_token_here"
#' rules <- get_subreddit_rules("rstats", access_token, "your_username")
#' print(rules)
#' }
#'
#' @export
get_subreddit_rules <- function(subreddit, access_token, username) {
  # Construct the URL for subreddit rules
  url <- paste0("https://oauth.reddit.com/r/", subreddit, "/about/rules")

  # Send the GET request to fetch the rules
  response <- GET(url, add_headers(
    Authorization = paste("bearer", access_token),
    "User-Agent" = paste0("R:RedditAPI:v1.0 (by /u/", username, ")")
  ))

  # Check if the response is successful (status code 200)
  if (status_code(response) == 200) {
    # Parse the response content
    data <- content(response, as = "parsed", type = "application/json")

    # Extract the rules data
    rules <- data$rules

    # Check if there are rules in the response
    if (length(rules) > 0) {
      # Convert the list of rules into a data frame
      df <- data.frame(
        Title = sapply(rules, function(x) x$short_name),
        Description = sapply(rules, function(x) x$description),
        Priority = sapply(rules, function(x) x$priority),
        Violation_Reason = sapply(rules, function(x) x$violation_reason),
        stringsAsFactors = FALSE
      )

      return(df)
    } else {
      return(data.frame(
        Title = character(),
        Description = character(),
        Priority = integer(),
        Violation_Reason = character(),
        stringsAsFactors = FALSE
      ))  # Return an empty dataframe if no rules exist
    }
  } else {
    stop("Failed to fetch subreddit rules. Check subreddit name or access token.")
  }
}
