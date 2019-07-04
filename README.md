
<!-- README.md is generated from README.Rmd. Please edit that file -->

# add2impala

<!-- badges: start -->

<!-- badges: end -->

The goal of add2impala is to parse statistical metrics and encoding in
SQL using R.

## Installation

The development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("JiaxiangBU/add2impala")
```

## Example

``` r
parse_ks_sql(verbose = 0, y_hat = "pred", y = "target", table = "opd.table")
#> select pred, target,
#>     sum(y=1) over (order by y_hat rows between current row and unbounded following) as tp,
#>     sum(y=0) over (order by y_hat rows between current row and unbounded following) as fp,
#>     sum(y=1) over (order by y_hat rows between unbounded preceding and 1 preceding) as fn,
#>     sum(y=0) over (order by y_hat rows between unbounded preceding and 1 preceding) as tn
#> from opd.tableThe SQL text is on your clipboard.
parse_ks_sql(verbose = 1, y_hat = "pred", y = "target", table = "opd.table")
#> with a as (
#> select pred, target,
#>     sum(y=1) over (order by y_hat rows between current row and unbounded following) as tp,
#>     sum(y=0) over (order by y_hat rows between current row and unbounded following) as fp,
#>     sum(y=1) over (order by y_hat rows between unbounded preceding and 1 preceding) as fn,
#>     sum(y=0) over (order by y_hat rows between unbounded preceding and 1 preceding) as tn
#> from opd.table
#> )
#> select pred, target,
#>    tp/(tp+fn) as tpr,
#>    fp/(fp+tn) as fpr,
#>    tp/(tp+fn) - fp/(fp+tn) as ks
#> from aThe SQL text is on your clipboard.
parse_ks_sql(verbose = 2, y_hat = "pred", y = "target", table = "opd.table")
#> with a as (
#> select pred, target,
#>     sum(y=1) over (order by y_hat rows between current row and unbounded following) as tp,
#>     sum(y=0) over (order by y_hat rows between current row and unbounded following) as fp,
#>     sum(y=1) over (order by y_hat rows between unbounded preceding and 1 preceding) as fn,
#>     sum(y=0) over (order by y_hat rows between unbounded preceding and 1 preceding) as tn
#> from opd.table
#> )
#> max(tp/(tp+fn) - fp/(fp+tn)) as ks
#> from aThe SQL text is on your clipboard.
```

The measurment explanation is
[here](https://jiaxiangbu.github.io/learn_roc/ks_learning_notes.html#ks)
(Chinese).
