## 🗄️ Database Setup & Import

**Creating the Table Schema**[cite: 3]
```sql
CREATE TABLE road_accident (
    accident_index VARCHAR(50) PRIMARY KEY,
    accident_date DATE,
    day_of_week VARCHAR(20),
    junction_control VARCHAR(100),
    junction_detail VARCHAR(100),
    accident_severity VARCHAR(50),
    light_conditions VARCHAR(100),
    local_authority VARCHAR(100),
    carriageway_hazards VARCHAR(255),
    number_of_casualties INT,
    number_of_vehicles INT,
    police_force VARCHAR(100),
    road_surface_conditions VARCHAR(100),
    road_type VARCHAR(100),
    speed_limit INT,
    time TIME,                     
    urban_or_rural_area VARCHAR(50),
    weather_conditions VARCHAR(100),
    vehicle_type VARCHAR(100)
);
```

**Importing Data and Verifying**[cite: 3]
```sql
COPY road_accident
FROM 'C:\PGadmin(SQL)\road_accident.csv'
DELIMITER ','
CSV HEADER
NULL '';

SELECT * FROM road_accident;
```

---

## 📊 Data Analysis Queries

### Q1: What is the total number of casualties across all records?[cite: 3]
```sql
SELECT SUM(number_of_casualties) as cy_casualties
FROM road_accident;
-- Returns the grand total of all recorded casualties in the dataset
```

### Q2: What is the total number of casualties for the current year (2022)?[cite: 3]
```sql
SELECT SUM(number_of_casualties) as CY_Casualties
FROM road_accident
WHERE EXTRACT( YEAR FROM accident_date) = 2022;
-- Returns the total casualties specifically for the year 2022
```

### Q3: What are the total casualties in 2022 during dry road conditions?[cite: 3]
```sql
SELECT SUM(number_of_casualties) as CY_Casualties
FROM road_accident
WHERE EXTRACT( YEAR FROM accident_date) = 2022
AND road_surface_conditions = 'Dry';
-- Highlights the number of casualties that occurred in optimal surface conditions
```

### Q4: What is the total number of unique accidents in 2022?[cite: 3]
```sql
SELECT COUNT(DISTINCT accident_index) AS cy_accidents
FROM road_accident
WHERE EXTRACT(YEAR FROM accident_date) = 2022;
-- Returns the total count of distinct accidents (as one accident can have multiple casualties)
```

### Q5: What is the total number of fatal casualties in 2022?[cite: 3]
```sql
SELECT SUM(number_of_casualties) as CY_Fatal_Casualties
FROM road_accident
WHERE EXTRACT( YEAR FROM accident_date) = 2022
AND accident_severity = 'Fatal';
-- Returns the total number of casualties categorized as 'Fatal'
```

### Q6: What is the total number of serious casualties in 2022?[cite: 3]
```sql
SELECT SUM(number_of_casualties) as CY_Seious_Casualties
FROM road_accident
WHERE EXTRACT( YEAR FROM accident_date) = 2022
AND accident_severity = 'Serious';
-- Returns the total number of casualties categorized as 'Serious'
```

### Q7: What is the total number of slight casualties in 2022?[cite: 3]
```sql
SELECT SUM(number_of_casualties) AS cy_slight_casualties
FROM road_accident
WHERE EXTRACT( YEAR FROM accident_date) = 2022
AND accident_severity = 'Slight';
-- Returns the total number of casualties categorized as 'Slight'
```

### Q8: What is the percentage ratio of slight casualties to total casualties?[cite: 3]
```sql
SELECT 
    (SELECT CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) FROM road_accident WHERE accident_severity = 'Slight') * 100
    / 
    (SELECT CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) FROM road_accident) AS slight_casualty_ratio;
-- Calculates the proportion of total casualties that were classified as slight
```

### Q9: What is the percentage ratio of fatal casualties to total casualties?[cite: 3]
```sql
SELECT
	(SELECT CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) FROM road_accident WHERE accident_severity = 'Fatal') * 100
	/
	(SELECT CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) FROM road_accident) AS fatal_casualty_ratio;
-- Calculates the proportion of total casualties that were classified as fatal
```

### Q10: How are casualties distributed among different vehicle groups?[cite: 3]
```sql
SELECT 
    CASE
        WHEN vehicle_type IN ('Agricultural vehicle') THEN 'Agricultural'
        WHEN vehicle_type IN ('Car','Taxi/Private hire car') THEN 'Cars'
        WHEN vehicle_type IN ('Motorcycle 50cc and under','Motorcycle 125cc and under','Motorcycle over 125cc and up to 500cc','Motorcycle over 500cc','Pedal cycle') THEN 'Bike'
        WHEN vehicle_type IN ('Bus or coach (17 or more pass seats)','Minibus (8 - 16 passenger seats)') THEN 'Bus'
        WHEN vehicle_type IN ('Van / Goods 3.5 tonnes mgw or under','Goods over 3.5t. and under 7.5t','Goods 7.5 tonnes mgw and over') THEN 'Van'
        ELSE 'Other'
    END AS vehicle_group,
    SUM(number_of_casualties) AS CY_Casualties
FROM road_accident
GROUP BY vehicle_group;
-- Categorizes specific vehicle types into broader groups and sums their respective casualties
```

### Q11: What is the monthly trend of casualties for the year 2022?[cite: 3]
```sql
SELECT 
    TO_CHAR(accident_date, 'Month') AS month_name, 
    SUM(number_of_casualties) AS CY_Casualties
FROM road_accident
WHERE EXTRACT(YEAR FROM accident_date) = 2022
GROUP BY TO_CHAR(accident_date, 'Month'), EXTRACT(MONTH FROM accident_date)
ORDER BY EXTRACT(MONTH FROM accident_date);
-- Outputs a month-by-month breakdown of casualties, ordered chronologically
```

### Q12: What is the total number of casualties for each road type in 2022?[cite: 3]
```sql
SELECT road_type, SUM(Number_of_casualties) AS CY_Casualties 
FROM road_accident
WHERE EXTRACT(YEAR FROM accident_date) = 2022
GROUP BY road_type;
-- Groups the total 2022 casualties by the type of road on which the accident occurred
```

### Q13: What is the casualty percentage distribution between urban and rural areas in 2022?[cite: 3]
```sql
SELECT urban_or_rural_area,SUM(number_of_casualties)* 100/(SELECT SUM(number_of_casualties) FROM road_accident WHERE EXTRACT(YEAR FROM accident_date) = 2022)
FROM road_accident
WHERE EXTRACT(YEAR FROM accident_date) = 2022
GROUP BY urban_or_rural_area;
-- Shows the percentage split of casualties between urban and rural environments
```

### Q14: What is the casualty percentage distribution based on light conditions (Day vs. Night) in 2022?[cite: 3]
```sql
SELECT
	CASE
		WHEN light_conditions IN ('Daylight') THEN 'Day'
		WHEN light_conditions IN ('Darkness - lighting unknown','Darkness - lights lit','Darkness - lights unlit','Darkness - no lighting') THEN 'Night'
	END AS light_group,
	CAST(CAST(SUM(number_of_casualties)AS DECIMAL(10,2))* 100/
	(SELECT CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) FROM road_accident WHERE EXTRACT(YEAR FROM accident_date)= 2022)AS DECIMAL(10,2)) AS casualty_percentage
FROM road_accident
WHERE EXTRACT(YEAR FROM accident_date) = 2022
GROUP BY light_group;
-- Groups multiple darkness conditions into 'Night' and compares the casualty percentage against 'Day'
```

### Q15: Which are the top 10 locations (local authorities) by number of casualties?[cite: 3]
```sql
SELECT local_authority, SUM(number_of_casualties) AS Total_Casualties
FROM road_accident
GROUP BY local_authority
ORDER BY Total_Casualties desc
limit 10;
-- Returns the 10 local authorities with the highest total casualties, sorted in descending order
```
