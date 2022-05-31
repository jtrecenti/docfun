#' Encontra melhor modelo da simulação
#'
#' Encontra melhor modelo partir de uma pasta com arquivos de logs. Função a ser
#'   utilizada internamente no meu doutorado.
#'
#' @param path pasta que contém arquivos de log dos resultados dos modelos
#'
#' @export
encontrar_melhor_modelo <- function(path) {
  path |>
    fs::dir_ls(regexp = "model_[0-9]+\\.log") |>
    purrr::map_dfr(readr::read_csv, show_col_types = FALSE, .id = "file") |>
    dplyr::filter(set == "valid") |>
    dplyr::arrange(dplyr::desc(epoch)) |>
    dplyr::distinct(file, .keep_all = TRUE) |>
    dplyr::slice_max(captcha.acc, n = 1, with_ties = FALSE) |>
    dplyr::mutate(file = fs::path_ext_set(file, ".pt"))
}
