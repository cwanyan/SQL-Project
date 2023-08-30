CREATE DATABASE cyclistic_db;
USE cyclistic_db;

-- CREATING TABLES AND IMPORTING DATA
-- Repeat for month of Feb to Dec 2022

CREATE TABLE jan_2022 (
		ride_id varchar(255),
    rideable_type varchar(255),
    started_at varchar(255),
    ended_at varchar(255),
    start_station_name varchar(255),
    start_station_id varchar(255),
    end_station_name varchar(255),
    end_station_id varchar(255),
    start_lat varchar(255),
    start_lng varchar(255),
    end_lat varchar(255),
    end_lng varchar(255),
    member_casual varchar(255));

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/202201-divvy-tripdata.csv'
INTO TABLE cyclistic_db.jan_2022
FIELDS TERMINATED BY ',' 
IGNORE 1 ROWS;


-- COMBINING DATA

CREATE TABLE trips_2022 (
		ride_id varchar(255),
    rideable_type varchar(255),
    started_at varchar(255),
    ended_at varchar(255),
    start_station_name varchar(255),
    start_station_id varchar(255),
    end_station_name varchar(255),
    end_station_id varchar(255),
    start_lat varchar(255),
    start_lng varchar(255),
    end_lat varchar(255),
    end_lng varchar(255),
    member_casual varchar(255));


INSERT INTO trips_2022
SELECT *
FROM jan_2022
UNION ALL
SELECT *
FROM feb_2022
UNION ALL
SELECT *
FROM mar_2022
UNION ALL
SELECT *
FROM apr_2022
UNION ALL
SELECT *
FROM may_2022
UNION ALL
SELECT *
FROM jun_2022
UNION ALL
SELECT *
FROM jul_2022
UNION ALL
SELECT *
FROM aug_2022
UNION ALL
SELECT *
FROM sep_2022
UNION ALL
SELECT *
FROM oct_2022
UNION ALL
SELECT *
FROM nov_2022
UNION ALL
SELECT *
FROM dec_2022;

# 5667717 total rows

CREATE TEMPORARY TABLE temp_trips_2022 AS
SELECT * FROM trips_2022;


-- FINDING DUPLICATES

SELECT COUNT(ride_id) as total_rows
FROM trips_2022;
# 5667717 rows

SELECT COUNT(DISTINCT ride_id) as total_distinct_rows
FROM trips_2022;
# 5667717 rows
# no duplicates


-- FINDING MISSING VALUES
-- Did not include those with complete data

SELECT COUNT(ride_id) AS missing_start_station_name
FROM trips_2022
WHERE start_station_name IS NULL OR TRIM(start_station_name) = '';
# 833064

SELECT COUNT(ride_id) AS missing_start_station_id
FROM trips_2022
WHERE start_station_id IS NULL OR TRIM(start_station_id) = '';
# 833064

SELECT COUNT(ride_id) AS missing_end_station_name
FROM trips_2022
WHERE end_station_name IS NULL OR TRIM(end_station_name) = '';
# 892742

SELECT COUNT(ride_id) AS missing_end_station_id
FROM trips_2022
WHERE end_station_id IS NULL OR TRIM(end_station_id) = '';
# 892742

SELECT COUNT(ride_id) AS missing_end_lat
FROM trips_2022
WHERE end_lat IS NULL OR TRIM(end_lat) = '';
# 5858

SELECT COUNT(ride_id) AS missing_end_lng
FROM trips_2022
WHERE end_lng IS NULL OR TRIM(end_lng) = '';
# 5858


-- FILLING IN MISSING DATA
-- start_station_name, start_lat, start_lng, end_station_name, end_lat, end_lng
# 0 rows affected 

-- Start_station_name

UPDATE temp_trips_2022 AS t1
JOIN (
    SELECT start_lat, start_lng, start_station_name
    FROM trips_2022
    WHERE start_station_name IS NOT NULL
) AS t2 ON t1.start_lat = t2.start_lat AND t1.start_lng = t2.start_lng
SET t1.start_station_name = t2.start_station_name
WHERE t1.start_station_name IS NULL;


-- End_station_name

UPDATE temp_trips_2022 AS t1
JOIN (
    SELECT end_lat, end_lng, end_station_name
    FROM trips_2022
    WHERE end_station_name IS NOT NULL
) AS t2 ON t1.end_lat = t2.end_lat AND t1.end_lng = t2.end_lng
SET t1.end_station_name = t2.end_station_name
WHERE t1.end_station_name IS NULL;

-- Start_lat and start_lng

UPDATE temp_trips_2022 AS t1
JOIN (
    SELECT start_station_name, start_lat, start_lng
    FROM trips_2022
    WHERE start_lat IS NOT NULL AND start_lng IS NOT NULL
) AS t2 ON t1.start_station_name = t2.start_station_name
SET t1.start_lat = t2.start_lat AND t1.start_lng = t2.start_lng
WHERE t1.start_lat IS NULL and t1.start_lng IS NULL;

-- End_lat and end_lng

UPDATE temp_trips_2022 AS t1
JOIN (
    SELECT end_station_name, end_lat, end_lng
    FROM trips_2022
    WHERE end_lat IS NOT NULL AND end_lng IS NOT NULL
) AS t2 ON t1.end_station_name = t2.end_station_name
SET t1.end_lat = t2.end_lat AND t1.end_lng = t2.end_lng
WHERE t1.end_lat IS NULL and t1.end_lng IS NULL;


-- REMOVING MISSING VALUES

DELETE
FROM temp_trips_2022
WHERE (end_lat IS NULL OR TRIM(end_lat) = '') OR 
(end_lng IS NULL OR TRIM(end_lng) = '') OR
(start_station_name IS NULL OR TRIM(start_station_name) = '') OR
(start_station_id IS NULL OR TRIM(start_station_id) = '') OR
(end_station_id IS NULL OR TRIM(end_station_id) = '') OR
(end_station_name IS NULL OR TRIM(end_station_name) = '');

# 1298357 rows deleted


-- FORMATTING 

-- Deleting Double Quotes ("") in fields due to incorrect csv format

UPDATE temp_trips_2022
SET ride_id = REPLACE(ride_id, '"', ''),
	rideable_type = REPLACE(rideable_type, '"', ''),
    started_at = REPLACE(started_at, '"', ''),
    ended_at = REPLACE(ended_at, '"', ''),
    start_station_name = REPLACE(start_station_name, '"', ''),
    start_station_id = REPLACE(start_station_id, '"', ''),
    end_station_name = REPLACE(end_station_name, '"', ''),
    end_station_id = REPLACE(end_station_id, '"', ''),
    member_casual = REPLACE(member_casual, '"', '');

# 1340704 rows affected

-- Trimming leading and trailing spaces

UPDATE temp_trips_2022
SET ride_id = TRIM(ride_id),
    started_at = TRIM(started_at),
    ended_at = TRIM(ended_at),
    start_station_name = TRIM(start_station_name),
    start_station_id = TRIM(start_station_id),
    end_station_name = TRIM(end_station_name),
    end_station_id = TRIM(end_station_id),
    member_casual = TRIM(member_casual);

# 196 rows affected


-- ASSIGNING DATATYPE AFTER CLEANING

ALTER TABLE temp_trips_2022
MODIFY ride_id VARCHAR(255);

ALTER TABLE temp_trips_2022
MODIFY rideable_type VARCHAR(255);

ALTER TABLE temp_trips_2022
MODIFY start_station_name VARCHAR(255);

ALTER TABLE temp_trips_2022
MODIFY start_station_id VARCHAR(255);

ALTER TABLE temp_trips_2022
MODIFY end_station_name VARCHAR(255);

ALTER TABLE temp_trips_2022
MODIFY end_station_id VARCHAR(255);

ALTER TABLE temp_trips_2022
MODIFY started_at DATETIME;

ALTER TABLE temp_trips_2022
MODIFY ended_at DATETIME;

ALTER TABLE temp_trips_2022
MODIFY start_lat DOUBLE;

ALTER TABLE temp_trips_2022
MODIFY start_lng DOUBLE;

ALTER TABLE temp_trips_2022
MODIFY end_lat DOUBLE;

ALTER TABLE temp_trips_2022
MODIFY end_lng DOUBLE;

ALTER TABLE temp_trips_2022
MODIFY member_casual CHAR(6);


-- ADDING 3 NEW COLUMNS
-- 1. ride_length INT
-- 2. day_of_week_int INT
-- 3. day_of_week VARCHAR(255)

-- 1. ride_length 

ALTER TABLE temp_trips_2022
ADD COLUMN ride_length INT;

UPDATE temp_trips_2022
SET ride_length = TIMESTAMPDIFF(MINUTE, started_at, ended_at);


-- 2. day_of_week_int

ALTER TABLE temp_trips_2022
ADD COLUMN day_of_week_int INT;

UPDATE temp_trips_2022
SET day_of_week_int = DAYOFWEEK(started_at)


-- 3. day_of_week

ALTER TABLE temp_trips_2022
ADD COLUMN day_of_week VARCHAR(255);

UPDATE temp_trips_2022
SET day_of_week =
    CASE day_of_week_int
        WHEN 1 THEN 'Sunday'
        WHEN 2 THEN 'Monday'
        WHEN 3 THEN 'Tuesday'
        WHEN 4 THEN 'Wednesday'
        WHEN 5 THEN 'Thursday'
        WHEN 6 THEN 'Friday'
        WHEN 7 THEN 'Saturday'
    END;


-- FINDING OUTLIERS

-- Ride length > 24 hours
SELECT COUNT(ride_length) FROM temp_trips_2022
WHERE ride_length >= 1440;
# 156

-- Ride length > 48 hours
SELECT COUNT(ride_length) FROM temp_trips_2022
WHERE ride_length >= 2880;
# 36

-- Ride length < 0 minute
SELECT COUNT(*) FROM temp_trips_2022
WHERE ride_length < 0;
# 53

-- Ride length <= 0 minute
SELECT COUNT(*) FROM temp_trips_2022
WHERE ride_length <= 0;
# 76651

-- Ride length = 0 minute
SELECT COUNT(*) FROM temp_trips_2022
WHERE ride_length = 0;
# 76598


-- DROPPING OUTLIERS WITH RIDE_LENGTH <= 0 

DELETE
FROM temp_trips_2022
WHERE ride_length <= 0;
# 76651 rows deleted


-- FINAL CHECK FOR NULL OR EMPTY VALUES

SELECT COUNT(*) FROM temp_trips_2022
WHERE ride_id IS NULL OR TRIM(ride_id) = '' OR
rideable_type IS NULL OR TRIM(rideable_type) = '' OR
started_at IS NULL OR TRIM(started_at) = '' OR
ended_at IS NULL OR TRIM(ended_at) = '' OR
start_station_name IS NULL OR TRIM(start_station_name) = '' OR
start_station_id IS NULL OR TRIM(start_station_id) = '' OR
end_station_name IS NULL OR TRIM(end_station_name) = '' OR
end_station_id IS NULL OR TRIM(end_station_id) = '' OR
start_lat IS NULL OR TRIM(start_lat) = '' OR
start_lng IS NULL OR TRIM(start_lng) = '' OR
end_lat IS NULL OR TRIM(end_lat) = '' OR
end_lng IS NULL OR TRIM(end_lng) = '' OR
member_casual IS NULL OR TRIM(member_casual) = '' OR
ride_length IS NULL OR TRIM(ride_length) = '' OR
day_of_week_int IS NULL OR TRIM(day_of_week_int) = '' OR
day_of_week IS NULL OR TRIM(day_of_week) = '';


-- CREATING CLEANED DATABASE

USE cyclistic_db;
CREATE TABLE trips_2022_cleaned AS
SELECT * FROM temp_trips_2022;

-- DATA ANALYSIS

-- 1. Total Ride Share

SELECT member_casual AS membership_type, COUNT(*) AS trip_count
FROM cyclistic_db.trips_2022_cleaned
GROUP BY member_casual;

-- 2. No. of Trips by Quarter

SELECT
    member_casual AS membership_type,
		CASE QUARTER(started_at)
        WHEN 1 THEN 'Q1'
        WHEN 2 THEN 'Q2'
        WHEN 3 THEN 'Q3'
        WHEN 4 THEN 'Q4'
    END AS quarter,
    COUNT(ride_id) AS trip_count
FROM
    cyclistic_db.trips_2022_cleaned
GROUP BY
    quarter, member_casual
ORDER BY
    quarter;

-- 3. No. of Trips by Month

SELECT
    MONTH(started_at) AS month,
    COUNT(*) AS trip_count,
    member_casual AS membership_type
FROM
    cyclistic_db.trips_2022_cleaned
GROUP BY
    MONTH(started_at),
    member_casual
ORDER BY
    MONTH(started_at);

-- 4. No. of Trips by Day of Week

SELECT
    day_of_week,
    day_of_week_int,
    COUNT(*) AS trip_count,
    member_casual AS membership_type
FROM
    cyclistic_db.trips_2022_cleaned
GROUP BY
    day_of_week_int,
    day_of_week,
    member_casual
ORDER BY
    day_of_week_int;

-- 5. No. of Trips by Hour

SELECT
    HOUR(started_at) AS hour,
    member_casual AS membership_type,
		COUNT(*) AS trip_count
    
FROM
    cyclistic_db.trips_2022_cleaned
GROUP BY
    HOUR(started_at),
    member_casual
ORDER BY
    HOUR(started_at);

-- 6. Rideable Type

SELECT rideable_type, member_casual AS membership_type, COUNT(ride_id) AS trip_count
FROM cyclistic_db.trips_2022_cleaned
GROUP BY rideable_type, member_casual
ORDER BY rideable_type;

-- 7. Average Ride Duration

SELECT member_casual AS membership_type, AVG(ride_length) AS avg_duration_min
FROM cyclistic_db.trips_2022_cleaned
GROUP BY member_casual;

-- 8. Average Ride Duration by Day of Week

SELECT member_casual AS membership_type, day_of_week, AVG(ride_length) AS avg_duration_min
FROM cyclistic_db.trips_2022_cleaned
GROUP BY day_of_week, member_casual
ORDER BY day_of_week;

-- 9. Top 10 Start Stations

-- Top 10 Start Stations

SELECT
    start_station_name,
		MIN(start_lat) AS min_start_lat,
    MIN(start_lng) AS min_start_lng,
    COUNT(*) AS trip_count
FROM
    cyclistic_db.trips_2022_cleaned
GROUP BY
    start_station_name
ORDER BY
    num_trips DESC
LIMIT 10;

-- Top 10 Start Stations For Member Riders

SELECT
    member_casual AS membership_type,
		start_station_name,
    MIN(start_lat) AS min_start_lat,
    MIN(start_lng) AS min_start_lng,
    COUNT(*) AS trip_count
FROM
    cyclistic_db.trips_2022_cleaned
WHERE
		member_casual = 'member'
GROUP BY
    start_station_name
ORDER BY
    num_trips DESC
LIMIT 10;

-- Top 10 Start Stations For Casual Riders

SELECT
    member_casual AS membership_type,
		start_station_name,
    MIN(start_lat) AS min_start_lat,
    MIN(start_lng) AS min_start_lng,
    COUNT(*) AS trip_count
FROM
    cyclistic_db.trips_2022_cleaned
WHERE
		member_casual = 'casual'
GROUP BY
    start_station_name
ORDER BY
    num_trips DESC
LIMIT 10;

-- 10. Top 10 End Stations

-- Top 10 End Stations

SELECT
    end_station_name,
		MIN(end_lat) AS min_end_lat,
    MIN(end_lng) AS min_end_lng,
    COUNT(*) AS trip_count
FROM
    cyclistic_db.trips_2022_cleaned
GROUP BY
    end_station_name
ORDER BY
    num_trips DESC
LIMIT 10;

-- Top 10 End Stations For Member Riders

SELECT
    member_casual AS membership_type,
		end_station_name,
		MIN(end_lat) AS min_end_lat,
    MIN(end_lng) AS min_end_lng,
    COUNT(*) AS trip_count
FROM
    cyclistic_db.trips_2022_cleaned
WHERE
		member_casual = 'member'
GROUP BY
    end_station_name
ORDER BY
    num_trips DESC
LIMIT 10;

-- Top 10 End Stations For Casual Riders

SELECT
    member_casual AS membership_type,
		end_station_name,
		MIN(end_lat) AS min_end_lat,
    MIN(end_lng) AS min_end_lng,
    COUNT(*) AS trip_count
FROM
    cyclistic_db.trips_2022_cleaned
WHERE
		member_casual = 'casual'
GROUP BY
    end_station_name
ORDER BY
    num_trips DESC
LIMIT 10
