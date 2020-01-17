globalVariables(c("regex"))
#' Return Seemingly Regular Expressions.
#' @import inferregex
#' @import dplyr
#' @param input The text list.
#' @param verbose the output style, by default, 'recommend', 'all' and 'lazy'.
#' @export
#' @examples
#' inputs <- row.names(mtcars)
#' inputs %>% head
#' # remotes::install_github("daranzolin/inferregex")
#' return_regex(inputs, verbose = "recommend")
#' return_regex(inputs, verbose = "all")
#' return_regex(inputs, verbose = "lazy")
return_regex <- function(input = row.names(datasets::mtcars),
                         verbose = c("recommend", "all", "lazy")) {
    # library(inferregex)
    # library(tidyverse)

    regex_df <- purrr::map_dfr(input, inferregex::infer_regex)

    if (verbose == "recommend") {
        regex_df %>%
            dplyr::group_by(regex) %>%
            dplyr::count() %>%
            dplyr::arrange(dplyr::desc(n)) %>%
            head(3) %>%
            print()

    }
    if (verbose == "all") {
        regex_df %>% print()
    }
    if (verbose == "lazy") {
        regex_df %>% dplyr::select(regex) %>% head(1) %>% dplyr::pull() %>%
        print()
    }
}
