#' Parse integer encoding for category variable in SQL
#'
#' @export
cat2int <- function(feature = 'feature', table = 'table'){

    # library all required pkgs
    library(tidyverse)

    sqlQuery(impala, glue("select distinct {feature} from {table}")) -> df

    df[,'feature2'] <- df[,feature]
    df$level <- as.integer(df[,feature])

    df %>%
        mutate(
            text = glue("when {feature} = '{feature2}' then {level}")
        ) %>%
        summarise(
            text = str_flatten(text, "\n\t")
        ) %>%
        mutate(text = glue("case {text} end as {feature}")) %>%
        mutate(text = str_replace_all(text, "= 'NA' then NA", "is NULL then NULL")) %>%
        pull -> text
    return(text)
}
