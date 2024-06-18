# DESCRIPTIVE ANALYSIS

## Business Task
Identify the key behavioural differences between members and casual riders.

## Initial analysis
```r
# statistical summary
summary(halfyearly)
```
This shows minimum, 1st quarter, median, mean, 3rd quarter and maximum values of ```ride_length``` and ```ride_distance```.

```r
#finding mean distance and mean time for the rides
usertype_means <- halfyearly %>% 
group_by(member_casual) %>% 
summarise(mean_time = mean(ride_length),mean_distance = mean(ride_distance))
View(usertype_means)
```
Mean time in seconds and mean distance in kilometers are calculated to determine if both members and casual riders follow the same pattern.

## Further Analysis
Several variables to find the differences between annual members and casual riders are explored [here](https://www.kaggle.com/code/aiswariyar/casestudy/edit/run/167201188). These include:

### 1. Usertype (```members_casual```):
Two possible values exist for this attribute, ```member``` and ```casual```, representing annual members and casual riders, respectively.

a. How many users are members versus casual riders?

b. Do members and casual riders follow similar patterns in terms of ride duration and distance?

c. How does bike usage differ between casual riders and members on a daily and month-to-month basis?

d. Is there a difference in usage depending on the day of the week between casual riders and members?

*Key metrics explored:*

* Count of members and casual riders
* Average time taken and average distance covered by user type
* Number of rides in a week and across months by user type
* Average duration taken by user type in a week and across months
* Bike demand by hour in a day and across the week
* Distribution of rides by hour of the day in midweek and on weekends

### 2. ```Rideable type```:
This attribute includes three possible values ```classic_bike```, ```docked_bike```, electric_bike```.

a. Is there a significant difference in bike type usage between casual riders and annual members?

b. Do annual members and casual riders have different preferences for bike types on a weekly and monthly basis?

*Key metrics explored:*

* Bike type preferred by users
* Bike type preferred by users during a week and across months

### 3. Stations:
This includes ```start_station_name```, ```end_station_name```.

a. Do the most visited stations differ between casual riders and members?

*Key metrics explored:*

* Popular start and end stations
* Popular start and end stations for members
* Popular start and end stations for casual riders
