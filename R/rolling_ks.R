#'Parse SQL Code for rolling KS test

#' @export
rolling_ks <- function(y_hat = "pred",
                       y = "target",
                       table = "opd.test_pred_table",
                       time_variable = "inserttime") {
    raw_text <- glue::glue(
        "with a as (
    with a as (
        with a as (
            select distinct cast(strleft(cast({time_variable} as string),10) as timestamp) as obs_date
            from {table}
        )
        select a.obs_date, {y}, {y_hat}, {time_variable}
        from a
        left join {table} b
        on datediff(a.obs_date,{time_variable}) <= 7
    )
    select
        {y_hat}, {y}, {time_variable}, obs_date,
        sum({y}=1) over (partition by obs_date order by obs_date, {y_hat} rows between current row and unbounded following) as tp,
        sum({y}=0) over (partition by obs_date order by obs_date, {y_hat} rows between current row and unbounded following) as fp,
        sum({y}=1) over (partition by obs_date order by obs_date, {y_hat} rows between unbounded preceding and 1 preceding) as fn,
        sum({y}=0) over (partition by obs_date order by obs_date, {y_hat} rows between unbounded preceding and 1 preceding) as tn
    from a
)
select
    obs_date,
    max(tp/(tp+fn) - fp/(fp+tn)) as ks
from a
group by 1
order by obs_date"
    )

cat(sqltext)
clipr::write_clip(sqltext, allow_non_interactive = TRUE)
cat("The SQL text is on your clipboard.")
}
