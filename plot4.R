#Plot 4

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

#Open png file
png(filename="plot4.png",
    width=520,height=480)

#Plot
par(mfrow=c(2,2),mar = c(4, 4, 2, 1),oma = c(0, 0, 0, 0))
with(newdata,{
  plot(newdata$Time,as.numeric(as.character(newdata$Global_active_power)),type="l",xlab="",ylab="Global Active Power (kilowatts)")
  plot(newdata$Time,newdata$Voltage,xlab="datetime",type="l",ylab="Voltage")
  plot(newdata$Time,Sub_metering_1,xlab="",ylab="Energy sub metering",type="n")
  lines(newdata$Time,Sub_metering_1,type="l")
  lines(newdata$Time,Sub_metering_2,type="l",col="red")
  lines(newdata$Time,Sub_metering_3,type="l",col="blue")
  legend("topright",bty="n",lty=c(1,1,1),col=c("black","red","blue"),legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
  plot(newdata$Time,newdata$Global_reactive_power,type="l",ylab="Global_reactive_power",xlab="datetime")
  })


dev.off()














