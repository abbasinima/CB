read.csv("yelpp.csv")
require(ggplot2)
qplot(name, jan_frac, data=yelp_hotel)+theme(axis.text.x = element_text(angle = 90, hjust = 1))+labs(title = "ratio of review over total guests",x="Hotel name",y="fraction")+geom_point(size=5, colour="#CC0000") 
qplot(name, counter, data=yelp_hotel)+theme(axis.text.x = element_text(angle = 90, hjust = 1))+labs(title = "Total number of guests",x="Hotel name",y="fraction")+geom_point(size=5, colour="#CC0000") 
