#' Paste Markdown result from SQL query.
#'
#' The output is formatted in markdown, os it is easy to share output at the GitHub or GitLab.
#'
#' @importFrom stringr str_detect
#' @importFrom RODBC sqlQuery
#' @importFrom knitr kable
#' @importFrom clipr write_clip
#' @export

paste_sql_result <- function(sql_text) {
    is_describe <-
        sql_text %>% stringr::str_detect(fixed("describe", ignore_case = TRUE))
    sql_result <- RODBC::sqlQuery(impala, sql_text)
    sql_result <- if (is_describe) {
        sql_result
    } else {
        selected_rows <- min(6,nrow(sql_result))
        selected_cols <- min(6,ncol(sql_result))
        sql_result[1:selected_rows, 1:selected_cols]
    }
    sql_result <- sql_result %>% knitr::kable("markdown")
    sql_result <- c("```sql",sql_text, "```", "", "", sql_result)
    sql_result %>% clipr::write_clip(allow_non_interactive = TRUE)
    print(sql_result)
}