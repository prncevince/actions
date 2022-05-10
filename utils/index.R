library(htmltools)
library(magrittr)
library(rvest)
library(xml2)

# saves html page to relative directory
# manually sets 'libdir' to share widget dependencies with those of rmarkdown::html_document `lib_dir` (sets same path)
# required: 
#' @param file output path of html page
# optional: 
#' @param title of HTML page
#' @param selfcontained
#' @param background color
#' @param libdir library directory - applicable if site is NOT self-contained 
#' @param ... arguments to `listSites()`
createIndex <- function(file = 'docs/index.html', title = NULL, selfcontained = FALSE, background = 'white', libdir = 'docs/libs', ...) {
  if (grepl("^#", background, perl = TRUE)) {
    bgcol <- grDevices::col2rgb(background, perl = TRUE)
    background <- sprintf(
      "rgba(%d,%d,%d,%f)", bgcol[1,1], bgcol[2,1], bgcol[3,1], bgcol[4,1]/255
    )
  }
  ###
  # here, you could create a fun page w/ css, js, etc.
  # like in widgets.R for the htmlwidget `htmlwidgets::toHTML` call
  ###
  node_doc <- minimal_html(title = title, html = tags$body())
  node_list <- listSites(...)
  node_doc %>% html_node('body') %>% xml_add_child(node_list)
  if (is.null(libdir)) {
    libdir <- paste(tools::file_path_sans_ext(basename(file)), '_files', sep = '')
    # now get creative with `libdir`
  }
  write_html(node_doc, file = file)
}

#' @param path relative path of sites
#' @param ext extension type of file names to search for
listSites <- function(path = 'docs') {
  sites <- list.files(path)
  sites <- grep("index", sites, fixed = T, invert = T, value = T) # remove index.html file
  node_doc <- read_html(as.character(tags$div(tags$ul())))
  for (i in sites) {
    doc_li_node <- read_html(as.character(tags$li(tags$a(i, href = i))))
    li_node <- doc_li_node %>% html_node('li')
    node_doc %>% html_node('ul') %>% xml_add_child(li_node)
  }
  node_list <- node_doc %>% html_node('div')
  return(node_list)
}
