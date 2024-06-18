<<<<<<< HEAD

# Loading all the necessary packages for the analysis

library(tidyverse)
library(lubridate)
library(janitor)
library(ggplot2)
library(dplyr)
library(geosphere)
library(gridExtra)

# Uploading the data

list.files(path = "../input/kaggle/input/case-study-dataset/202306-divvy-tripdata.csv")
list.files(path = "../input/kaggle/input/case-study-dataset/202307-divvy-tripdata.csv")
list.files(path = "../input/kaggle/input/case-study-dataset/202308-divvy-tripdata.csv")
list.files(path = "../input/kaggle/input/case-study-dataset/202309-divvy-tripdata.csv")
list.files(path = "../input/kaggle/input/case-study-dataset/202310-divvy-tripdata.csv")
list.files(path = "../input/kaggle/input/case-study-dataset/202311-divvy-tripdata.csv")

# Loading the data to respective variables

june_2023 = read.csv("../input/case-study-dataset/202306-divvy-tripdata.csv")
july_2023 = read.csv("../input/case-study-dataset/202307-divvy-tripdata.csv")
august_2023 = read.csv("../input/case-study-dataset/202308-divvy-tripdata.csv")
september_2023 = read.csv("../input/case-study-dataset/202309-divvy-tripdata.csv")
october_2023 = read.csv("../input/case-study-dataset/202310-divvy-tripdata.csv")
november_2023 = read.csv("../input/case-study-dataset/202311-divvy-tripdata.csv")

# Combining all the data to a single dataframe

halfyearly <- bind_rows(june_2023,july_2023,august_2023,september_2023,october_2023,november_2023)

# Cleaning the data

# Dropping all the rows with empty cells and NA
halfyearly <- replace(halfyearly, halfyearly=='', NA)
halfyearly <- drop_na(halfyearly)

duplicated_rows <- halfyearly[duplicated(halfyearly),]

print(duplicated_rows)
num_duplicates <- sum(duplicated(halfyearly))
print(paste("Number of duplicated rows:", num_duplicates))

# Adding new columns
# Separating date into month, day, year, day of week and time
halfyearly$date <- as.Date(halfyearly$started_at) 
halfyearly$month <- format(as.Date(halfyearly$date), "%m")
halfyearly$day <- format(as.Date(halfyearly$date), "%d")
halfyearly$year <- format(as.Date(halfyearly$date), "%Y")
halfyearly$day_of_week <- format(as.Date(halfyearly$date), "%A")
halfyearly$time <- format(as.POSIXct(halfyearly$started_at), format="%H")

# Creating a new column to calculate the length of a ride in seconds
halfyearly$ride_length <- difftime(halfyearly$ended_at,halfyearly$started_at)
halfyearly$ride_length <- as.numeric(as.character(halfyearly$ride_length))

# Creating a new column to calculate the distance travelled in km
halfyearly$ride_distance <- distGeo(matrix(c(halfyearly$start_lng,halfyearly$start_lat),ncol=2),matrix(c(halfyearly$end_lng,halfyearly$end_lat),ncol=2))
halfyearly$ride_distance <- halfyearly$ride_distance/1000 

# Clearing the data where a few ride lengths are zero or negative
halfyearly <- halfyearly[!(halfyearly$ride_length <0 | halfyearly$ride_length ==0),]

# statistical summary
summary(halfyearly)

# Finding mean distance and mean time for the rides
usertype_means <- halfyearly %>% 
group_by(member_casual) %>% 
summarise(mean_time = mean(ride_length),mean_distance = mean(ride_distance))

View(usertype_means)

#analyzing ridership data by user type and weekday
halfyearly %>% 
  mutate(weekday=wday(started_at, label= TRUE)) %>% 
  group_by(member_casual,weekday) %>% 
  summarise(number_of_rides= n(),avg_duration=mean(ride_length)) %>% 
  arrange(member_casual,weekday)

#1. Count of members and casual riders
 halfyearly %>% 
    group_by(member_casual) %>% 
    summarise(ride_count = length(ride_id), ride_percentage = (length(ride_id) / nrow(halfyearly)) * 100)
count <- ggplot(halfyearly, aes(x = member_casual, fill=member_casual)) +
    geom_bar() +
    labs(x="User type", y="Number Of Rides", title= "Casuals vs Members distribution")
print(getwd())
ggsave("count.png", plot= count, width = 8, height = 6, dpi = 300)

#2. Visualizing the average time taken and average distance covered by user type
membervstime <- ggplot(usertype_means) + 
                geom_col(mapping=aes(x=member_casual,y=mean_time,fill=member_casual), show.legend = FALSE)+
                labs(title = "Mean travel time by User type",x="User Type",y="Mean time in sec")


membervsdistance <- ggplot(usertype_means) + 
                    geom_col(mapping=aes(x=member_casual,y=mean_distance,fill=member_casual), show.legend = FALSE)+
                    labs(title = "Mean travel distance by User type",x="User Type",y="Mean distance In Km")
grid.arrange(membervstime, membervsdistance, ncol = 2)

#3. Visualizing number of rides in a week by user type
halfyearly %>% 
  mutate(weekday=wday(started_at, label= TRUE)) %>% 
  group_by(member_casual,weekday) %>% 
  summarise(number_of_rides= n(),avg_duration=mean(ride_length),.groups="drop") %>% 
  arrange(member_casual,weekday) %>% 
  ggplot(aes(x= weekday,y= number_of_rides,fill= member_casual)) + geom_col(position = "dodge")+ 
labs(title= "Number of rides by user type during the week", x= "Days of the week", y="Number of rides", fill= "user type")

#4. Visualizing the average duration taken by user type in a week
halfyearly %>% 
  mutate(weekday=wday(started_at, label= TRUE)) %>% 
  group_by(member_casual,weekday) %>% 
  summarise(number_of_rides= n(),avg_duration=mean(ride_length),.groups="drop") %>% 
  arrange(member_casual,weekday) %>% 
  ggplot(aes(x=weekday,y=avg_duration,fill=member_casual))+geom_col(width=0.5,position=position_dodge(width=0.5))+
labs(title= "Average duration of rides by user type during the week", x= "Days of the week", y="Average duration", fill= "user type")

#5. Visualizing the number of rides by user type across months
halfyearly %>% 
  mutate(month=month(started_at, label= TRUE)) %>% 
  group_by(member_casual,month) %>% 
  summarise(number_of_rides= n(),avg_duration=mean(ride_length),.groups="drop") %>% 
  arrange(member_casual,month) %>% 
  ggplot(aes(x=month,y=number_of_rides,fill=member_casual))+geom_col(position="dodge")+
labs(title= "Number of rides by user type across months", x= "Month", y="Number of rides", fill= "user type")

#6. Visualizing the average duration of rides by user type across months
halfyearly %>% 
  mutate(month=month(started_at, label= TRUE)) %>% 
  group_by(member_casual,month) %>% 
  summarise(number_of_rides= n(),avg_duration=mean(ride_length),.groups="drop") %>% 
  arrange(member_casual,month) %>% 
  ggplot(aes(x=month,y=avg_duration,fill=member_casual))+geom_col(position="dodge")+
labs(title= "Average duration of rides by user type across months", x= "Month", y="Average duration", fill= "user type")

#7. Visualizing the bike demand by hour in a day
halfyearly %>%
    ggplot(aes(time, fill= member_casual)) +
    labs(x="Hour of the day",y="Number of rides" ,title="Bike demand by hour in a day", fill= "user type") +
    geom_bar(position="dodge")

#8. Visualizing the bike demand by hour across the week
halfyearly %>%
mutate(weekday=wday(started_at, label= TRUE)) %>% 
    ggplot(aes(time, fill=member_casual))+
    labs(x="Hour of the day",y="Number of rides" ,title="Bike demand by hour in a day across the week", fill= "user type") +
    geom_bar(position="dodge")+
    facet_wrap(~weekday)

#9. Distribution of bikes by hour of the day during midweek and weekend
halfyearly %>%
mutate(weekday=wday(started_at, label= TRUE)) %>%
mutate(type_of_day = ifelse(weekday == 'Sat' | weekday == 'Sun', 'weekend','midweek'))%>%
    ggplot(aes(time, fill=member_casual)) +
    labs(x="Hour of the day", title=" Distribution by hour of the day in the midweek and weekend") +
    geom_bar(position="dodge") +
    facet_wrap(~ type_of_day)

#Creating a new data frame with details only about the rideable type
unique(halfyearly$rideable_type)
bike_types <- halfyearly %>% 
filter(rideable_type== 'electric_bike'|rideable_type== 'classic_bike'|rideable_type== 'docked_bike')

#1. Visualizing the bike type used by the users
bike_types %>%
    group_by(rideable_type) %>%
    summarise(ride_count=length(ride_id),'members'=(sum(member_casual=="member")/length(ride_id))*100,'casual'=(sum(member_casual=="casual")/length(ride_id))*100)
bike_types %>%
    group_by(rideable_type, member_casual) %>%
    summarise(ride_count=length(ride_id),'members'=(sum(member_casual=="member")/length(ride_id))*100,'casual'=(sum(member_casual=="casual")/length(ride_id))*100)%>%
ggplot(aes(x = member_casual, y= ride_count, fill= rideable_type)) +
    geom_col(position="dodge") +
geom_text(aes(label = ride_count), vjust = 0,position = position_dodge(width = 0.9))+
    labs(x="Rideable type", title= "Bike type usage by user type")

#2. Visualizing the bike type used by the users during the week
bike_types %>%
    mutate(weekday = wday(started_at, label = TRUE))%>%
    group_by(member_casual,rideable_type,weekday) %>%
    summarise(rides=n(), .groups="drop")  %>%
ggplot(aes(x=weekday,y=rides, fill=rideable_type)) +
  geom_col( position = "dodge") + 
  facet_wrap(~member_casual) +
  labs(title = "Bike type usage by user type during a week",x="User type",y='Rides') 

#3. Visualizing the bike type used by the users across months
bike_types %>% 
  mutate(month=month(started_at, label= TRUE)) %>% 
  group_by(member_casual,rideable_type,month) %>% 
  summarise(rides= n(),.groups="drop") %>% 
  ggplot(aes(x=month,y=rides,fill=rideable_type))+geom_col(position="dodge")+
  facet_wrap(~member_casual)+
labs(title="Bike type used by the users across month",x="Month",y='Rides')

#Finding popular start stations
halfyearly %>%
    group_by(start_station_name,member_casual) %>%
    summarise(rides=n(), .groups="drop")  %>%
    arrange(-rides)%>%
head(10)%>%
ggplot(aes(x=rides,y=reorder(start_station_name,rides)))+
geom_col() +
geom_text(aes(label = rides), hjust = 0, position = position_dodge(width = 0.1))+
labs(x="rides",y="start station name", title="Popular start stations")

#Most popular start stations for members
halfyearly %>%
    filter(member_casual=="member")%>%
    group_by(start_station_name,member_casual) %>%
    summarise(rides=n(), .groups="drop")  %>%
    arrange(-rides)%>%
head(5)%>%
ggplot(aes(x=rides,y=reorder(start_station_name,rides)))+
geom_col() +
labs(x="rides",y="start station name", title="Popular start stations of members")

#Most popular start stations for casual riders
halfyearly %>%
    filter(member_casual=="casual")%>%
    group_by(start_station_name,member_casual) %>%
    summarise(rides=n(), .groups="drop")  %>%
    arrange(-rides)%>%
head(5)%>%
ggplot(aes(x=rides,y=reorder(start_station_name,rides)))+
geom_col() +
labs(x="rides",y="start station name", title="Popular start stations of casual riders")

#Finding popular end stations
halfyearly %>%
    group_by(end_station_name,member_casual) %>%
    summarise(rides=n(), .groups="drop")  %>%
    arrange(-rides)%>%
head(10)%>%
ggplot(aes(x=rides,y=reorder(end_station_name,rides)))+
geom_col() +
labs(x="rides",y="end station name", title="Popular end stations")

#Most popular end stations for members
halfyearly %>%
    filter(member_casual=="member")%>%
    group_by(end_station_name,member_casual) %>%
    summarise(rides=n(), .groups="drop")  %>%
    arrange(-rides)%>%
head(5)%>%
ggplot(aes(x=rides,y=reorder(end_station_name,rides)))+
geom_col() +
labs(x="rides",y="end station name", title="Popular end stations of members")

#Most popular end stations for casual riders
halfyearly %>%
    filter(member_casual=="casual")%>%
    group_by(end_station_name,member_casual) %>%
    summarise(rides=n(), .groups="drop")  %>%
    arrange(-rides)%>%
head(5)%>%
ggplot(aes(x=rides,y=reorder(end_station_name,rides)))+
geom_col() +
labs(x="rides",y="end station name", title="Popular end stations of casual riders")
=======
# Loading all the necessary packages for the analysis

library(tidyverse)
library(lubridate)
library(janitor)
library(ggplot2)
library(dplyr)
library(geosphere)
library(gridExtra)

# Uploading the data

list.files(path = "../input/kaggle/input/case-study-dataset/202306-divvy-tripdata.csv")
list.files(path = "../input/kaggle/input/case-study-dataset/202307-divvy-tripdata.csv")
list.files(path = "../input/kaggle/input/case-study-dataset/202308-divvy-tripdata.csv")
list.files(path = "../input/kaggle/input/case-study-dataset/202309-divvy-tripdata.csv")
list.files(path = "../input/kaggle/input/case-study-dataset/202310-divvy-tripdata.csv")
list.files(path = "../input/kaggle/input/case-study-dataset/202311-divvy-tripdata.csv")

# Loading the data to respective variables

june_2023 = read.csv("../input/case-study-dataset/202306-divvy-tripdata.csv")
july_2023 = read.csv("../input/case-study-dataset/202307-divvy-tripdata.csv")
august_2023 = read.csv("../input/case-study-dataset/202308-divvy-tripdata.csv")
september_2023 = read.csv("../input/case-study-dataset/202309-divvy-tripdata.csv")
october_2023 = read.csv("../input/case-study-dataset/202310-divvy-tripdata.csv")
november_2023 = read.csv("../input/case-study-dataset/202311-divvy-tripdata.csv")

# Combining all the data to a single dataframe

halfyearly <- bind_rows(june_2023,july_2023,august_2023,september_2023,october_2023,november_2023)

# Cleaning the data

# Dropping all the rows with empty cells and NA
halfyearly <- replace(halfyearly, halfyearly=='', NA)
halfyearly <- drop_na(halfyearly)

duplicated_rows <- halfyearly[duplicated(halfyearly),]

print(duplicated_rows)
num_duplicates <- sum(duplicated(halfyearly))
print(paste("Number of duplicated rows:", num_duplicates))

# Adding new columns
# Separating date into month, day, year, day of week and time
halfyearly$date <- as.Date(halfyearly$started_at) 
halfyearly$month <- format(as.Date(halfyearly$date), "%m")
halfyearly$day <- format(as.Date(halfyearly$date), "%d")
halfyearly$year <- format(as.Date(halfyearly$date), "%Y")
halfyearly$day_of_week <- format(as.Date(halfyearly$date), "%A")
halfyearly$time <- format(as.POSIXct(halfyearly$started_at), format="%H")

# Creating a new column to calculate the length of a ride in seconds
halfyearly$ride_length <- difftime(halfyearly$ended_at,halfyearly$started_at)
halfyearly$ride_length <- as.numeric(as.character(halfyearly$ride_length))

# Creating a new column to calculate the distance travelled in km
halfyearly$ride_distance <- distGeo(matrix(c(halfyearly$start_lng,halfyearly$start_lat),ncol=2),matrix(c(halfyearly$end_lng,halfyearly$end_lat),ncol=2))
halfyearly$ride_distance <- halfyearly$ride_distance/1000 

# Clearing the data where a few ride lengths are zero or negative
halfyearly <- halfyearly[!(halfyearly$ride_length <0 | halfyearly$ride_length ==0),]

# statistical summary
summary(halfyearly)

# Finding mean distance and mean time for the rides
usertype_means <- halfyearly %>% 
group_by(member_casual) %>% 
summarise(mean_time = mean(ride_length),mean_distance = mean(ride_distance))

View(usertype_means)

#analyzing ridership data by user type and weekday
halfyearly %>% 
  mutate(weekday=wday(started_at, label= TRUE)) %>% 
  group_by(member_casual,weekday) %>% 
  summarise(number_of_rides= n(),avg_duration=mean(ride_length)) %>% 
  arrange(member_casual,weekday)

#1. Count of members and casual riders
 halfyearly %>% 
    group_by(member_casual) %>% 
    summarise(ride_count = length(ride_id), ride_percentage = (length(ride_id) / nrow(halfyearly)) * 100)
count <- ggplot(halfyearly, aes(x = member_casual, fill=member_casual)) +
    geom_bar() +
    labs(x="User type", y="Number Of Rides", title= "Casuals vs Members distribution")
print(getwd())
ggsave("count.png", plot= count, width = 8, height = 6, dpi = 300)

#2. Visualizing the average time taken and average distance covered by user type
membervstime <- ggplot(usertype_means) + 
                geom_col(mapping=aes(x=member_casual,y=mean_time,fill=member_casual), show.legend = FALSE)+
                labs(title = "Mean travel time by User type",x="User Type",y="Mean time in sec")


membervsdistance <- ggplot(usertype_means) + 
                    geom_col(mapping=aes(x=member_casual,y=mean_distance,fill=member_casual), show.legend = FALSE)+
                    labs(title = "Mean travel distance by User type",x="User Type",y="Mean distance In Km")
grid.arrange(membervstime, membervsdistance, ncol = 2)

#3. Visualizing number of rides in a week by user type
halfyearly %>% 
  mutate(weekday=wday(started_at, label= TRUE)) %>% 
  group_by(member_casual,weekday) %>% 
  summarise(number_of_rides= n(),avg_duration=mean(ride_length),.groups="drop") %>% 
  arrange(member_casual,weekday) %>% 
  ggplot(aes(x= weekday,y= number_of_rides,fill= member_casual)) + geom_col(position = "dodge")+ 
labs(title= "Number of rides by user type during the week", x= "Days of the week", y="Number of rides", fill= "user type")

#4. Visualizing the average duration taken by user type in a week
halfyearly %>% 
  mutate(weekday=wday(started_at, label= TRUE)) %>% 
  group_by(member_casual,weekday) %>% 
  summarise(number_of_rides= n(),avg_duration=mean(ride_length),.groups="drop") %>% 
  arrange(member_casual,weekday) %>% 
  ggplot(aes(x=weekday,y=avg_duration,fill=member_casual))+geom_col(width=0.5,position=position_dodge(width=0.5))+
labs(title= "Average duration of rides by user type during the week", x= "Days of the week", y="Average duration", fill= "user type")

#5. Visualizing the number of rides by user type across months
halfyearly %>% 
  mutate(month=month(started_at, label= TRUE)) %>% 
  group_by(member_casual,month) %>% 
  summarise(number_of_rides= n(),avg_duration=mean(ride_length),.groups="drop") %>% 
  arrange(member_casual,month) %>% 
  ggplot(aes(x=month,y=number_of_rides,fill=member_casual))+geom_col(position="dodge")+
labs(title= "Number of rides by user type across months", x= "Month", y="Number of rides", fill= "user type")

#6. Visualizing the average duration of rides by user type across months
halfyearly %>% 
  mutate(month=month(started_at, label= TRUE)) %>% 
  group_by(member_casual,month) %>% 
  summarise(number_of_rides= n(),avg_duration=mean(ride_length),.groups="drop") %>% 
  arrange(member_casual,month) %>% 
  ggplot(aes(x=month,y=avg_duration,fill=member_casual))+geom_col(position="dodge")+
labs(title= "Average duration of rides by user type across months", x= "Month", y="Average duration", fill= "user type")

#7. Visualizing the bike demand by hour in a day
halfyearly %>%
    ggplot(aes(time, fill= member_casual)) +
    labs(x="Hour of the day",y="Number of rides" ,title="Bike demand by hour in a day", fill= "user type") +
    geom_bar(position="dodge")

#8. Visualizing the bike demand by hour across the week
halfyearly %>%
mutate(weekday=wday(started_at, label= TRUE)) %>% 
    ggplot(aes(time, fill=member_casual))+
    labs(x="Hour of the day",y="Number of rides" ,title="Bike demand by hour in a day across the week", fill= "user type") +
    geom_bar(position="dodge")+
    facet_wrap(~weekday)

#9. Distribution of bikes by hour of the day during midweek and weekend
halfyearly %>%
mutate(weekday=wday(started_at, label= TRUE)) %>%
mutate(type_of_day = ifelse(weekday == 'Sat' | weekday == 'Sun', 'weekend','midweek'))%>%
    ggplot(aes(time, fill=member_casual)) +
    labs(x="Hour of the day", title=" Distribution by hour of the day in the midweek and weekend") +
    geom_bar(position="dodge") +
    facet_wrap(~ type_of_day)

#Creating a new data frame with details only about the rideable type
unique(halfyearly$rideable_type)
bike_types <- halfyearly %>% 
filter(rideable_type== 'electric_bike'|rideable_type== 'classic_bike'|rideable_type== 'docked_bike')

#1. Visualizing the bike type used by the users
bike_types %>%
    group_by(rideable_type) %>%
    summarise(ride_count=length(ride_id),'members'=(sum(member_casual=="member")/length(ride_id))*100,'casual'=(sum(member_casual=="casual")/length(ride_id))*100)
bike_types %>%
    group_by(rideable_type, member_casual) %>%
    summarise(ride_count=length(ride_id),'members'=(sum(member_casual=="member")/length(ride_id))*100,'casual'=(sum(member_casual=="casual")/length(ride_id))*100)%>%
ggplot(aes(x = member_casual, y= ride_count, fill= rideable_type)) +
    geom_col(position="dodge") +
geom_text(aes(label = ride_count), vjust = 0,position = position_dodge(width = 0.9))+
    labs(x="Rideable type", title= "Bike type usage by user type")

#2. Visualizing the bike type used by the users during the week
bike_types %>%
    mutate(weekday = wday(started_at, label = TRUE))%>%
    group_by(member_casual,rideable_type,weekday) %>%
    summarise(rides=n(), .groups="drop")  %>%
ggplot(aes(x=weekday,y=rides, fill=rideable_type)) +
  geom_col( position = "dodge") + 
  facet_wrap(~member_casual) +
  labs(title = "Bike type usage by user type during a week",x="User type",y='Rides') 

#3. Visualizing the bike type used by the users across months
bike_types %>% 
  mutate(month=month(started_at, label= TRUE)) %>% 
  group_by(member_casual,rideable_type,month) %>% 
  summarise(rides= n(),.groups="drop") %>% 
  ggplot(aes(x=month,y=rides,fill=rideable_type))+geom_col(position="dodge")+
  facet_wrap(~member_casual)+
labs(title="Bike type used by the users across month",x="Month",y='Rides')

#Finding popular start stations
halfyearly %>%
    group_by(start_station_name,member_casual) %>%
    summarise(rides=n(), .groups="drop")  %>%
    arrange(-rides)%>%
head(10)%>%
ggplot(aes(x=rides,y=reorder(start_station_name,rides)))+
geom_col() +
geom_text(aes(label = rides), hjust = 0, position = position_dodge(width = 0.1))+
labs(x="rides",y="start station name", title="Popular start stations")

#Most popular start stations for members
halfyearly %>%
    filter(member_casual=="member")%>%
    group_by(start_station_name,member_casual) %>%
    summarise(rides=n(), .groups="drop")  %>%
    arrange(-rides)%>%
head(5)%>%
ggplot(aes(x=rides,y=reorder(start_station_name,rides)))+
geom_col() +
labs(x="rides",y="start station name", title="Popular start stations of members")

#Most popular start stations for casual riders
halfyearly %>%
    filter(member_casual=="casual")%>%
    group_by(start_station_name,member_casual) %>%
    summarise(rides=n(), .groups="drop")  %>%
    arrange(-rides)%>%
head(5)%>%
ggplot(aes(x=rides,y=reorder(start_station_name,rides)))+
geom_col() +
labs(x="rides",y="start station name", title="Popular start stations of casual riders")

#Finding popular end stations
halfyearly %>%
    group_by(end_station_name,member_casual) %>%
    summarise(rides=n(), .groups="drop")  %>%
    arrange(-rides)%>%
head(10)%>%
ggplot(aes(x=rides,y=reorder(end_station_name,rides)))+
geom_col() +
labs(x="rides",y="end station name", title="Popular end stations")

#Most popular end stations for members
halfyearly %>%
    filter(member_casual=="member")%>%
    group_by(end_station_name,member_casual) %>%
    summarise(rides=n(), .groups="drop")  %>%
    arrange(-rides)%>%
head(5)%>%
ggplot(aes(x=rides,y=reorder(end_station_name,rides)))+
geom_col() +
labs(x="rides",y="end station name", title="Popular end stations of members")

#Most popular end stations for casual riders
halfyearly %>%
    filter(member_casual=="casual")%>%
    group_by(end_station_name,member_casual) %>%
    summarise(rides=n(), .groups="drop")  %>%
    arrange(-rides)%>%
head(5)%>%
ggplot(aes(x=rides,y=reorder(end_station_name,rides)))+
geom_col() +
labs(x="rides",y="end station name", title="Popular end stations of casual riders")
>>>>>>> 80e1e49f42730a23b567bab087cc7c468bce01a4
