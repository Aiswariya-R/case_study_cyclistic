# Data Cleaning Report

## 1. Checking for duplicates and removing them
```r
# checking for duplicates
duplicated_rows <- halfyearly[duplicated(halfyearly),]
print(duplicated_rows)
num_duplicates <- sum(duplicated(halfyearly))
print(paste("Number of duplicated rows:", num_duplicates))
```
There are no duplicated rows present in the dataset.

## 2. Dropping all empty cells
```r
# Dropping all the rows with empty cells and NA
halfyearly <- replace(halfyearly, halfyearly=='', NA)
halfyearly <- drop_na(halfyearly)
```
There were many empty rows, and no ways to supplement the data. Since it was not possible to delete them directly, the above query replaces empty rows with 'NA' and deletes the rows using ```drop_na``` command.

## 3. Adding new columns for data aggregation
```r
# Separating date into month, day, year, day of week and time
halfyearly$date <- as.Date(halfyearly$started_at) 
halfyearly$month <- format(as.Date(halfyearly$date), "%m")
halfyearly$day <- format(as.Date(halfyearly$date), "%d")
halfyearly$year <- format(as.Date(halfyearly$date), "%Y")
halfyearly$day_of_week <- format(as.Date(halfyearly$date), "%A")
halfyearly$time <- format(as.POSIXct(halfyearly$started_at), format="%H")
```
The data can only be aggregated at the ride-level, which is too granular. Adding additional columns of data, such as ```day```, ```month```, ```year```,```day_of_week```,```time``` provides additional opportunities to aggregate the data.

## 4. Adding additional columns to prepare for analysis
```r
# Creating a new column to calculate the length of a ride in seconds
halfyearly$ride_length <- difftime(halfyearly$ended_at,halfyearly$started_at)
halfyearly$ride_length <- as.numeric(as.character(halfyearly$ride_length))
```
We want to add a calculated field for the length of the ride since the dataset did not include the duration of the trip. The ```difftime``` function calculates the difference between the end time and the start time for each ride, representing the time interval.  The ```ride_length``` column is converted from character to numeric so we can perform calculations on the data.

```r
# Clearing the data where a few ride lengths are zero or negative
halfyearly <- halfyearly[!(halfyearly$ride_length <0 | halfyearly$ride_length ==0),]
```
There are some rides where ```ride_length``` shows up as negative, including several hundred rides where Divvy took bikes out of circulation for quality control reasons. We need to delete these rides.

```r
# Creating a new column to calculate the distance travelled in km
halfyearly$ride_distance <- distGeo(matrix(c(halfyearly$start_lng,halfyearly$start_lat),ncol=2),matrix(c(halfyearly$end_lng,halfyearly$end_lat),ncol=2))
halfyearly$ride_distance <- halfyearly$ride_distance/1000
```

The ```halfyearly``` dataframe contains columns for the start (```start_lng```, ```start_lat```) and end (```end_lng```, ```end_lat```) coordinates of each ride. These coordinates are combined into matrices representing the start and end locations. The ```distGeo``` function from the ```geosphere``` package calculates the geodesic distance between these points, returning the distance in meters.It is further converted into kilometers and stored in a new column ```ride_distance```.

