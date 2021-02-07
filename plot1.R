#Plot1

# Download dataset
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

# Unzip dataset
unzip(zipfile="./data/Dataset.zip",exdir="./data")

#Read the data
data<-read.table("./data/household_power_consumption.txt",header=TRUE,sep=";")

#Subset data from the dates 2007-02-01 and 2007-02-02
newdata<-subset(data,Date=="1/2/2007" | Date=="2/2/2007")

#Load required packages
library(graphics)
library(grDevices)
library(dplyr)

#Convert variable Date from character to Date
newdata$Date<-as.Date(newdata$Date,"%d/%m/%Y")

#Convert variable Time from character to Time
newdata$Time<-strptime(newdata$Time,tz="CET","%H:%M:%S")

#Convert some variables from character to numeric
names<-c("Global_active_power","Global_reactive_power","Voltage","Global_intensity","Sub_metering_1","Sub_metering_2","Sub_metering_3")
newdata[names]<-sapply(newdata[names],as.numeric)

#Histogram
hist(newdata$Global_active_power,main=paste("Global Active Power"),xlab=paste("Global Active Power (kilowatts)"),col="red")

#Save graph as PNG fie
dev.copy(png, file = "plot1.png")
dev.off()


