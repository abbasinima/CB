library(leaflet)
library(plyr)
library(stringr)
library(data.table)

server <- function(input, output){
    
    data1<- read.csv("Crime_Incident_Reports.csv")
    data1<-data.frame(data1)
    data1 <- data1[ -c(1,2, 4:11, 13,15:19) ]
    colnames(data1)<-c("INCIDENT_TYPE_DESCRIPTION","Year","DAY_WEEK","Location")
    data1<- subset(data1,INCIDENT_TYPE_DESCRIPTION=="AUTO THEFT")
    data2<- read.csv("Crime_Incident_Reports2.csv")
    data2<-data.frame(data2)
    data2 <- data2[ -c(1:3, 5:9,11, 13:16)  ]
    colnames(data2)<-c("INCIDENT_TYPE_DESCRIPTION","Year","DAY_WEEK","Location")
    data2<- subset(data2,INCIDENT_TYPE_DESCRIPTION=="AUTO THEFT")
    data<-rbind(data1,data2)
    
    
    data$Location<-gsub("\\(","",data$Location)
    data$Location<-gsub("\\)","",data$Location)
    list <- strsplit(as.character(data$Location), "\\,")
    
    df <- ldply(list)
    colnames(df) <- c("lat", "long")
    df$long<-str_trim(df$long)
    data$latdd<-as.numeric(df$lat)
    data$londd<-as.numeric(df$long)
    mydat<-(data[!(data$latdd==0.0 | data$londd==0.0),])
    mydat<-as.data.table(mydat)
    #mydat<-mydat[sample(nrow(mydat)),]
    #mydat<-as.data.table(mydat[1:25000,c(21,22,14)])
    #mydat<- subset(mydat,Year==2015)
    
    #Build leaflet map
    lmap <- leaflet(data=mydat)%>%
    setView(lng = -71.0589, lat = 42.3601, zoom = 12) %>%
    addTiles()
    # addProviderTiles(provider="Stamen.Toner")%>%
    # fitBounds(~min(londd), ~min(latdd), ~max(londd), ~max(latdd))
    
    #Filter data
    
    # datFilt<-reactive({
    #  if (unique(input$InFlags) == "Weekends"){
    #   test <-subset(mydat,(DAY_WEEK=="Sunday"|DAY_WEEK=="Saturday"))
    #}else if(unique(input$InFlags) == "Weekdays"){
    # test<-subset(mydat,(DAY_WEEK=="Monday" |DAY_WEEK=="Tuesday"|DAY_WEEK=="Wednesday"|DAY_WEEK=="Thursday"|DAY_WEEK=="Friday"))
    #}
    #})
    
    
    datFilt <- reactive(mydat[Year%in%input$InFlags])
    
    #Add markers based on selected flags
    observe({
        if(is.null(datFilt())) {
            print("Nothing selected")
            leafletProxy("lmap") %>% clearMarkerClusters()
        }
        else{
            print(paste0("Selected: ", unique(input$InFlags)))
            
            
            leafletProxy("lmap", data=datFilt()) %>%
            clearMarkerClusters() %>%
            addCircleMarkers(lng=~londd, lat=~latdd,
            clusterOptions=markerClusterOptions(), weight=3,
            color="#33CC33", opacity=1, fillColor="#FF9900",
            fillOpacity=0.8)
        }
    })
    output$lmap <- renderLeaflet(lmap)
}
