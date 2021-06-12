###########################################################################################
# Import necessary packages
library(fs)
options(timeout=1000)
###########################################################################################
# Define paths for the project
pathProject = path_home("scCNAutils-project")
pathProjectGit = path_home("scCNAutils-project/scCNAutils-master")
pathProjectReproduce = path_home("scCNAutils-project/reproduce")
pathProjectExample = path_home("scCNAutils-project/example")
pathProjectCommonFiles = path_home("scCNAutils-project/common")
###########################################################################################
# Create folders for the project
dir.create(pathProject)
dir.create(pathProjectReproduce)
dir.create(pathProjectExample)
dir.create(pathProjectCommonFiles)
###########################################################################################
# Clone git repository
setwd(pathProject)
download.file(url = "https://github.com/jmonlong/scCNAutils/archive/refs/heads/master.zip",
              destfile = "scCNAutils-master.zip")
unzip(zipfile = "scCNAutils-master.zip")
unlink("scCNAutils-master.zip")
###########################################################################################
# Download dataset for reproducing the results of the paper
pathProjectReproduceType1 = path(pathProjectReproduce + "/reproduce-type1")
pathProjectReproduceType2 = paste(pathProjectReproduce, "reproduce-type2", sep = "/")
dir.create(pathProjectReproduceType1)
dir.create(pathProjectReproduceType2)

## From SCP393
setwd(pathProjectReproduceType1)
system(
  'curl "https://singlecell.broadinstitute.org/single_cell/api/v1/search/bulk_download?accessions=SCP393&auth_code=ZXMrTJoM&directory=all"  -o cfg.txt; curl -K cfg.txt && rm cfg.txt'
)
## From GEO
setwd(pathProjectReproduceType2)
download.file(url = "https://ftp.ncbi.nlm.nih.gov/geo/series/GSE131nnn/GSE131928/suppl/GSE131928_RAW.tar",
              destfile = "GSE131928_RAW.tar")
untar("GSE131928_RAW.tar")
unlink("GSE131928_RAW.tar")
###########################################################################################
# Download another dataset to use in scCNAutils
setwd(pathProjectExample)
system(
  'curl "https://singlecell.broadinstitute.org/single_cell/api/v1/search/bulk_download?accessions=SCP10&auth_code=ON9CKpB1&directory=all"  -o cfg.txt; curl -K cfg.txt && rm cfg.txt'
)
###########################################################################################
# Download common files (cell-cycle genes and gene coordinates)
## Genes dataset
setwd(pathProjectCommonFiles)
download.file(
  'ftp://ftp.ensembl.org/pub/grch37/release-87/gtf/homo_sapiens/Homo_sapiens.GRCh37.87.gtf.gz',
  'Homo_sapiens.GRCh37.87.gtf.gz'
)
## Cell-cycle dataset
download.file(
  'https://raw.githubusercontent.com/jmonlong/scCNAutils/master/docs/cell-cycle-genes-tirosh2016.tsv',
  'cc_genes.tsv'
)

gene.df = read.table('Homo_sapiens.GRCh37.87.gtf.gz',
                     as.is = TRUE,
                     sep = '\t')
### Keep genes
gene.df = subset(gene.df, V3 == 'gene')
gene.df$symbol = gsub('.* gene_name ([^;]*);.*', '\\1', gene.df$V9)
### Format and remove duplicates
gene.df = gene.df[, c(1, 4, 5, 10)]
colnames(gene.df) = c('chr', 'start', 'end', 'symbol')
gene.df = subset(gene.df,!duplicated(symbol))
### Save
write.table(
  gene.df,
  file = 'genes.tsv',
  quote = FALSE,
  row.names = FALSE,
  sep = '\t'
)
###########################################################################################
# Execute pipeline in order to reproduce paper's results with the SCP393 dataset
library(scCNAutils)
prefix = "reproduce-type1"
pathProjectReproduceType1 = paste(pathProjectReproduce, "/", prefix, sep = "")
dir.create(pathProjectReproduceType1)
setwd(pathProjectReproduceType1)
pathProjectCommonFileGenes = pathProjectCommonFiles + "/genes.tsv"
pathProjectCommonFileCCGenes = pathProjectCommonFiles + "/cc_genes.tsv"

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
  prefix = prefix,
  cell_cycle = pathProjectCommonFileCCGenes,
  use_cache = FALSE
)
loadPathFile = paste(prefix, '-ge-coord-norm.RData', sep = "")
load(loadPathFile)
cna.df = auto_cna_call(data, cells.df, prefix = prefix)
###########################################################################################
# Execute pipeline in order to reproduce paper's results with the GEO dataset
library(scCNAutils)
prefix = "reproduce-type2"
pathProjectReproduceType2 = paste(pathProjectReproduce, "/", prefix, sep ="")
dir.create(pathProjectReproduceType2)
setwd(pathProjectReproduceType2)
pathProjectCommonFileGenes = pathProjectCommonFiles + "/genes.tsv"
pathProjectCommonFileCCGenes = pathProjectCommonFiles + "/cc_genes.tsv"
pathProjectReproduceSample1 = pathProjectReproduce + "/GSM3828672_Smartseq2_GBM_IDHwt_processed_TPM.tsv.gz"
pathProjectReproduceSample2 = pathProjectReproduce + "/GSM3828673_10X_GBM_IDHwt_processed_TPM.tsv.gz"

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
  prefix = prefix,
  cell_cycle = pathProjectFileCCGenes,
  use_cache = FALSE
)
loadPathFile = paste(prefix, '-ge-coord-norm.RData', sep = "")
load(loadPathFile)
cna.df = auto_cna_call(data, cells.df, prefix = prefix)
###########################################################################################
# Execute pipeline in order to reproduce paper's results with the GEO dataset
library(scCNAutils)
prefix = "example"
setwd(pathProjectExample)
pathProjectCommonFileGenes = pathProjectCommonFiles + "/genes.tsv"
pathProjectCommonFileCCGenes = pathProjectCommonFiles + "/cc_genes.tsv"
pathProjectExampleSample1 = pathProjectExample + "/SCP10/expression/Glioblastoma_expressed_genes.txt"

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
###########################################################################################
# Clone our version of the git repository
setwd(pathProject)
download.file(url = "https://github.com/PiStefania/scCNAutils/archive/refs/heads/master.zip",
              destfile = "scCNAutils-ourversion-master.zip")
unzip(zipfile = "scCNAutils-ourversion-master.zip")
unlink("scCNAutils-ourversion-master.zip")
###########################################################################################
# Use our version of the git repository
pathProjectGitOurVersion = pathProject + "scCNAutils-ourversion-master"
setwd(pathProjectGitOurVersion)
devtools::install()
###########################################################################################
# Use the original version of the git repository
pathProjectGitOriginalVersion = pathProject + "scCNAutils-master"
setwd(pathProjectGitOriginalVersion)
devtools::install()
