


function(input, output){
  
  output$metrica <- renderReactable({
    
    if (input$metric == "Purchases per day"){
      
      df |> 
        filter(
          `Date of Transaction` > input$fecha_in
          & day_of_w %in% input$dayof
          & Category %in% input$typeof
        ) |> 
        group_by(
          `User ID`, day_of_w
        ) |> 
        summarise(
          n = n()
        ) |> 
        reactable(
          theme = reactableTheme(backgroundColor = "transparent"),
          compact = TRUE,
          highlight = TRUE,
          defaultSorted = "n",
          defaultSortOrder = 'desc',
          language = reactableLang(
            searchPlaceholder = "Buscar datos",
            noData = "Sin datos registrados",
            pageInfo = "{rowStart}\u2013{rowEnd} de {rows} observaciones",
            pagePrevious = "\u276e",
            pageNext = "\u276f",
          ),
          columns = list(
            n = colDef(name = "Number of purchases"#,
                       #cell = data_bars(x)
            ), 
            day_of_w = colDef(name = "Day of the week")
          )
        ) 
      
      
    }else{
      
      df |> 
        filter(
          `Date of Transaction` > input$fecha_in
          & day_of_w %in% input$dayof
          & Category %in% input$typeof
        ) |> 
        arrange(`Date of Transaction`) |> 
        group_by(
          `User ID`
        ) |> 
        slice(head(row_number(), 2)) |> 
        summarise(
          date_dif = as.Date(`Date of Transaction`)- lag(as.Date(`Date of Transaction`))
        ) |> 
        slice(tail(row_number(), 1)) |> 
        mutate(days = paste(as.character(date_dif), "days")) |> 
        select(`User ID`, days) |> 
        reactable(
          theme = reactableTheme(backgroundColor = "transparent"),
          compact = TRUE,
          highlight = TRUE,
          defaultSortOrder = 'desc',
          language = reactableLang(
            searchPlaceholder = "Buscar datos",
            noData = "Sin datos registrados",
            pageInfo = "{rowStart}\u2013{rowEnd} de {rows} observaciones",
            pagePrevious = "\u276e",
            pageNext = "\u276f",
          ),
          columns = list(
            days = colDef(name = "Days to use a credit card"#,
                          #cell = data_bars(x)
            )
          )
        ) 
      
      
      
    }
    
    
    
  })
  
  
  output$texto <- renderText({
    
    
    texto <- if_else(
      input$metric == "Purchases per day",
      "Purchases per user per day of the week",
      "Avg time to the first purchase after card activation"
    )
    
    texto
    
  })
  
  
  output$texto2 <- renderText({
    
    x <- 
      df |> 
      filter(
        `Date of Transaction` > input$fecha_in
        #& day_of_w %in% input$dayof
        & Category %in% input$typeof
      ) |> 
      arrange(`Date of Transaction`) |> 
      group_by(
        `User ID`
      ) |> 
      slice(head(row_number(), 2)) |> 
      summarise(
        date_dif = as.Date(`Date of Transaction`)- lag(as.Date(`Date of Transaction`))
      ) |> 
      slice(tail(row_number(), 1)) |> 
      mutate(
        val = as.numeric(date_dif)
      ) |>
      ungroup() |> 
      summarise(
        x = mean(val, na.rm =TRUE)
      )
    
    if_else(input$metric == "Purchases per day",
            "",
            paste0("Global avg: ", round(x$x, digits = 2), " days")
            )
    
  })
  
  
  output$weekly <- renderEcharts4r({
    
    
    df |> 
      filter(
        `Date of Transaction` > input$fecha_in
        & Category %in% input$typeof
      ) |> 
      group_by(day_of_w) |> 
      summarise(
        monto = mean(`Amount of Transaction`, na.rm = TRUE)
      ) |> 
      e_charts(day_of_w) |> 
      e_bar(monto, name = "Avg amount") |> 
      e_tooltip(trigger = "axis") |> 
      e_legend(FALSE) |> 
      e_theme("auritus") |> 
      e_title("Avg amount by day of the week", left = "center")
    
    
  })
  
  
  output$difference <- renderEcharts4r({
    
    x <- df
    x$`Date of Transaction` <- floor_date(x$`Date of Transaction`, input$summarise)
    
    
    if (input$metric_plot == "Number of operations"){
      
      x |> 
        filter(
          `Date of Transaction` > input$fecha_in
          & day_of_w %in% input$dayof
          & Category %in% input$typeof
        ) |> 
        group_by(`Date of Transaction`) |> 
        summarise(
          n = n()
        ) |> 
        mutate(
          diff_n = n-lag(n),
          color = if_else(diff_n >0,"#5a9441","#9e3c3c" )
        ) |> 
        e_charts(`Date of Transaction`, dispose = FALSE) |> 
        e_bar(diff_n, name = "Change (number of ops)") |> 
        e_theme("auritus") |> 
        e_add("itemStyle",color) |> 
        e_tooltip(trigger = "axis") |> 
        e_legend(FALSE) |> 
        e_title(paste0("change in operations by ", input$summarise), left = "center")
      
    }else{
      
      x |> 
        filter(
          `Date of Transaction` > input$fecha_in
          & day_of_w %in% input$dayof
          & Category %in% input$typeof
        ) |> 
        group_by(`Date of Transaction`) |> 
        summarise(
          amount = sum(`Amount of Transaction`, na.rm = TRUE)
        ) |> 
        mutate(
          diff_amount = amount - lag(amount),
          color = if_else(diff_amount >0,"#5a9441","#9e3c3c" )
        ) |> 
        e_charts(`Date of Transaction`, dispose = FALSE) |> 
        e_bar(diff_amount,name = "Change (amount by transaction)" ) |> 
        e_theme("auritus") |> 
        e_add("itemStyle",color) |> 
        e_tooltip(trigger = "axis") |> 
        e_legend(FALSE) |> 
        e_title(paste0("change in amount by ", input$summarise), left = "center")
      
    }
    
    
    
    
    
  })
  
  
}



