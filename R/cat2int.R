#' Parse integer encoding for category variable in SQL
#'
#' @param feature Feature name.
#' @param table data.frame.
#' @export
#' @examples
#' \dontrun{library(RODBC)}
#' \dontrun{impala <- odbcConnect("Impala")}
#' \dontrun{output_cat2int <- cat2int(feature = "cyl", table = "opd.sqlsave_test_ljx")}

cat2int <- function(feature = 'feature', table = 'table'){

    # library all required pkgs
    # library(tidyverse)
    impala <- RODBC::odbcConnect("Impala")
    RODBC::sqlQuery(impala, glue::glue("select distinct {feature} from {table} order by {feature}")) -> df

    df[,'feature2'] <- df[,feature]
    df$level <- as.integer(df[,feature])

    df %>%
        dplyr::mutate(
            text = glue::glue("when {feature} = '{feature2}' then {level}")
        ) %>%
        dplyr::summarise(
            text = str_flatten(text, "\n\t")
        ) %>%
        dplyr::mutate(text = glue::glue("case {text} end as {feature}")) %>%
        dplyr::mutate(text = stringr::str_replace_all(text, "= 'NA' then NA", "is NULL then NULL")) %>%
        dplyr::pull() -> text
    return(text)
}
