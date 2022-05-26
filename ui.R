

fluidPage(
  theme = shinytheme("sandstone"),
  particles(
    config = particles_config(particles.number.value = 220,
                              particles.move.speed = 0.5,
                              interactivity.events.onclick.enable = FALSE,
                              particles.color.value = "#c7c7c7",
                              particles.line_linked.color = "#c7c7c7",
                              interactivity.events.onhover.mode = "repulse",
                              interactivity.modes.repulse.distance = 10L
                              
                              
    )
  ),
  column(width = 12,
         h1("Use of credit cards by user"),
         align = "center",
         div(style="display: inline-block;vertical-align:top;width: 340px;",
         airDatepickerInput("fecha_in", "From:", 
                            minDate = head(dates$`Date of Transaction`,1),
                            maxDate = tail(dates$`Date of Transaction`,1),
                            value = head(dates$`Date of Transaction`,1)
                            )),
         div(style="display: inline-block;vertical-align:top;width: 340px;",
             pickerInput("dayof", "Day of the week",
                         choices = unique(na.omit(df$day_of_w)),
                         multiple = TRUE,
                         selected = unique(na.omit(df$day_of_w)),
                         options = list(
                           `actions-box` = TRUE,
                           `live-search` = TRUE
                         )
             )),
         div(style="display: inline-block;vertical-align:top;width: 340px;",
             pickerInput("typeof", "Category",
                         choices = unique(na.omit(df$Category)),
                         multiple = TRUE,
                         selected = unique(na.omit(df$Category)),
                         options = list(
                           `actions-box` = TRUE,
                           `live-search` = TRUE
                         )
             )),
         div(style="display: inline-block;vertical-align:top;width: 340px;",
             pickerInput("summarise", "View data by:",
                         choices = c("day", "week","month", "bimonth","quarter", "year"),
                         multiple = FALSE,
                         selected = "month"
             ))
         
         ),
  column(width = 4,
         align= "left",
         br(),
         prettyRadioButtons(
           inputId = "metric",
           label = "Metric to show:", 
           choices = c("Purchases per day","Avg days to use the card")
         ),
         h5(strong(textOutput("texto"))),
         h5(strong(textOutput("texto2"))),
         br(),
         reactableOutput("metrica", width = 300)
         ),
  column(width = 8,
         align = "center",
         br(),
         echarts4rOutput("weekly", height = 300),
         prettyRadioButtons(
           inputId = "metric_plot",
           label = "Type of plot:", 
           inline = TRUE,
           choices = c("Number of operations","Amount of operations")
         ),
         echarts4rOutput("difference", height = 300)
         
         )
  
  
)