library(datasets)
library(shiny)

ui <- fluidPage(
  h2(textOutput("Current_Time")),
  titlePanel("Downloading Data"),
  sidebarLayout(
    sidebarPanel(
      selectInput("dataset", "Choose a dataset:",
                  choices = c("rock", "pressure", "cars")),
      downloadButton("downloadData", "Download")
    ),
    mainPanel(
      
      tableOutput("table")
    )
  )
)

server <- function(input, output) {
  datasetInput <- reactive({
    switch(input$dataset,
           "rock" = rock,
           "pressure" = pressure,
           "cars" = cars)
  })
  output$table <- renderTable({
    datasetInput()
  })
  
  output$Current_Time <- renderText({
    invalidateLater(1000, session)
    paste("The current time is", Sys.time())
  })
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste(input$dataset, ".csv", sep = "")
    },
    content = function(file) {
      write.csv(datasetInput(), file, row.names = FALSE)
    }
  )
}
shinyApp(ui = ui, server = server)
shiny::runApp()  
