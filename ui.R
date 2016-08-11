library(shiny)
library(LearnDC)

shinyUI(fluidPage(
  pageWithSidebar(
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
),
 h1(fluidRow(
    column(12, div(DT::dataTableOutput('x1',width='150%',height='150%'),style = "font-size: 45%; width: 25%")))
	)))