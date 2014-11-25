library(shiny)

nyc.choices = as.character(read.csv("data\\nyc.choices.csv")[,1])

shinyUI(fluidPage(
  titlePanel("Where is the Best Place to Live in New York City?"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Need help determining where to live in NYC?  This map will show you where the most 311 complaints are coming from."),
      
      selectInput("var", 
        label = "Choose a Complaint type:",
        choices = c(nyc.choices),
        selected = nyc.choices[1]),
      
      helpText("The map displays 311 complaints by precinct.  You do not to live in the dark areas!"),
      
      submitButton("Update Map")
      
    ),
    
    mainPanel(
      textOutput("text.output"),
      br(),
	  plotOutput("map", height="600px", width="700px")
    )

  )
))
