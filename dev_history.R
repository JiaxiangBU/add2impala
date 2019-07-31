library(devtools)
use_build_ignore("dev_history.R")


document()
install()


file.edit("NEWS.md")
use_version()
usethis::use_github_release()

rmarkdown::render("README.Rmd")
