# Download common files (cell-cycle genes and gene coordinates)
library(fs)
options(timeout=1000)
## Genes dataset
pathProjectCommonFiles = path_home("scCNAutils-project/common")
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