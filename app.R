# app.R – Shiny interface for NUMDEFECTS prediction

library(shiny)
library(png)
library(grid)

model <- readRDS("defect_model.rds")
predictors <- names(model$coefficients)[-1]

ui <- fluidPage(
  titlePanel("KC1 – Software Defect Prediction"),
  sidebarLayout(
    sidebarPanel(
      helpText("Insira os valores das métricas abaixo:"),
      lapply(predictors, function(p){
        numericInput(p, label = p, value = NA)
      }),
      actionButton("go", "Prever NUMDEFECTS", class = "btn-primary")
    ),
    mainPanel(
      h4("Previsão:"),
      verbatimTextOutput("pred"),
      hr(),
      tabsetPanel(
        tabPanel("Correlação", imageOutput("corr")),
        tabPanel("Resíduos", imageOutput("resid"))
      )
    )
  )
)

server <- function(input, output, session){

  observeEvent(input$go, {
    vals <- sapply(predictors, function(p) input[[p]])
    newdata <- as.data.frame(as.list(vals))
    names(newdata) <- predictors

    pred <- predict(model, newdata = newdata)
    output$pred <- renderPrint(round(pred, 2))
  })

  output$corr <- renderImage({
    list(src = "correlation_matrix.png", contentType = "image/png",
         width = 600, height = 600)
  }, deleteFile = FALSE)

  output$resid <- renderImage({
    list(src = "residual_plots.png", contentType = "image/png",
         width = 600, height = 600)
  }, deleteFile = FALSE)
}

shinyApp(ui, server)
