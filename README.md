# scCNAutils-automated
Machine Learning and Computational Biology Project

# Purpose
This github repository was created to amend the process of executing the [jmonlong/scCNAutils repository](https://github.com/jmonlong/scCNAutils).
In addition, we have forked his repository and made some changes, fixing some bugs regarding the dplyr package.

# Execution
The execution of the R scripts can be done serially:
1. `scCNAutils_createFolders.R`
2. download datasets and files: \
  a. `scCNAutils_downloadCommonFiles.R` \
  b. `scCNAutils_downloadExampleDataset.R` \
  c. `scCNAutils_downloadPaperDatasets.R`
3. use either the original implementation of scCNAutils or our implementation: \
`scCNAutils_useOriginalGitRepo.R` or `scCNAutils_useOurGitRepo.R`
4. execute scCNAutils pipeline according to your needs: \
  a. `scCNAutils_reproduceType1.R` \
  b. `scCNAutils_reproduceType2.R` \
  c. `scCNAutils_executeExample.R`
  
 # Comments
 - Reproducing the paper can be done with two types/methods as described above, either with type 1 or type 2. The results are the same, the only difference is that type 1 takes as input the folders of the samples and a gene expression matrix whereas type 2 takes as input two gene expression matrices. 
 - In script `scCNAutils_downloadExampleDataset.R` and in `scCNAutils_downloadPaperDatasets.R`, the curl for downloading the datasets should be changed, because the curl produced by SCP site has a 30minute duration.
