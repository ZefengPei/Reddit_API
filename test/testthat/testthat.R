Sys.setenv(
  CLIENT_ID = Sys.getenv("CLIENT_ID"),
  CLIENT_SECRET = Sys.getenv("CLIENT_SECRET"),
  REDDIT_USERNAME = Sys.getenv("REDDIT_USERNAME"),
  REDDIT_PASSWORD = Sys.getenv("REDDIT_PASSWORD")
)

print("DEBUG: Environment variables loaded")
print(Sys.getenv("REDDIT_USERNAME"))
