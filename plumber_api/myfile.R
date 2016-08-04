# myfile.R
options(stringsAsFactors=FALSE)
if(!require(jsonlite)){
  install.packages("jsonlite")
  library(jsonlite)
}

if(!require(devtools)){
  install.packages("devtools")
  library(devtools)
}

if(!require(LearnDC)){
  install.packages("LearnDC")
  library(LearnDC)
}


#* @get /school
GetSchool()


#* @get /lea
GetLEA()


#* @get /sector
GetSector()


#* @get /state
GetState()


#* @get /exhibits
GetExhibits()