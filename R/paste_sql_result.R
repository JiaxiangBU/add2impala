#' Paste Markdown result from SQL query.
#'
#' The output is formatted in markdown, os it is easy to share output at the GitHub or GitLab.
#'
#' @importFrom stringr str_detect fixed
#' @importFrom RODBC sqlQuery
#' @importFrom knitr kable
#' @importFrom clipr write_clip
#' @importFrom utils head
#' @param sql_text The SQL text.
#' @export
#' @examples
#' \dontrun{output_paste_sql_result1 <- paste_sql_result("describe opd.sqlsave_test_ljx")}
#' \dontrun{output_paste_sql_result2 <- read_rds("output/output_paste_sql_result2.rds")}

paste_sql_result <- function(sql_text) {
    is_describe <-
        sql_text %>% stringr::str_detect(stringr::fixed("describe", ignore_case = TRUE))
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
