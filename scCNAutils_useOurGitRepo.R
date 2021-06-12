# Clone our version of the git repository
pathProject = path_home("scCNAutils-project")
setwd(pathProject)
download.file(url = "https://github.com/PiStefania/scCNAutils/archive/refs/heads/master.zip",
              destfile = "scCNAutils-ourversion-master.zip")
unzip(zipfile = "scCNAutils-ourversion-master.zip")
unlink("scCNAutils-ourversion-master.zip")
# Use our version of the git repository
pathProjectGitOurVersion = path(pathProject, "scCNAutils-master")
setwd(pathProjectGitOurVersion)
devtools::install()