library(dplyr)
library(zoo)
library(shiny)
library(rpart)

data1<- read.csv("mammographic.dat", header = FALSE, sep= "," , skip = 10, na.strings = "?")
colnames(data1)<- c("BIRADS", "Age", "Shape", "Margin", "Density", "Severity")
data1$BIRADS<-as.numeric(data1$BIRADS)
data1$Age<-as.numeric(data1$Age)
data1$Shape<- as.numeric(data1$Shape)
data1$Margin<- as.numeric(data1$Margin)
data1$Density <-  as.numeric(data1$Density)
data1<- na.aggregate(data1, FUN= median)
model <- glm(Severity~BIRADS+Age+Shape+Margin+Density, data = data1, family = "binomial")
#model<- rpart(Severity~BIRADS+Age+Shape+Margin+Density, data = data1, method ="class")

data2<- unique(data1[,1:5])

rakPred<- function (BIRADS, Age, Shape, Margin, Density) {
  prediction <- data.frame(as.numeric(BIRADS), as.numeric(Age), as.numeric(Shape), as.numeric(Margin), as.numeric(Density))
  names(prediction)<- names(data2)
  pred<- predict.glm(model, newdata = prediction, type= "response")
  #pred<- predict(model, newdata = prediction, type= "class")
  
  pred[[1]]
  #pred
  
}
  

library(shiny)
shinyServer(
  function(input, output) {
    output$text1 <- renderText({input$input_BIRADS})
    output$text2 <- renderText({input$input_Shape})
    output$text3 <- renderText({input$input_Margin})
    output$text4 <- renderText({input$input_Density})
    output$text5 <- renderText({input$input_Age})
    
    output$text6 <- renderText({
      input$goButton
      if (input$goButton == 0) ""
      else
        isolate(paste("BI-RADS score: " , input$input_BIRADS,", ", "Shape: " , input$input_Shape,", ", "Margin: ", input$input_Margin,", ", "Density: " ,input$input_Density,", ","Age: " , input$input_Age))
    })
    output$text7 <- renderText({
      input$goButton
      if (input$goButton == 0) ""
      else 
        paste(round(rakPred(input$input_BIRADS,input$input_Age,input$input_Shape , input$input_Margin, input$input_Density)*100,digits=1),"%",sep="")})  
       # paste(rakPred(input$input_BIRADS,input$input_Age,input$input_Shape , input$input_Margin, input$input_Density))}) 
    
  }
  
)
