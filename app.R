library(shiny)
library(LDAvis)

load("ldavis.RData")

server <- function(input, output) {
  output$myChart <- renderVis(LDAvis.json)
}

ui <- fluidPage(
  visOutput('myChart')
)

shinyApp(ui = ui, server = server)