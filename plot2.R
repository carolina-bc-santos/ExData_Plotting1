#Plot2

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
Sys.setlocale("LC_TIME", "English") #So that I get the weekdays in English and not in Portuguese
newdata$Time<-strptime(newdata$Time,"%H:%M:%S")

#Order data by date
dplyr::arrange(newdata,Date)
sum(with(newdata,Date=="2007-02-01")) #There are 1440 observations from 2007-02-01
str(newdata) #There are a total of 2880 observations

#With the above information, reset the date that appears in the variable Time
newdata[1:1440,"Time"] <- format(newdata[1:1440,"Time"],"2007-02-01 %H:%M:%S")
newdata[1441:2880,"Time"] <- format(newdata[1441:2880,"Time"],"2007-02-02 %H:%M:%S")

#Convert some variables from character to numeric
names<-c("Global_active_power","Global_reactive_power","Voltage","Global_intensity","Sub_metering_1","Sub_metering_2","Sub_metering_3")
newdata[names]<-sapply(newdata[names],as.numeric)

#Plot
plot(newdata$Time,as.numeric(as.character(newdata$Global_active_power)),type="l",xlab="",ylab="Global Active Power (kilowatts)")

#Save graph as PNG fie
dev.copy(png, file = "plot2.png")
dev.off()

