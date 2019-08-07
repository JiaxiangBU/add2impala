library(devtools)
# use_build_ignore("dev_history.R")


document()
install()


file.edit("NEWS.md")
use_version()
usethis::use_github_release()

rmarkdown::render("README.Rmd")

use_code_of_conduct()
file.edit("README.Rmd")
rmarkdown::render("README.Rmd")
file.remove("README.html")
source("../imp_rmd/R/pull_and_push.R")


# add examlpes ------------------------------------------------------------

clipr::read_clip() %>%
    str_c("#' ", .) %>%
    clipr::write_clip()

clipr::read_clip() %>%
    str_c("#' \\dontrun{", ., "}") %>%
    clipr::write_clip()
