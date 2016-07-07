# install from github
# devtools::install_github("timelyportfolio/eventdropR")

library(eventdropR)

# make some sample data
df <- data.frame(
  # random times 30 days plus or minus current time
  date = Sys.time() + runif(1000, -30, 30) * 24 * 60 * 60,
  # make up five groups
  group = paste0("grp_", LETTERS[runif(1000,1,5)]),
  stringsAsFactors = FALSE
)

# defaults
# date argument not needed since the date is in column date
eventdrop(
  df,
  name = "group" #if df column named "name" would not need
)

# demonstrate how to set some options
eventdrop(
  df,
  name = "group",
  labelWidth = 20,
  hasBottomAxis = TRUE,
  eventHover = htmlwidgets::JS('function(d){console.log(d)}')
)

# demonstrate how to use with shiny and get events
#  can easily build this into our htmlwidget
ed <- eventdrop(
  df,
  name = "group",
  eventClick = htmlwidgets::JS(
    '
function(d){
  console.log(d);
  if(typeof(Shiny)!=="undefined") {
    Shiny.onInputChange("eventdrop_click", {data:d});
  }
}
'
  )
)

ed

# now integrate in simple shiny app
library(shiny)
shinyApp(
  ui = ed,
  server = function(input, output, session){
    observeEvent(input$eventdrop_click,{
      str(input$eventdrop_click)
    })
  }
)
