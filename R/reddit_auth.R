#' Authenticate with the Reddit API
#'
#' This function authenticates a user with the Reddit API using OAuth2 password credentials
#' and retrieves an access token.
#'
#' @param client_id A string representing the Reddit API client ID.
#' @param client_secret A string representing the Reddit API client secret.
#' @param username A string representing the Reddit account username.
#' @param password A string representing the Reddit account password.
#'
#' @return A string containing the access token if authentication is successful.
#'
#' @examples
#' \dontrun{
#' token <- reddit_auth("your_client_id", "your_client_secret", "your_username", "your_password")
#' }
#'
#' @export
reddit_auth <- function(client_id, client_secret, username, password) {
  token_url <- "https://www.reddit.com/api/v1/access_token"

  response <- POST(
    token_url,
    authenticate(client_id, client_secret),
    body = list(
      grant_type = "password",
      username = username,
      password = password
    ),
    encode = "form",
    user_agent("R:RedditPackage:v1.0 (by /u/username)")
  )

  if (http_status(response)$category != "Success") {
    stop("Failed to authenticate with Reddit API")
  }

  token_data <- content(response, as = "parsed")
  return(token_data$access_token)
}

