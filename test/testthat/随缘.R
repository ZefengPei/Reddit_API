install.packages("tidytext", dependencies = TRUE)
library(tidytext)
afinn <- get_sentiments("afinn")
head(afinn)


