#' Retrieve Reddit User Information
#'
#' This function fetches detailed information about a specified Reddit user using the Reddit API.
#'
#' @param reddit_username A string specifying the Reddit username whose information is being retrieved.
#' @param access_token A string representing the access token obtained via Reddit API authentication.
#'
#' @return A data frame containing details of the Reddit user, including:
#' \item{Username}{The Reddit username.}
#' \item{Link_Karma}{The total link karma of the user.}
#' \item{Comment_Karma}{The total comment karma of the user.}
#' \item{Created_At}{The account creation timestamp (UTC).}
#' \item{Is_Mod}{Boolean indicating whether the user is a moderator.}
#' \item{Is_Gold}{Boolean indicating whether the user has Reddit Premium (gold).}
#' \item{Verified}{Boolean indicating whether the user is verified.}
#'
#' @examples
#' \dontrun{
#' access_token <- reddit_auth("your_client_id", "your_client_secret", "your_username", "your_password")
#' user_info <- get_user_info("example_user", access_token, username = "your_username")
#' print(user_info)
#' }
#'
#' @export
get_user_info <- function(reddit_username, access_token) {
  url <- paste0("https://oauth.reddit.com/user/", reddit_username, "/about")

  response <- GET(url, add_headers(Authorization = paste("bearer", access_token),
                                   user_agent("R:RedditPackage:v1.0 (by /u/username)")

  ))

  if (status_code(response) == 200) {
    data <- content(response, as = "parsed", type = "application/json")

    # Extract user information
    user_info <- data$data

    # Create a data frame
    df <- data.frame(
      Username = user_info$name,
      Link_Karma = user_info$link_karma,
      Comment_Karma = user_info$comment_karma,
      Created_At = as.POSIXct(user_info$created_utc, origin = "1970-01-01", tz = "UTC"),
      Is_Mod = user_info$is_mod,
      Is_Gold = user_info$is_gold,
      Verified = user_info$verified,
      stringsAsFactors = FALSE
    )

    return(df)
  } else {
    stop("Failed to fetch user info. Check username or access token.")
  }
}
