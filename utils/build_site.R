source('utils/index.R')

file <- commandArgs(trailingOnly = T)[1]
path <- commandArgs(trailingOnly = T)[2]

createIndex(
  file = file, path = path,
  title='Pages of GitHub Actions'
)