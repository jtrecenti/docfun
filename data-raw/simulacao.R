#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly = TRUE)

txt <- "ola mundo!\n"
if (length(args) > 1) {
  txt <- paste0(txt, args[2], "\n")
}

cat(txt, file = args[1])
Sys.sleep(1000)
