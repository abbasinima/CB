library(shiny)
library(leaflet)
#Set up ui
ui <- shinyUI(fluidPage(title="",
                        
                        #App title
 titlePanel(h3("Crime Incidents Car Theft in Boston", align="left")),
                        
                        #App layout
 sidebarLayout(position="left",
                                      
                                      #App sidePanel content and styles
sidebarPanel(h5("Yearly Crime incidents", width=2),
checkboxGroupInput(inputId="InFlags", label=h4("Select year"),
 choices=setNames(object=c("2012","2013","2014","2015","2016"),
   nm=c("2012","2013","2014","2015","2016"))),
 position="left"),
                                      
                                      #App mainPanel content and styles
 mainPanel(fluidRow(leafletOutput(outputId="lmap")))
                                      
                        )
)
)