# install from github
# devtools::install_github("timelyportfolio/eventdropR")

library(eventdropR)

# make some sample data
df <- data.frame(
  # random times 30 days plus or minus current time
  date = Sys.time() + runif(1000, -30, 30) * 24 * 60 * 60,
  # make up five groups
  group = paste0("grp_", LETTERS[runif(1000,1,5)]),
  stringsAsFactors = FALSE
)

eventdrop(df)
