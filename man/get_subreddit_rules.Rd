% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_subreddit_rules.R
\name{get_subreddit_rules}
\alias{get_subreddit_rules}
\title{Retrieve Subreddit Rules}
\usage{
get_subreddit_rules(subreddit, access_token)
}
\arguments{
\item{subreddit}{A string specifying the subreddit name.}

\item{access_token}{A string containing the access token obtained via Reddit API authentication.}
}
\value{
A data frame containing the following columns:
\describe{
\item{Title}{The short name of the rule.}
\item{Description}{A detailed description of the rule.}
\item{Priority}{The priority ranking of the rule.}
\item{Violation_Reason}{The reason provided for a rule violation.}
}
}
\description{
This function fetches the moderation rules for a specified subreddit.
}
\examples{
\dontrun{
access_token <- "your_access_token_here"
rules <- get_subreddit_rules("rstats", access_token, "your_username")
print(rules)
}

}
