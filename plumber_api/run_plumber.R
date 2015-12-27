library(devtools)
install_github("trestletech/plumber")
library(plumber)

r <- plumb("")
r$run(port=8000)
