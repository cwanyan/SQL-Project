# SQL-Project

![Cyclistic logo](https://github.com/cwanyan/SQL-Project/assets/141533132/47eeffcc-73c8-4376-89a6-efd07193dd76)


**Please note that the company, stakeholders and role are fictional and created for the purpose of the case study. Case study is taken from completion of Google Data Analytics Professional Certificate on Coursera.* 

<aside>
👩🏻‍💻 <b>My Role</b>

I am a junior data analyst working in the marketing analyst team at Cyclistic, a bike-share company in Chicago.

</aside>

<aside>
💻 <b>Tools used</b><br>
- MySQL<br>
- Tableau

</aside>

## Background and Setting

Cyclistic is a bike-share company in Chicago that features more than 5,800 bicycles and 600 docking stations, where the bikes can be unlocked from one station and returned to any other station in the system anytime. 

Until now, Cyclistic’s marketing strategy relied on building general awareness and appealing to broad consumer segments. One approach that helped make these things possible was the flexibility of its pricing plans: single-ride passes, full-day passes, and annual memberships.

Cyclistic’s finance analysts have concluded that annual members are much more profitable than casual riders. Although the pricing flexibility helps Cyclistic attract more customers, Moreno (Director of Marketing) believes that maximising the number of annual members will be key to future growth. Rather than creating a marketing campaign that targets all-new customers, Moreno believes there is a very good chance to convert casual riders into members.
<br><br>

**Customer Segmentation**

- **Casual Riders:** Customers who purchase single-ride or full-day passes.
- **Members Riders**: Customers who purchase annual memberships
<br>

**Key Stakeholders**

- **Lily Moreno (Director of Marketing):** Responsible for development of campaigns and initiatives to promote the bike-share program.
- **Cyclistic Marketing Analytics Team:** Provides data analysis to guide Cyclistic marketing strategy.
- **Cyclistic Executive Team:** Decision maker for approval of the recommended marketing strategies.
<br>

## Objective

> ### Conduct data analysis to understand how **casual riders and annual members use Cyclistic bikes differently** and devise a marketing strategy to **convert casual riders into annual members.**
 
<br>

## Dataset Information

- Data has been retrieved from [Divvy Bikes](https://divvy-tripdata.s3.amazonaws.com/index.html)
- Data was downloaded from the [repository](https://divvy-tripdata.s3.amazonaws.com/index.html) in the form of 12 CSV files, each file corresponds to the records of a month in the year 2022.
- The data used for this analysis covers a 12-Month period from January 2022 to December 2022, with 5667717 total rows.
<br>

## **Data Limitations**

**Due to privacy-related issues, no personally identifiable information will be used.**

- Won’t be able to connect pass purchases to credit card numbers to determine if casual riders live in the Cyclistic service area or if they have purchased multiple single passes.
<br>

**Missing values: Removed to ensure accurate analysis and facilitate effective decision making.**

- There were missing values in the fields *start_station_name, start_station_id, end_station_name, end_station_id, end_lat, end_lng*.
- 1298357 rows were deleted.
<br>

**Inaccurate Data: Ride duration values that are negative or zero have been excluded, as they are not logically meaningful.**

- 76651 rows were deleted.
<br>

**Outliers: To note where riders may have forgotten to return their bikes as the ride duration is 24 hours and longer.**

- ride_length ≥ 24 hours: 156
- ride_length ≥ 48 hours: 36
<br>

## Data Cleaning and Analysis

Data cleaning and analysis were done on **MySQL** after importing 12 CSV file for the year 2022 and visualisations were done on **Tableau Public**. 

⭐ SQL query used can be found [here](https://github.com/cwanyan/SQLproject/blob/main/Cyclistic_SQL.sql). 

⭐ Table output for visualisation can be found [here](https://docs.google.com/spreadsheets/d/1pJS-KF7w5gy8QdZDh1H6H06wMgIhuypHOHbP0HyBclE/edit?usp=sharing). 

<br>

### Data Cleaning Summary

1. **Removing duplicates**: 0 duplicates

2. **Filling in missing data:** 0 filled
    - Aims to update missing values by matching rows based on relevant fields — start station name or end station name with latitude and longitude and vice versa.
      
3. **Removing missing values**: 1298357 rows deleted
    - start_station_name: 833064 missing values
    - start_station_id: 833064 missing values
    - end_station_name: 892742 missing values
    - end_station_id: 892742 missing values
    - end_lat: 5858 missing values
    - end_lng: 5858 missing values
    
4. **Formatting**
    - Deleting double quotes ("") in field value due to incorrect csv format while importing
    - Trimming leading and trailing spaces
      
5. **Adding 3 new columns**
    - **ride_length** `int`: To calculate each ride’s duration of usage in minutes using time stamp difference function for started_at and ended_at fields
    - **day_of_week_int** `int`: Integer representation of the day of the week
    - **day_of_week** `varchar(255)`: Corresponding day names as strings for easier identification
      
6. **Remove inaccurate data**: 76651 rows deleted
    - ride_length ≤ 0 minute
      
7. **Outliers:** 156 rows
    - ride_length ≥ 24 hours: 156
    - ride_length ≥ 48 hours: 36
<br>

## Key Findings

![1  Total Ride Share](https://github.com/cwanyan/SQL-Project/assets/141533132/bf4b92a3-4fa4-4bdc-bc06-5c1ffac0ad13)


59.67% of the participants are member riders, while 40.33% are casual riders.
<br><br>


![2  No  of Trips by Quarter](https://github.com/cwanyan/SQL-Project/assets/141533132/1a4d7271-c30b-43d7-bfb5-c450e45eb4d8)


Both member and casual riders follow the same trend for seasonality where it peaked in Q3 and Q2. This can be due to the ideal weather in Spring and Summer for bike rides. There’s a drop in Q4 when there is a transition to colder months while winter months in Q1 record the lowest number of trips. 
<br><br>


![3  No  of Trips by Month](https://github.com/cwanyan/SQL-Project/assets/141533132/9c6b06b7-7a6b-4625-b9aa-25a6541da634)


During the winter months (January to December), casual riders consistently show significantly lower trip numbers compared to member riders. This disparity continues during the transitional months of March, April, September, October, and November.

However, as the weather improves during the summer months (May to August), the trip numbers for casual riders begin to closely match those of member riders. 

The data indicates that the warmer seasons see a significant increase in casual rider activity, resulting in trip numbers that are nearly on par with member riders.

**Refer to appendix A for Chicago weather by month*
<br><br>


![4  No  of Trips by Day of Week](https://github.com/cwanyan/SQL-Project/assets/141533132/3e429709-43fb-4284-8954-f76cf2ac3109)


Casual riders show a U-shaped trend, with much lower bike usage on weekdays and peak during weekends. Member riders exhibit an inverted U-shaped pattern, with fewer trips on weekends and increased usage during midweek. 

These findings suggest different usage behaviours, with casual riders using bikes more for leisure on weekends, and member riders utilising bikes for regular commuting, particularly during the weekdays.
<br><br>


![5  No  of Trips by Hour](https://github.com/cwanyan/SQL-Project/assets/141533132/561da13c-c422-4097-8dcb-bec6f59c6ff0)


For member riders, there is a an increase in bike usage starting from 4 am, with two prominent peaks at 8 am and 5 pm, likely corresponding to morning and evening commutes.

Casual riders also show a gradual increase from 4am and reaching a peak at 5 pm, indicating a preference for late-afternoon rides. 

Both rider types experience a steady decline after the 5 pm peak, suggesting reduced bike usage during the later hours of the day.
<br><br>


![6  Rideable Type](https://github.com/cwanyan/SQL-Project/assets/141533132/d514b566-c1d4-4096-a647-0d60105fd99d)


Classic bikes are the most popular among both types of riders, with electric bikes coming in as the second most used option. Docked bikes are primarily utilised by casual riders, whereas member riders tend not to use them.
<br><br>


![8  Average Ride Duration](https://github.com/cwanyan/SQL-Project/assets/141533132/814be714-1451-45f2-8b13-a7ac9e9c9b71)


Casual riders' average ride duration is approximately 24 minutes, while member riders' average ride duration is nearly half of that at 12 minutes.
<br><br>


![9  Average Ride Duration by Day of Week](https://github.com/cwanyan/SQL-Project/assets/141533132/0b42a2ef-7dc9-4f16-88fc-43debbcd2e8e)


The average ride duration for casual riders follows a U-shaped pattern, reaching its lowest point during the middle of the week. In contrast, member riders experience consistent ride durations, with a slight increase on weekends. Overall, the average ride duration for casual riders exceeds that of member riders on all days.
<br><br>


![17  Top 10 Start Stations](https://github.com/cwanyan/SQL-Project/assets/141533132/41432897-5d21-4aa9-b617-60863a1db2a8)

![18  Top 10 End Stations](https://github.com/cwanyan/SQL-Project/assets/141533132/02340639-43b1-4617-b787-edce6f834a52)

Casual riders tend to prefer popular tourist and recreational destinations, such as Streeter Dr & Grand Ave, Millennium Park, and the Shedd Aquarium, for both starting and ending their rides. On the other hand, members frequently utilise stations located near residential and business areas, such as Kingsbury St & Kinzie St and Wells St & Concord Ln, indicating their preference for commuting and daily use. 

The difference in station preferences suggests that casual riders often seek leisure rides, while members exhibit a more consistent and utilitarian riding behaviour, reflecting the potential for targeted marketing efforts to convert casual riders into annual members.
<br>

**Top 10 Stations for Casual Riders that are also part of Overall Top 10 Stations**

**listed stations do not feature in the top 10 stations for member riders*

![19  Casual Rider and Overall Top 10 Stations](https://github.com/cwanyan/SQL-Project/assets/141533132/b3ac304d-6e34-4297-87b5-cfcb001057d5)
<br><br>


## **Causal Riders Key Insights**

- Warmer seasons see a significant increase in casual rider activity
- Using bikes more for leisure on weekends
- Preference for late-afternoon rides, with activities peaking at 5pm
- Utilises docked bikes, which member riders do not
- Average ride duration for casual riders is nearly twice as long as that of member riders
- Average ride duration for casual riders is the shortest during the midweek and peak on weekends
- Tend to prefer popular tourist and recreational destinations for their start and end stations
<br>

## Recommendations

🌤️🌸 **Spring and Summer** **Promotional Campaign** 🌸🌤️

Develop seasonal marketing campaigns that focus on promoting annual membership offers during the transition from winter to spring and during the peak summer months when casual rider activity increases.

__Recommended Offers__
- limited-time discount
- upgrade incentives such as a free month of membership
- bundle deals that offer discounts to both casual riders and their friends when they sign up together for annual membership
<br><br>

🤝 **Partnerships** 🤝 

Collaborate with local businesses, events, or popular establishments near the top 10 start and stations for casual riders to offer joint promotions or exclusive deals for members only.<br>
**Refer to appendix B for more information on the stations* 

__Stations to be considered📍__
1. Streeter Dr & Grand Ave
2. DuSable Lake Shore Dr & Monroe St
3. Millennium Park
4. Michigan Ave & Oak St
5. DuSable Lake Shore Dr & North Blvd
6. Theater on the Lake
<br><br>

🗓️ **Weekends-only Annual Membership** 🗓️ 

Introduce Weekends-Only Annual Membership that provides exclusive access and benefits to casual riders for weekend bike usage.
<br><br>

🔔 **In-App Notifications & Free Trial** 🔔

Implement in-app notifications for casual riders from 4pm to 6pm where activities are the highest, offering them a free trial for membership and informing them about the benefits and cost savings of becoming annual members. 
<br><br>

🎁 **Rewards Program** 🎁 

Introduce a rewards program where casual riders can earn points for every ride they take. Accumulated points could be used to offer them discounts on annual memberships, motivating them to make the switch.

<br><br>

## Appendices

(A) **Chicago Weather**

| Month | Season | Temperature (°C) | Rainy Season |
| --- | --- | --- | --- |
| January | Winter | 0 to -6 | No |
| February | Winter | 1 to -5 | No |
| March | Spring | 5 to 10 | No |
| April | Spring | 10 to 17 | No |
| May | Spring | 15 to 22 | No |
| June | Summer | 20 to 27 | Yes |
| July | Summer | 22 to 29 | Yes |
| August | Summer | 21 to 28 | Yes |
| September | Autumn | 18 to 24 | Yes |
| October | Autumn | 11 to 17 | No |
| November | Autumn | 5 to 11 | No |
| December | Winter | 0 to -5 | No |
<br>

(B) **Top 10 Stations for Casual Riders that account for a huge proportion of Overall Top 10 Stations**

| Station Names | Description |
| --- | --- |
| Streeter Dr & Grand Ave | - Close to Navy Pier<br>- Entertainment, dining and shopping |
| DuSable Lake Shore Dr & Monroe St | - Near Millennium Park, popular tourist destination<br>- Cultural events |
| Millennium Park | - Home to various iconic landmarks, such as Cloud Gate (the Bean), the Crown Fountain, and the Jay Pritzker Pavilion<br>- Cultural events and concerts |
| Michigan Ave & Oak St | - Famous shopping and tourist district<br>- Cultural landmarks, high-end shopping and restaurants |
| DuSable Lake Shore Dr & North Blvd | - Close to the Chicago History Museum and Lincoln Park Zoo<br>- Close proximity to lakefront |
| Theater on the Lake | - Recreational and cultural activities<br>- Arts and performances |
