# Execute pipeline in order to reproduce paper's results with the SCP393 dataset
library(fs)
library(scCNAutils)

pathProjectCommonFiles = path_home("scCNAutils-project/common")
pathProjectReproduce = path_home("scCNAutils-project/reproduce")
prefixType1 = "reproduce-type1"
pathProjectReproduceType1 = path(pathProjectReproduce, prefixType1)
setwd(pathProjectReproduceType1)
pathProjectCommonFileGenes = path(pathProjectCommonFiles, "/genes.tsv")
pathProjectCommonFileCCGenes = path(pathProjectCommonFiles, "cc_genes.tsv")

scpFolder = path(pathProjectReproduceType1 + "/SCP393")
scpCopyFolder = path(pathProjectReproduceType1 + "/SCP393-copy")
dir.create(scpCopyFolder)
dir.create(scpCopyFolder + "/expression")
dir.create(scpCopyFolder + "/expression/5e16df92771a5b0eb30ca010")
dir.create(scpCopyFolder + "/expression/5e16dae3771a5b0eb30c9ff8")

file.copy(pathProjectReproduceType1 + "/SCP393/expression/5e16df92771a5b0eb30ca010/cells1.proc.tsv", pathProjectReproduceType1 + "/SCP393-copy/expression/5e16df92771a5b0eb30ca010/")
file.copy(pathProjectReproduceType1 + "/SCP393/expression/5e16df92771a5b0eb30ca010/genes1.tsv", pathProjectReproduceType1 + "/SCP393-copy/expression/5e16df92771a5b0eb30ca010")
file.copy(pathProjectReproduceType1 + "/SCP393/expression/5e16df92771a5b0eb30ca010/IDHwtGBM.processed.10X.counts.mtx", pathProjectReproduceType1 + "/SCP393-copy/expression/5e16df92771a5b0eb30ca010")
file.copy(pathProjectReproduceType1 + "/SCP393/expression/5e16dae3771a5b0eb30c9ff8/cells2.proc.tsv", pathProjectReproduceType1 + "/SCP393-copy/expression/5e16dae3771a5b0eb30c9ff8")
file.copy(pathProjectReproduceType1 + "/SCP393/expression/5e16dae3771a5b0eb30c9ff8/genes2.tsv", pathProjectReproduceType1 + "/SCP393-copy/expression/5e16dae3771a5b0eb30c9ff8")
file.copy(pathProjectReproduceType1 + "/SCP393/expression/5e16dae3771a5b0eb30c9ff8/IDHwtGBM.processed.10X.counts.2.mtx", pathProjectReproduceType1 + "/SCP393-copy/expression/5e16dae3771a5b0eb30c9ff8")

file.rename(pathProjectReproduceType1 + "/SCP393/expression/5e16df92771a5b0eb30ca010/cells1.proc.tsv", pathProjectReproduceType1 + "/SCP393-copy/expression/5e16df92771a5b0eb30ca010/barcodes.tsv")
file.rename(pathProjectReproduceType1 + "/SCP393/expression/5e16df92771a5b0eb30ca010/genes1.tsv", pathProjectReproduceType1 + "/SCP393-copy/expression/5e16df92771a5b0eb30ca010/genes.tsv")
file.rename(pathProjectReproduceType1 + "/SCP393/expression/5e16df92771a5b0eb30ca010/IDHwtGBM.processed.10X.counts.mtx", pathProjectReproduceType1 + "/SCP393-copy/expression/5e16df92771a5b0eb30ca010/matrix.mtx")
file.rename(pathProjectReproduceType1 + "/SCP393/expression/5e16dae3771a5b0eb30c9ff8/cells2.proc.tsv", pathProjectReproduceType1 + "/SCP393-copy/expression/5e16dae3771a5b0eb30c9ff8/barcodes.tsv")
file.rename(pathProjectReproduceType1 + "/SCP393/expression/5e16dae3771a5b0eb30c9ff8/genes2.tsv", pathProjectReproduceType1 + "/SCP393-copy/expression/5e16dae3771a5b0eb30c9ff8/genes.tsv")
file.rename(pathProjectReproduceType1 + "/SCP393/expression/5e16dae3771a5b0eb30c9ff8/IDHwtGBM.processed.10X.counts.2.mtx", pathProjectReproduceType1 + "/SCP393-copy/expression/5e16dae3771a5b0eb30c9ff8/matrix.mtx")

pathProjectReproduceSample1 = pathProjectReproduceType1 + "/SCP393-copy/expression/5e16df92771a5b0eb30ca010"
pathProjectReproduceSample2 = pathProjectReproduceType1 + "/SCP393-copy/expression/5e16dae3771a5b0eb30c9ff8"
pathProjectReproduceSample3 = pathProjectReproduceType1 + "/SCP393/expression/IDHwtGBM.processed.SS2.logTPM.txt.gz"

sample3.data.df = read.table(
  pathProjectReproduceSample3,
  as.is = TRUE,
  sep = '\t',
  header = TRUE
)
names(sample3.data.df)[1] <- "symbol"

cells.df = auto_cna_signal(
  c(pathProjectReproduceSample1, pathProjectReproduceSample2, sample3.data.df),
  pathProjectCommonFileGenes,
  prefix = prefixType1,
  cell_cycle = pathProjectCommonFileCCGenes,
  use_cache = FALSE
)
loadPathFile = paste(prefixType1, '-ge-coord-norm.RData', sep = "")
load(loadPathFile)
cna.df = auto_cna_call(data, cells.df, prefix = prefixType1)
