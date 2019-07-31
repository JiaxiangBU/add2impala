
<!-- README.md is generated from README.Rmd. Please edit that file -->

# add2impala

<!-- badges: start -->

[![DOI](https://zenodo.org/badge/195213708.svg)](https://zenodo.org/badge/latestdoi/195213708)
<!-- badges: end -->

The goal of add2impala is to parse statistical metrics and encoding in
SQL using R. If you want to calculate KS statistic in R, free to try
[rawKS](https://github.com/JiaxiangBU/rawKS).

## Installation

The development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("JiaxiangBU/add2impala")
```

## Example

``` r
library(add2impala)
library(tidyverse)
```

### KS

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

### Regular expression

``` r
inputs <- row.names(mtcars)
inputs %>% head
#> [1] "Mazda RX4"         "Mazda RX4 Wag"     "Datsun 710"       
#> [4] "Hornet 4 Drive"    "Hornet Sportabout" "Valiant"
```

``` r
# remotes::install_github("daranzolin/inferregex")
return_regex(inputs, verbose = "recommend")
#> # A tibble: 3 x 2
#> # Groups:   regex [3]
#>   regex                                  n
#>   <chr>                              <int>
#> 1 "^[A-Z][a-z]{3}\\s\\d{3}$"             3
#> 2 "^[A-Z][a-z]{3}\\s\\d{3}[A-Z]$"        2
#> 3 "^[A-Z][a-z]{3}\\s\\d{3}[A-Z]{2}$"     2
return_regex(inputs, verbose = "all")
#>                 string                                         regex
#> 1            Mazda RX4                 ^[A-Z][a-z]{4}\\s[A-Z]{2}\\d$
#> 2        Mazda RX4 Wag ^[A-Z][a-z]{4}\\s[A-Z]{2}\\d\\s[A-Z][a-z]{2}$
#> 3           Datsun 710                      ^[A-Z][a-z]{5}\\s\\d{3}$
#> 4       Hornet 4 Drive         ^[A-Z][a-z]{5}\\s\\d\\s[A-Z][a-z]{4}$
#> 5    Hornet Sportabout               ^[A-Z][a-z]{5}\\s[A-Z][a-z]{9}$
#> 6              Valiant                               ^[A-Z][a-z]{6}$
#> 7           Duster 360                      ^[A-Z][a-z]{5}\\s\\d{3}$
#> 8            Merc 240D                 ^[A-Z][a-z]{3}\\s\\d{3}[A-Z]$
#> 9             Merc 230                      ^[A-Z][a-z]{3}\\s\\d{3}$
#> 10            Merc 280                      ^[A-Z][a-z]{3}\\s\\d{3}$
#> 11           Merc 280C                 ^[A-Z][a-z]{3}\\s\\d{3}[A-Z]$
#> 12          Merc 450SE              ^[A-Z][a-z]{3}\\s\\d{3}[A-Z]{2}$
#> 13          Merc 450SL              ^[A-Z][a-z]{3}\\s\\d{3}[A-Z]{2}$
#> 14         Merc 450SLC              ^[A-Z][a-z]{3}\\s\\d{3}[A-Z]{3}$
#> 15  Cadillac Fleetwood               ^[A-Z][a-z]{7}\\s[A-Z][a-z]{8}$
#> 16 Lincoln Continental              ^[A-Z][a-z]{6}\\s[A-Z][a-z]{10}$
#> 17   Chrysler Imperial               ^[A-Z][a-z]{7}\\s[A-Z][a-z]{7}$
#> 18            Fiat 128                      ^[A-Z][a-z]{3}\\s\\d{3}$
#> 19         Honda Civic               ^[A-Z][a-z]{4}\\s[A-Z][a-z]{4}$
#> 20      Toyota Corolla               ^[A-Z][a-z]{5}\\s[A-Z][a-z]{6}$
#> 21       Toyota Corona               ^[A-Z][a-z]{5}\\s[A-Z][a-z]{5}$
#> 22    Dodge Challenger               ^[A-Z][a-z]{4}\\s[A-Z][a-z]{9}$
#> 23         AMC Javelin                    ^[A-Z]{3}\\s[A-Z][a-z]{6}$
#> 24          Camaro Z28                 ^[A-Z][a-z]{5}\\s[A-Z]\\d{2}$
#> 25    Pontiac Firebird               ^[A-Z][a-z]{6}\\s[A-Z][a-z]{7}$
#> 26           Fiat X1-9                ^[A-Z][a-z]{3}\\s[A-Z]\\d-\\d$
#> 27       Porsche 914-2                  ^[A-Z][a-z]{6}\\s\\d{3}-\\d$
#> 28        Lotus Europa               ^[A-Z][a-z]{4}\\s[A-Z][a-z]{5}$
#> 29      Ford Pantera L       ^[A-Z][a-z]{3}\\s[A-Z][a-z]{6}\\s[A-Z]$
#> 30        Ferrari Dino               ^[A-Z][a-z]{6}\\s[A-Z][a-z]{3}$
#> 31       Maserati Bora               ^[A-Z][a-z]{7}\\s[A-Z][a-z]{3}$
#> 32          Volvo 142E                 ^[A-Z][a-z]{4}\\s\\d{3}[A-Z]$
#>    nchars nlower nupper ndigits nwhite
#> 1       9      4      3       1      1
#> 2      13      6      4       1      2
#> 3      10      5      1       3      1
#> 4      14      9      2       1      2
#> 5      17     14      2       0      1
#> 6       7      6      1       0      0
#> 7      10      5      1       3      1
#> 8       9      3      2       3      1
#> 9       8      3      1       3      1
#> 10      8      3      1       3      1
#> 11      9      3      2       3      1
#> 12     10      3      3       3      1
#> 13     10      3      3       3      1
#> 14     11      3      4       3      1
#> 15     18     15      2       0      1
#> 16     19     16      2       0      1
#> 17     17     14      2       0      1
#> 18      8      3      1       3      1
#> 19     11      8      2       0      1
#> 20     14     11      2       0      1
#> 21     13     10      2       0      1
#> 22     16     13      2       0      1
#> 23     11      6      4       0      1
#> 24     10      5      2       2      1
#> 25     16     13      2       0      1
#> 26      9      3      2       2      1
#> 27     13      6      1       4      1
#> 28     12      9      2       0      1
#> 29     14      9      3       0      2
#> 30     12      9      2       0      1
#> 31     13     10      2       0      1
#> 32     10      4      2       3      1
return_regex(inputs, verbose = "lazy")
#> [1] "^[A-Z][a-z]{4}\\s[A-Z]{2}\\d$"
```

### Rolling KS

``` r
rolling_ks(
    y_hat = "pred",
    y = "target",
    table = "opd.test_pred_table",
    time_variable = "inserttime"
)
#> with a as (
#>     with a as (
#>         with a as (
#>             select distinct cast(strleft(cast(inserttime as string),10) as timestamp) as obs_date
#>             from opd.test_pred_table
#>         )
#>         select a.obs_date, target, pred, inserttime
#>         from a
#>         left join opd.test_pred_table b
#>         on datediff(a.obs_date,inserttime) <= 7
#>     )
#>     select
#>         pred, target, inserttime, obs_date,
#>         sum(target=1) over (partition by obs_date order by obs_date, pred rows between current row and unbounded following) as tp,
#>         sum(target=0) over (partition by obs_date order by obs_date, pred rows between current row and unbounded following) as fp,
#>         sum(target=1) over (partition by obs_date order by obs_date, pred rows between unbounded preceding and 1 preceding) as fn,
#>         sum(target=0) over (partition by obs_date order by obs_date, pred rows between unbounded preceding and 1 preceding) as tn
#>     from a
#> )
#> select
#>     obs_date,
#>     max(tp/(tp+fn) - fp/(fp+tn)) as ks
#> from a
#> group by 1
#> order by obs_dateThe SQL text is on your clipboard.
```

### cat2int

``` r
library(RODBC)
impala <- odbcConnect("Impala")
```

``` r
output_cat2int <- cat2int(feature = "cyl", table = "opd.sqlsave_test_ljx")
```

``` r
output_cat2int %>% cat
#> case when cyl = '4' then 4
#>  when cyl = '6' then 6
#>  when cyl = '8' then 8 end as cyl
```

### paste\_sql\_result

``` r
library(RODBC)
impala <- odbcConnect("Impala")
```

``` r
output_paste_sql_result1 <- paste_sql_result("describe opd.sqlsave_test_ljx")
```

```` r
output_paste_sql_result1 %>% cat
#> ```sql describe opd.sqlsave_test_ljx ```   |name |type   |comment | |:----|:------|:-------| |mpg  |double |NA      | |cyl  |double |NA      | |disp |double |NA      | |hp   |double |NA      | |drat |double |NA      | |wt   |double |NA      | |qsec |double |NA      | |vs   |double |NA      | |am   |double |NA      | |gear |double |NA      | |carb |double |NA      |
````

``` r
output_paste_sql_result2 <- paste_sql_result("select * from opd.sqlsave_test_ljx limit 100")
```

```` r
output_paste_sql_result2 %>% cat
#> ```sql select * from opd.sqlsave_test_ljx limit 100 ```   |  mpg| cyl|  disp|  hp| drat|    wt| |----:|---:|-----:|---:|----:|-----:| | 15.2|   8| 275.8| 180| 3.07| 3.780| | 18.1|   6| 225.0| 105| 2.76| 3.460| | 15.0|   8| 301.0| 335| 3.54| 3.570| | 27.3|   4|  79.0|  66| 4.08| 1.935| | 30.4|   4|  95.1| 113| 3.77| 1.513| | 21.4|   4| 121.0| 109| 4.11| 2.780|
````
