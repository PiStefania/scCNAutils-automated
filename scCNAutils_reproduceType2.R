# Execute pipeline in order to reproduce paper's results with the GEO dataset
library(fs)
library(scCNAutils)

pathProjectCommonFiles = path_home("scCNAutils-project/common")
pathProjectReproduce = path_home("scCNAutils-project/reproduce")
prefixType2 = "reproduce-type2"
pathProjectReproduceType2 = path(pathProjectReproduce, prefixType2)
setwd(pathProjectReproduceType2)
pathProjectCommonFileGenes = path(pathProjectCommonFiles, "genes.tsv")
pathProjectCommonFileCCGenes = path(pathProjectCommonFiles, "cc_genes.tsv")
pathProjectReproduceSample1 = path(pathProjectReproduceType2, "GSM3828672_Smartseq2_GBM_IDHwt_processed_TPM.tsv.gz")
pathProjectReproduceSample2 = path(pathProjectReproduceType2, "GSM3828673_10X_GBM_IDHwt_processed_TPM.tsv.gz")

sample1.data.df = read.table(
  pathProjectReproduceSample1,
  as.is = TRUE,
  sep = '\t',
  header = TRUE
)
names(sample1.data.df)[1] <- "symbol"

sample2.data.df = read.table(
  pathProjectReproduceSample2,
  as.is = TRUE,
  sep = '\t',
  header = TRUE
)
names(sample2.data.df)[1] <- "symbol"

cells.df = auto_cna_signal(
  c(sample1.data.df, sample2.data.df),
  pathProjectCommonFileGenes,
  prefix = prefixType2,
  cell_cycle = pathProjectFileCCGenes,
  use_cache = FALSE
)
loadPathFile = paste(prefixType2, '-ge-coord-norm.RData', sep = "")
load(loadPathFile)
cna.df = auto_cna_call(data, cells.df, prefix = prefixType2)
