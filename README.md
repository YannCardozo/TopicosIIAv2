# KC1 Defect Prediction Project

This repository contains the full workflow for analysing the KC1_classlevel_numdefect dataset, building a regression model to predict software defects, exposing it via a REST API, and wrapping everything in an interactive Shiny application.

## Structure
- **analysis.R** – Generates descriptive statistics, correlations, builds the regression model, and saves `defect_model.rds` plus plots.
- **plumber.R** – A **plumber** API exposing `/ping` and `/predict` endpoints.
- **app.R** – A **Shiny** app that lets the user enter metric values and get a prediction, plus view analysis plots.
- `descriptive_plots.pdf`, `scatter_plots.pdf`, `correlation_matrix.png`, `residual_plots.png` – Produced after you run *analysis.R*.
- `defect_model.rds` – Regression model saved by *analysis.R* (must exist for the API and Shiny to run).

## Quick Start

1. Place **KC1_classlevel_numdefect.xlsx** in this folder.
2. Open **analysis.R** in RStudio and run it (`Ctrl+Shift+S`) to install missing packages and generate the model.
3. Start the API locally:

   ```R
   library(plumber)
   pr <- plumb("plumber.R")
   pr$run(host = "0.0.0.0", port = 8000)
   ```

   Test:  
   ```bash
   curl -X POST http://localhost:8000/predict \
        -H "Content-Type: application/json" \
        -d '{"CouplingBetweenObjects":3,"DepthInheritance":2,"Cohesion":0.33}'
   ```

4. Run the Shiny app:

   ```R
   shiny::runApp("app.R")
   ```

5. Deploy to **shinyapps.io**:
   - Install the `rsconnect` package.
   - `rsconnect::setAccountInfo(name="<your_user>", token="<TOKEN>", secret="<SECRET>")`
   - `rsconnect::deployApp(appDir = ".", appName = "kc1-defect-predictor")`

Enjoy!

---
*Generated automatically on 2025‑07‑01*
