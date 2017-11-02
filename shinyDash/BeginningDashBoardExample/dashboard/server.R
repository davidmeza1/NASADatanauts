## dashboard server code

# set.seed(122)
# histdata <- rnorm(500)
# 
# output$plot1 <- renderPlot({
#      data <- histdata[seq_len(input$slider)]
#      hist(data)
# })

paramNames <- c("start_capital", "annual_mean_return", "annual_ret_std_dev",
                "annual_inflation", "annual_inf_std_dev", "monthly_withdrawals", "n_obs",
                "n_sim")

# Define server logic required to generate and plot a random distribution
#
# Idea and original code by Pierre Chretien
# Small updates by Michael Kapler
#
getParams <- function(prefix) {
     input[[paste0(prefix, "_recalc")]]
     
     params <- lapply(paramNames, function(p) {
          input[[paste0(prefix, "_", p)]]
     })
     names(params) <- paramNames
     params
}

# Function that generates scenarios and computes NAV. The expression
# is wrapped in a call to reactive to indicate that:
#
#  1) It is "reactive" and therefore should be automatically
#     re-executed when inputs change
#
navA <- reactive(do.call(simulate_nav, getParams("a")))
navB <- reactive(do.call(simulate_nav, getParams("b")))

# Expression that plot NAV paths. The expression
# is wrapped in a call to renderPlot to indicate that:
#
#  1) It is "reactive" and therefore should be automatically
#     re-executed when inputs change
#  2) Its output type is a plot
#
output$a_distPlot <- renderPlot({
     plot_nav(navA())
})
output$b_distPlot <- renderPlot({
     plot_nav(navB())
})