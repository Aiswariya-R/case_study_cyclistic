# **Google Data Analytics Certification Capstone Project: Cyclistic Bike-Share**

## Introduction
In 2016, Cyclistic, a fictional bike-sharing company launched a successful bike-share program that has since grown to a fleet of 5,824 bicycles, geotracked and locked into a network of 692 stations across Chicago. The bikes can be unlocked from one station and returned to any other station in the system anytime. Cyclistic offers flexible pricing plans: single-ride passes, full-day passes, and annual memberships. Customers who purchase single-ride or full-day passes are referred to as casual riders, while customers with annual memberships are Cyclistic members.

Objective:
The primary objective of this project is to analyze how annual members and casual riders use Cyclistic bikes differently. Understanding these differences will help design targeted marketing strategies aimed at converting casual riders into annual members, aligning with Cyclistic's goal of maximizing profitability through increased membership. For this, the marketing analyst team wants to know:

 1. How do annual members and casual riders use Cyclistic bikes differently?
 2. Why would casual riders buy Cyclistic annual memberships?
 3. How can Cyclistic use digital media to influence casual riders to become members?
I am positioned as a junior data analyst and will address the first question using the 6 steps of data analysis: How do annual members and casual riders use Cyclistic bikes differently?

## ASK

### Identify the Business Task:
The company aims to improve its revenue by maximizing the number of annual members, with a focus on converting casual riders into annual members. This requires analyzing the differences between casual riders and annual members to create a focused and effective marketing message that encourages casual riders to purchase annual subscriptions.

### Consider Key Stakeholders:
Director of Marketing and Manager: Lily Moreno

Marketing Analytics Team: Collaborating to analyze the data and develop strategies.

Cyclistic Executive Team: Decision-makers who will approve and implement the marketing strategies based on the analysis.

## PREPARE

The data utilized in this project is hosted on [Amazon Web Services (AWS)](https://divvy-tripdata.s3.amazonaws.com/index.html). For this analysis, I am using trip data spanning 6 months, from June 2023 to November 2023. This dataset, provided directly by Cyclistic, has been made available by Motivate International Inc. under the [license](https://divvy-tripdata.s3.amazonaws.com/index.html). The data has been anonymized to ensure privacy, excluding any personally identifiable information. While this limits the ability to analyze specific personal attributes, such as individual rider histories or residential areas, there is ample data available to identify overall usage patterns and behaviors.

## PROCESS

The primary focus of this process step is cleaning the data and preparing it for analysis.

An extensive report of the data cleaning process can be found [here](https://github.com/Aiswariya-R/case_study_cyclistic/blob/main/Data_Cleaning.md). The process includes:

- Checking for duplicates and removing them.
- Dropping all empty cells.
- Adding new columns: ```month```, ```day```, ```year```, ```day_of_week```, and ```time``` to aggregate the data.
- Adding additional columns: ```ride_length``` to calculate the total travel time and ```ride_distance```
  to determine the distance traveled by riders.

## ANALYSE
A full summary of analysis can be found [here](https://github.com/Aiswariya-R/case_study_cyclistic/blob/main/Analysis.md).

Several variables were explored to identify the differences in behavior between annual members and casual riders. These variables include:
* Count of members and casual riders
* Preferred month of ride
* Preferred day and time of the week
* Average duration and average length of ride
* Preferred bike types
* Most visited stations

## SHARE

How do members differ from casual riders?

Members and casual riders differ in several aspects:

1. ***Members*** constitute a majority at ***62%***, while ***casual riders*** account for ***38%***.

2. Despite this difference in numbers, ***casual riders spend almost twice as much time traveling compared to members***. However, the mean distance traveled by both groups is approximately the same.

3. ***Members*** tend to use the bikes more on ***weekdays***, with peaks occurring between ***5:00 - 8:00 and 15:00 - 17:00***. In contrast, ***casual riders*** take more rides on ***weekends***, especially between ***11:00 and 17:00***.

4. Bike usage by both groups gradually ***declines from summer to winter*** (June to November).

5. Both members and casual riders prefer classic bikes, followed by electric bikes. However, only casual riders utilize docked bikes, and their usage ceased in August.

6. The popular start and end stations differ between members and casual riders.

From the observations, it can be concluded that:

### I. Usage Patterns:

* Members primarily use bikes for fixed activities, such as commuting to work.
* Casual riders spend more time traveling per ride, suggesting they may be using bikes for leisurely or recreational purposes rather than commuting.

### II. Seasonal Trends:

Seasonal changes significantly influence the volume of rides. This could be due to weather conditions, with fewer people opting for biking in colder or adverse weather.

### III. Bike Preference:

Casual riders primarily prefer classic bikes and utilize docked bikes for short, leisurely trips, but their usage declines after August. Conversely, members favor classic and electric bikes, opting for the flexibility of dockless bikes for commuting, contributing to their sustained usage throughout the year. 

### IV. Peak Hours:

* Members have peak usage during typical commuting hours on weekdays, while casual riders prefer riding during leisure hours on weekends
* Members tend to follow set routes on weekdays, as the average time spent riding remains consistent from Monday to Friday.

### V. Start and End Stations:

Divergent start and end station preferences between members and casual riders suggest distinct trip origins and destinations, emphasizing differing usage patterns and purposes.

## Deliverable:

Top recommendations based on analysis:

1. **Tailored membership plans:** Offer membership plans specifically designed to cater to the needs and preferences of casual riders.This could include a **weekend membership scheme** that align with their leisurely usage patterns.

2. **Promotions and Incentives:** Provide incentives for casual riders to transition to membership, such as discounted or free trial periods, referral bonuses, or loyalty rewards for consistent usage in collaboration with prominent companies and organizations.
   
3. **Enhanced Convenience:** Highlight the benefits of membership, such as access to dockless bikes for greater flexibility in pick-up and drop-off locations, as well as the convenience of seamless transactions and exclusive member perks.

4. **Targeted marketing:** Launch a marketing campaign highlighting the **health benefits, carbon reduction, and environmental safety of the bikes**, especially at popular stations frequented by casual riders.
   
5. **Improved Customer Experience:** Continuously enhance the overall customer experience for members, focusing on factors such as bike availability, ease of use, and customer support, to encourage casual riders to make the switch to membership.




