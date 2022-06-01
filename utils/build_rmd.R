rmarkdown::render(
  input = "setup-knitr-cache/knitr-cache.Rmd",
  output_dir = "docs/rmd/",
  output_file = "index.html",
  output_format = "html_document"
)