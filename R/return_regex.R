#' Return Seemingly Regular Expressions.
#'
#' @export
#' @examples
#' inputs <- row.names(mtcars)
#' inputs %>% head
#' # remotes::install_github("daranzolin/inferregex")
#' return_regex(inputs, verbose = "recommend")
#' return_regex(inputs, verbose = "all")
#' return_regex(inputs, verbose = "lazy")

return_regex <- function(input = row.names(mtcars),
                         verbose = c("recommend", "all", "lazy")) {
    library(inferregex)
    library(tidyverse)

    regex_df <- map_dfr(input, infer_regex)

    if (verbose == "recommend") {
        regex_df %>%
            group_by(regex) %>%
            count() %>%
            arrange(desc(n)) %>%
            head(3) %>%
            print

    }
    if (verbose == "all") {
        regex_df %>% print
    }
    if (verbose == "lazy") {
        regex_df %>% select(regex) %>% head(1) %>% pull %>%
        print
    }
}
