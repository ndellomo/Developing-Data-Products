library(shiny)
library(dplyr)
library(ggplot2)
library(RColorBrewer)

nyc.data = read.csv("data\\AllDataMerge v2.csv")
nypp.geo  = read.csv("data\\nypp_Rgeo.csv")


shinyServer(
  function(input, output) {
    output$text.output = renderText({ 
      paste("You have selected complaints relating to", input$var, "in NYC.")
    })
	subsetDate = reactive({
            
            myCols <- gsub(" ",".",input$var)
            colNums <- match(myCols, names(nyc.data))
            nyc.select <- nyc.data %>% 
                  select(WA2_PolicePrecinct,colNums)
            
            names(nyc.select) <- c("WA2_PolicePrecinct","var1")
      
            nyc.agg = nyc.select %>%
                  group_by(WA2_PolicePrecinct) %>%
                  summarise (sum = sum(var1))
            
            nyc.map = merge(nypp.geo, nyc.agg, by.x="id", by.y="WA2_PolicePrecinct")
	})

	output$map = renderPlot({
	  this.subset  = subsetDate()
	
	  g1 = ggplot(this.subset, aes(x=long, y=lat)) +
              geom_polygon(aes(group = group, fill=sum), color = "gray40", size = 0.6) + 
              scale_fill_gradientn(colours=brewer.pal(7,"BuGn"),name="Total Number\nof Complaints") + 
              theme(axis.line = element_blank(), 
                    panel.grid=element_blank(), 
                    axis.ticks.y = element_blank(),
                    axis.ticks.x = element_blank(),
                    axis.title.y = element_blank(),
                    axis.title.x = element_blank(),
                    axis.text.y = element_blank(),
                    axis.text.x = element_blank(),
                    rect = element_blank()) + 
              labs(title = paste(input$var, "NYPD Precincts"))
	  
	  print(g1)
        
	})
	
  }
)