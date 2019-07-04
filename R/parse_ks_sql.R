#'Parse SQL Code for KS test

#' @export
#' @examples
#' \dontrun(parse_ks_sql(verbose = 0))
#' \dontrun(parse_ks_sql(verbose = 1))
#' \dontrun(parse_ks_sql(verbose = 2))
parse_ks_sql <- function(verbose = 0,
                         y_hat = "pred",
                         y = "target",
                         table = "opd.test_pred_table") {
  raw_text <- glue::glue(
    "select {y_hat}, {y},
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
       select {y_hat}, {y},
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
