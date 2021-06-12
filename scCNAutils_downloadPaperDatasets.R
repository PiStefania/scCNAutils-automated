# Download dataset for reproducing the results of the paper
library(fs)
options(timeout=1000)

## From SCP393
pathProjectReproduceType1 = path_home("scCNAutils-project/reproduce/reproduce-type1")
setwd(pathProjectReproduceType1)
system(
  'curl "https://singlecell.broadinstitute.org/single_cell/api/v1/search/bulk_download?accessions=SCP393&auth_code=ZXMrTJoM&directory=all"  -o cfg.txt; curl -K cfg.txt && rm cfg.txt'
)
pathProjectReproduceType1Dataset = path(pathProjectReproduceType1, "SCP393")
if(!dir.exists(pathProjectReproduceType1Dataset)) {
  stop("SCP dataset could not be downloaded.")
} else {
  message("Downloaded SCP dataset successfully.")
}

## From GEO
pathProjectReproduceType2 = path_home("scCNAutils-project/reproduce/reproduce-type2")
setwd(pathProjectReproduceType2)
download.file(url = "https://ftp.ncbi.nlm.nih.gov/geo/series/GSE131nnn/GSE131928/suppl/GSE131928_RAW.tar",
              destfile = "GSE131928_RAW.tar")
pathProjectReproduceType2Dataset = path(pathProjectReproduceType2, "GSE131928_RAW.tar")
if(!file.exists(pathProjectReproduceType2Dataset)) {
  stop("GEO dataset could not be downloaded.")
} else {
  message("Downloaded GEO dataset successfully.")
  untar("GSE131928_RAW.tar")
  unlink("GSE131928_RAW.tar")
}
