library(shiny)
library(LearnDC)
library(DT)

shinyServer(function(input, output, session) {
  datasetInput <- reactive({
    switch(input$level,
           "State" = GetState(input$exhibit),
           "LEA" = GetLEA(input$exhibit),
           "Sector" = GetSector(input$exhibit),
           "School" = GetSchool(input$exhibit))
  })
  
  observe({
      part_choices <- GetExhibits(input$level)
      updateSelectInput(session,"exhibit",choices=part_choices)
  })
  
  output$x1 <- DT::renderDataTable(datasetInput(), server = TRUE)
  
  output$downloadData <- downloadHandler(
    filename = function() { paste0(tolower(input$level),"_",input$exhibit,'.csv') },
    content = function(file) {
      write.csv(datasetInput(), file, row.names=FALSE)
    }
  )
})