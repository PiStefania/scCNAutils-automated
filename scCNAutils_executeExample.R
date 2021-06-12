# Execute pipeline in order to reproduce paper's results with the GEO dataset
library(fs)
library(scCNAutils)

pathProjectExample = path_home("scCNAutils-project/example")
prefix = "example"
setwd(pathProjectExample)
pathProjectCommonFileGenes = path(pathProjectCommonFiles, "genes.tsv")
pathProjectCommonFileCCGenes = path(pathProjectCommonFiles, "cc_genes.tsv")
pathProjectExampleSample1 = path(pathProjectExample, "SCP10/expression/Glioblastoma_expressed_genes.txt")

sample1.data.df = read.table(
  pathProjectExampleSample1,
  as.is = TRUE,
  sep = '\t',
  header = TRUE
)
names(sample1.data.df)[1] <- "symbol"

cells.df = auto_cna_signal(
  sample1.data.df,
  pathProjectCommonFileGenes,
  prefix = prefix,
  cell_cycle = pathProjectCommonFileCCGenes,
  use_cache = FALSE
)
loadPathFile = paste(prefix, '-ge-coord-norm.RData', sep = "")
load(loadPathFile)
cna.df = auto_cna_call(data, cells.df, prefix = prefix)