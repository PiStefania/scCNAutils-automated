# Download another dataset to use in scCNAutils
library(fs)
pathProjectExample = path_home("scCNAutils-project/example")
setwd(pathProjectExample)
system(
  'curl "https://singlecell.broadinstitute.org/single_cell/api/v1/search/bulk_download?accessions=SCP10&auth_code=ON9CKpB1&directory=all"  -o cfg.txt; curl -K cfg.txt && rm cfg.txt'
)
pathProjectExampleDataset = path(pathProjectExample, "SCP10")
if(!dir.exists(pathProjectExampleDataset)) {
  stop("Example dataset could not be downloaded.")
} else {
  message("Downloaded example dataset successfully.")
}
