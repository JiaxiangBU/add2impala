library(devtools)
use_build_ignore("dev_history.R")

usethis::use_github_release()

document()
install()
