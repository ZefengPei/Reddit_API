#' Retrieve Subreddit Information
#'
#' This function fetches detailed information about a specified subreddit using the Reddit API.
#'
#' @param subreddit A string specifying the name of the subreddit.
#' @param access_token A string representing the access token obtained via Reddit API authentication.
#' @param username A string representing the Reddit username used for the User-Agent header.
#'
#' @return A data frame containing details of the subreddit, including:
#' \item{title}{The name of the subreddit.}
#' \item{description}{The public description of the subreddit.}
#' \item{subscribers}{The number of subscribers to the subreddit.}
#' \item{active_users}{The number of active users in the subreddit.}
#' \item{created_utc}{The creation date of the subreddit (UTC).}
#' \item{over18}{Boolean indicating whether the subreddit is NSFW.}
#' \item{community_type}{The type of subreddit (e.g., public, private, restricted).}
#' \item{language}{The language setting of the subreddit.}
#' \item{icon_img}{URL of the subreddit’s icon image.}
#' \item{banner_img}{URL of the subreddit’s banner image.}
#' \item{primary_color}{Primary color of the subreddit’s theme.}
#' \item{allow_images}{Boolean indicating whether image posts are allowed.}
#' \item{allow_videos}{Boolean indicating whether video posts are allowed.}
#' \item{is_default}{Boolean indicating whether this is a default subreddit.}
#' \item{quarantine}{Boolean indicating whether the subreddit is quarantined.}
#' \item{submission_type}{The type of submissions allowed (e.g., "any", "link", "self").}
#' \item{wiki_enabled}{Boolean indicating whether the subreddit’s wiki is enabled.}
#'
#' @examples
#' \dontrun{
#' access_token <- reddit_auth("your_client_id", "your_client_secret", "your_username", "your_password")
#' subreddit_info <- get_subreddit_info("programming", access_token, username = "your_username")
#' print(subreddit_info)
#' }
#'
#' @export
get_subreddit_info <- function(subreddit, access_token, username) {
  url <- paste0("https://oauth.reddit.com/r/", subreddit, "/about")

  response <- GET(url, add_headers(
    Authorization = paste("bearer", access_token),
    "User-Agent" = paste0("R:RedditAPI:v1.0 (by /u/", username, ")")
  ))

  if (status_code(response) == 200) {
    data <- content(response, as = "parsed", type = "application/json")

    if (!is.null(data$data)) {
      # Define a helper function to replace NULL values with NA
      safe_extract <- function(x) {
        if (is.null(x)) return(NA) else return(x)
      }

      return(data.frame(
        title = safe_extract(data$data$title),
        description = safe_extract(data$data$public_description),
        subscribers = safe_extract(data$data$subscribers),
        active_users = safe_extract(data$data$active_user_count),
        created_utc = as.POSIXct(safe_extract(data$data$created_utc), origin = "1970-01-01", tz = "UTC"),
        over18 = safe_extract(data$data$over18),
        community_type = safe_extract(data$data$subreddit_type),
        language = safe_extract(data$data$lang),
        icon_img = safe_extract(data$data$icon_img),
        banner_img = safe_extract(data$data$banner_background_image),
        primary_color = safe_extract(data$data$primary_color),
        allow_images = safe_extract(data$data$allow_images),
        allow_videos = safe_extract(data$data$allow_videos),
        is_default = safe_extract(data$data$default_set),
        quarantine = safe_extract(data$data$quarantine),
        submission_type = safe_extract(data$data$submission_type),
        wiki_enabled = safe_extract(data$data$wiki_enabled),
        stringsAsFactors = FALSE
      ))
    } else {
      stop("Subreddit data not found.")
    }
  } else {
    stop("Failed to fetch subreddit info. Check subreddit name or access token.")
  }
}
