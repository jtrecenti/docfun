
<!-- README.md is generated from README.Rmd. Please edit that file -->

# docfun

<!-- badges: start -->
<!-- badges: end -->

O objetivo do `{docfun}` é rodar um script de simulação no brucutu VI.
Recomendado para quem precisar de muita RAM ou quem precisar rodar
alguma coisa usando GPU.

Para instalar, rode

``` r
remotes::install_github("jtrecenti/docfun")
```

``` r
library(docfun)

brucutu_run(
  script_path = system.file("example/simulacao.R", package = "docfun"),
  data_path = system.file("example/mtcars.csv", package = "docfun")
)
```

## Observações

-   Eu fiz isso para rodar minhas simulações, então é possível
    (provável) que não funcione perfeitamente no seu caso.
-   Tentei seguir as [guidelines do
    IME](https://wiki.ime.usp.br/servicos:processamento) para fazer
    funcionar.
-   Se precisar, fique à vontade para forkar o repositório e modificar
    do jeito que funcionar melhor para você.
