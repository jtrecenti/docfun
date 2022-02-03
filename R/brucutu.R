brucutu_run <- function(script_path, data_path = NULL) {

  fname <- tools::file_path_sans_ext(basename(script_path))
  log_file <- paste0(fname, ".log")
  cnf <- brucutu_config()

  # sobe arquivo
  brucutu_upload(script_path, to = "~/captcha")
  remote_file <- paste0("captcha/", basename(script_path))

  cmd <- stringr::str_glue(
    "sshpass -p '{cnf$senha}' ssh {cnf$usuario}@{cnf$host_iv}",
    " ssh {cnf$usuario}@{cnf$host_vi}",
    " screen -dmS {fname} Rscript {remote_file} {log_file}"
  )

  # se o datapath não for nulo, adicionar como parametro
  if (!is.null(data_path)) {
    brucutu_upload(data_path)
    cmd <- paste(cmd, file.path(cnf$caminho_interno, data_path))
  }

  system(cmd)

}

brucutu_config <- function() {
  list(
    caminho_interno = "/var/tmp/jtrecenti",
    host = "brucutu.ime.usp.br",
    host_iv = "brucutuiv.ime.usp.br",
    host_vi = "brucutuvi.ime.usp.br",
    senha = Sys.getenv("BRUCUTU_SENHA"),
    usuario = "jtrecenti"
  )
}

#' Transfere uma pasta para /var/tmp
brucutu_upload <- function(path, to = "/var/tmp/jtrecenti", unzip = TRUE) {
  cnf <- brucutu_config()
  if (fs::is_dir(path)) {
    usethis::ui_info("zipando arquivos...")
    f <- fs::dir_ls(path, recurse = TRUE, type = "file")
    path <- stringr::str_remove(path, "/*$")
    zip_file <- paste0(path, ".zip")
    utils::zip(zip_file, f, flags = "-rq")
  } else {
    zip_file <- path
  }
  zip_file <- path.expand(zip_file)
  usethis::ui_info("subindo arquivo...")
  cmd <- stringr::str_glue(
    "sshpass -p '{cnf$senha}'",
    " scp {zip_file} {cnf$usuario}@{cnf$host_iv}:",
    "{to}/{basename(zip_file)}"
  )
  system(cmd, intern = TRUE)
}

brucutu_unzip <- function(zip_file) {
  cnf <- brucutu_config()
  remote_zip_file <- file.path(cnf$caminho_interno, basename(zip_file))
  remote_zip_folder <- tools::file_path_sans_ext(remote_zip_file)
  cmd <- stringr::str_glue(
    "sshpass -p '{cnf$senha}' ssh {cnf$usuario}@{cnf$host} ",
    "unzip -q -d {remote_zip_folder} {remote_zip_file}"
  )
  system(cmd, intern = TRUE)
}
