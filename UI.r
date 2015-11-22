library(zoo)

require(markdown)

data1<- read.csv("mammographic.dat", header = FALSE, sep= "," , skip = 10, na.strings = "?")
colnames(data1)<- c("BIRADS", "Age", "Shape", "Margin", "Density", "Severity")
data1$BIRADS<-as.numeric(data1$BIRADS)
data1$Age<-as.numeric(data1$Age)
data1$Shape<- as.numeric(data1$Shape)
data1$Margin<- as.numeric(data1$Margin)
data1$Density <-  as.numeric(data1$Density)
data1<- na.aggregate(data1, FUN= median)
data2<- unique(data1[,1:5])



library(shiny)

shinyUI(
  
  navbarPage("Breast Cancer Severity Probability Calculation",
             tabPanel("Application",
                      pageWithSidebar(
                        headerPanel(h3("What is the probability of sever breast cancer?")),
                        sidebarPanel(
                          radioButtons(inputId="input_BIRADS", label="Choose the patient's BI-RADS score", choices= levels(as.factor(data2$BIRADS)), inline= T),
                          radioButtons(inputId="input_Shape", label="Choose the mass Shape", choices= levels(as.factor(data2$Shape)), inline= T),
                          radioButtons(inputId="input_Margin", label="Choose the mass Margin", choices= levels(as.factor(data2$Margin)), inline= T),
                          radioButtons(inputId="input_Density", label="Choose the mass Density", choices= levels(as.factor(data2$BIRADS)), inline= T),
                          selectInput(inputId = "input_Age", label = "Choose the patient's Age", choices = setNames(as.list(unique(data2$Age)),unique(data2$Age)),
                                      selected = unique(data2$Age)[[1]], selectize = T, width = '200px'),
                          actionButton("goButton", "Calculate the probabibilty of severe breast cancer"), width = 5
                          
                        ), 
                        
                        mainPanel(
                          h4('Your selection:'),
                          textOutput('text6'),
                          h4('Percentage chance of malignant breast cancer:'),
                          textOutput('text7')
                        )
                      )
             )
             ,tabPanel("About", includeHTML("about.html"))
  )
)