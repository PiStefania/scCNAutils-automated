# Define paths for the project
library(fs)

pathProject = path_home("scCNAutils-project")
pathProjectGit = path_home("scCNAutils-project/scCNAutils-master")
pathProjectReproduce = path_home("scCNAutils-project/reproduce")
pathProjectExample = path_home("scCNAutils-project/example")
pathProjectCommonFiles = path_home("scCNAutils-project/common")
prefixType1 = "reproduce-type1"
prefixType2 = "reproduce-type2"
pathProjectReproduceType1 = path(pathProjectReproduce, prefixType1)
pathProjectReproduceType2 = path(pathProjectReproduce, prefixType2)

# Create folders for the project
dir.create(pathProject)
dir.create(pathProjectReproduce)
dir.create(pathProjectExample)
dir.create(pathProjectCommonFiles)
dir.create(pathProjectReproduceType1)
dir.create(pathProjectReproduceType2)