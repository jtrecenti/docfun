
<!-- README.md is generated from README.Rmd. Please edit that file -->

# docfun

<!-- badges: start -->
<!-- badges: end -->

O objetivo do `{docfun}` é rodar um script de simulação no brucutu VI.
Recomendado para quem precisar de muita RAM ou quem precisar rodar
alguma coisa usando GPU.

``` r
library(docfun)

brucutu_run(
  script_path = system.file("example/simulacao.R", package = "docfun"),
  data_path = system.file("example/mtcars.csv", package = "docfun")
)
```
