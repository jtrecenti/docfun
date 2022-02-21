#' Roda script no Brucutu VI
#'
#' @param script_path caminho do script
#' @param data_path caminho da base de dados, se existir
#'
#' @export
brucutu_run <- function(script_path, data_path = NULL) {

  fname <- tools::file_path_sans_ext(basename(script_path))
  log_file <- paste0(fname, ".log")
  cnf <- brucutu_config()

  # sobe arquivo
  brucutu_upload(script_path, to = "~/", TRUE)
  remote_file <- basename(script_path)

  cmd <- glue::glue(
    "sshpass -p '{cnf$senha}' ssh {cnf$usuario}@{cnf$host_iv}",
    " ssh {cnf$usuario}@{cnf$host_vi}",
    " screen -dmS {fname} Rscript {remote_file} {log_file}"
  )

  # se o datapath não for nulo, adicionar como parametro
  if (!is.null(data_path)) {
    brucutu_upload(data_path)
    if (fs::is_dir(data_path)) {
      brucutu_unzip(paste0(data_path, ".zip"))
    }
    cmd <- paste(cmd, file.path(cnf$caminho_interno, basename(data_path)))
  }
  system(cmd)
  usethis::ui_done("ok! Rode 'screen -ls' no servidor para verificar se funcionou.")
}

#' Configurações para acesso ao brucutu. Melhor não mudar.
#'
#' @export
brucutu_config <- function() {
  list(
    caminho_interno = "/var/tmp",
    host = "brucutu.ime.usp.br",
    host_iv = "brucutu.ime.usp.br", # brucutuiv estava off
    host_vi = "brucutuvi.ime.usp.br",
    senha = Sys.getenv("BRUCUTU_SENHA"),
    usuario = Sys.getenv("BRUCUTU_LOGIN")
  )
}

#' Transfere uma pasta para /var/tmp
#'
#' @param path caminho da pasta/arquivo que deseja subir
#' @param to pasta de destino. Recomenda-se criar uma pasta propria
#'   em var/temp
#' @param home arquivo na home? Para uso interno.
#'
#' @export
brucutu_upload <- function(path, to = "/var/tmp", home = FALSE) {
  cnf <- brucutu_config()
  if (fs::is_dir(path)) {
    usethis::ui_info("zipando arquivos...")
    f <- fs::dir_ls(path, recurse = TRUE, type = "file")
    path <- gsub("/*$", "", path)
    zip_file <- paste0(path, ".zip")
    utils::zip(zip_file, f, flags = "-rq")
  } else {
    zip_file <- path
  }
  zip_file <- path.expand(zip_file)
  usethis::ui_info("subindo arquivo para brucutu IV...")
  cmd_iv <- glue::glue(
    "sshpass -p '{cnf$senha}'",
    " scp {zip_file} {cnf$usuario}@{cnf$host_iv}:",
    "{to}/{basename(zip_file)}"
  )
  system(cmd_iv, intern = TRUE)

  if (!home) {
    usethis::ui_info("transferindo arquivo para brucutu VI...")
    cmd_vi <- glue::glue(
      "sshpass -p '{cnf$senha}'",
      " ssh {cnf$usuario}@{cnf$host_iv}",
      " scp {to}/{basename(zip_file)} {cnf$usuario}@{cnf$host_vi}:",
      "{to}/{basename(zip_file)}"
    )
    system(cmd_vi, intern = TRUE)
  }
}

#' Dezipar arquivo que está remoto
#'
#' @param zip_file nome do arquivo. Precisa ter um arquivo
#'   com esse nome em var/tmp
#'
#' @export
brucutu_unzip <- function(zip_file) {
  cnf <- brucutu_config()
  remote_zip_file <- file.path(cnf$caminho_interno, basename(zip_file))
  remote_zip_folder <- tools::file_path_sans_ext(remote_zip_file)
  cmd <- glue::glue(
    "sshpass -p '{cnf$senha}' ssh {cnf$usuario}@{cnf$host_iv}",
    " ssh {cnf$usuario}@{cnf$host_vi}",
    " unzip -o -q -d {remote_zip_folder} {remote_zip_file}"
  )
  system(cmd, intern = TRUE)
}
