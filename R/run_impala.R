#' @importFrom sessioninfo os_name
#' @importFrom stringr str_detect
#' @importFrom purrr safely
connect_impala <- function(text) {
    if (!sessioninfo::os_name() %>% stringr::str_detect("Ubuntu")) {
        purrr::safely(sqlQuery)(impala, text)
    } else {
        purrr::safely(dbGetQuery)(con, text)
    }
}

#' @importFrom usethis ui_value ui_info ui_path ui_line
#' @importFrom lubridate as.period
log_heading <- function(file_path, progess_time) {
    current_time <- ui_value(Sys.time())
    file_name <- ui_path(basename(file_path))
    dir_name <- ui_path(dirname(file_path))
    spend_time <-
        progess_time %>%
        lubridate::as.period() %>%
        usethis::ui_value()

    usethis::ui_info("{file_name} runs at {current_time} and spends {spend_time}s")
    cat("\n")
    usethis::ui_line("The sql script is located at {dir_name}")
}

#' @importFrom stringr str_remove_all str_flatten
tidy_writable_result <- function(results) {
    results %>%
        unlist() %>%
        stringr::str_remove_all("^\\s+") %>%
        stringr::str_flatten("\n")
}

#' @importFrom glue glue
#' @importFrom readr read_lines write_lines
append_content <- function(results, file_path, log_path) {
    append_content <-
        glue::glue("# {basename(file_path)} {Sys.time()}\n
```sql
{results}
```")

    c(append_content, readr::read_lines(log_path)) %>% readr::write_lines(log_path)
}

#' Run impala from script
#'
#' @importFrom readr read_file
#' @importFrom usethis ui_line ui_value ui_path
#' @export

run_impala <-
    function(file_path,
             log_path = here::here("output/caiweina/running-log.md")) {
        text <- readr::read_file(file_path)

        start_time <- Sys.time()
        results <- connect_impala(text)
        end_time <- Sys.time()
        progess_time <- end_time - start_time

        log_heading(file_path, progess_time)

        usethis::ui_line("The output from impala: {ui_value(results$result)}")

        results <- tidy_writable_result(results)
        append_content(results, file_path, log_path)

        ui_line("The error log is located at: {ui_path(log_path)}")
    }
