# Clone git repository
library(fs)
pathProject = path_home("scCNAutils-project")
options(timeout=1000)
setwd(pathProject)
download.file(url = "https://github.com/jmonlong/scCNAutils/archive/refs/heads/master.zip",
              destfile = "scCNAutils-master.zip")
unzip(zipfile = "scCNAutils-master.zip")
unlink("scCNAutils-master.zip")
# Use the original version of the git repository
pathProjectGitOriginalVersion = path(pathProject, "scCNAutils-master")
setwd(pathProjectGitOriginalVersion)
devtools::install()