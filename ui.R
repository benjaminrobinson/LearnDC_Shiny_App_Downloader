options(stringsAsFactors=FALSE)
library(shiny)
library(LearnDC)

shinyUI(pageWithSidebar(
  headerPanel('LearnDC Downloader'),
  sidebarPanel(
    selectInput("level", "Choose a level:", 
                choices = c('School','LEA','Sector','State')),
    selectInput("exhibit", "Choose an exhibit:",
                choices = GetExhibits("school")),
    downloadButton('downloadData', 'Download')
  ),
  mainPanel(
    img(src='logo.png', align = "lower left")
  )
))
