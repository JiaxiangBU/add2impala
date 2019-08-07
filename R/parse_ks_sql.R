#'Parse SQL Code for KS test

#' @export
#' @examples
#' \dontrun{parse_ks_sql(verbose = 0, y_hat = "pred", y = "target", table = "opd.table")}
#' \dontrun{parse_ks_sql(verbose = 1, y_hat = "pred", y = "target", table = "opd.table")}
#' \dontrun{parse_ks_sql(verbose = 2, y_hat = "pred", y = "target", table = "opd.table")}
parse_ks_sql <- function(verbose = 0,
                         y_hat = "pred",
                         y = "target",
                         table = "opd.test_pred_table",
                         other_variables = "") {
  if (other_variables != "") {
    cat("seperate the variable by comma `,`")
  } else {
    paste0(other_variables, ",")
  }
  raw_text <- glue::glue(
    "select {y_hat}, {y}, {other_variables}
          sum(y=1) over (order by y_hat rows between current row and unbounded following) as tp,
          sum(y=0) over (order by y_hat rows between current row and unbounded following) as fp,
          sum(y=1) over (order by y_hat rows between unbounded preceding and 1 preceding) as fn,
          sum(y=0) over (order by y_hat rows between unbounded preceding and 1 preceding) as tn
      from {table}"
  )

  sqltext <- if (verbose == 0) {
    raw_text

  } else if (verbose == 1) {
    glue::glue(
      "with a as (
       {raw_text}
       )
       select {y_hat}, {y}, {other_variables}
          tp/(tp+fn) as tpr,
          fp/(fp+tn) as fpr,
          tp/(tp+fn) - fp/(fp+tn) as ks
       from a
       "
    )

  } else if (verbose == 2) {
    glue::glue("with a as (
       {raw_text}
       )
       max(tp/(tp+fn) - fp/(fp+tn)) as ks
       from a
       ")
  } else {
    "stop use verbose in [0,2]"
  }

  cat(sqltext)
  clipr::write_clip(sqltext, allow_non_interactive = TRUE)
  cat("The SQL text is on your clipboard.")
}
