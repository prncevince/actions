# this is hard to run in the Makefile - needs to be ran in a very specific order 
# `usethis::create_package` is typically ran outside of RStudio Project 
# may not be robust enough to run inside of existing project

# usethis::create_package(path = 'actions')
usethis::create_package(path = '.')
usethis::use_pkgdown(destdir = "docs/pkgdown/")