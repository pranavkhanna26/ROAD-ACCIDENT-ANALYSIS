# Road Accident Data Analysis (SQL Project)

This project analyzes UK road accident data using PostgreSQL, covering casualty trends, severity breakdowns, vehicle types, road/weather conditions, and location hotspots.

---

## Table Setup

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

```sql
COPY road_accident
FROM 'C:\PGadmin(SQL)\road_accident.csv'
DELIMITER ','
CSV HEADER
NULL '';
```

---

## Q1: What is the total number of casualties recorded overall?

```sql
SELECT SUM(number_of_casualties) AS cy_casualties
FROM road_accident;
```
-- Total casualties across all years: <fill in result>

---

## Q2: What is the total number of casualties in 2022?

```sql
SELECT SUM(number_of_casualties) AS CY_Casualties
FROM road_accident
WHERE EXTRACT(YEAR FROM accident_date) = 2022;
```
-- Total casualties in 2022: <fill in result>

---

## Q3: What is the total number of casualties in 2022 on dry roads?

```sql
SELECT SUM(number_of_casualties) AS CY_Casualties
FROM road_accident
WHERE EXTRACT(YEAR FROM accident_date) = 2022
AND road_surface_conditions = 'Dry';
```
-- Total 2022 casualties on dry roads: <fill in result>

---

## Q4: What is the total number of accidents in 2022?

```sql
SELECT COUNT(DISTINCT accident_index) AS cy_accidents
FROM road_accident
WHERE EXTRACT(YEAR FROM accident_date) = 2022;
```
-- Total accidents in 2022: <fill in result>

---

## Q5: What is the total number of fatal casualties in 2022?

```sql
SELECT SUM(number_of_casualties) AS CY_Fatal_Casualties
FROM road_accident
WHERE EXTRACT(YEAR FROM accident_date) = 2022
AND accident_severity = 'Fatal';
```
-- Fatal casualties in 2022: <fill in result>

---

## Q6: What is the total number of serious casualties in 2022?

```sql
SELECT SUM(number_of_casualties) AS CY_Serious_Casualties
FROM road_accident
WHERE EXTRACT(YEAR FROM accident_date) = 2022
AND accident_severity = 'Serious';
```
-- Serious casualties in 2022: <fill in result>

---

## Q7: What is the total number of slight casualties in 2022?

```sql
SELECT SUM(number_of_casualties) AS cy_slight_casualties
FROM road_accident
WHERE EXTRACT(YEAR FROM accident_date) = 2022
AND accident_severity = 'Slight';
```
-- Slight casualties in 2022: <fill in result>

---

## Q8: What percentage of total casualties are classified as "Slight"?

```sql
SELECT
    (SELECT CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) FROM road_accident WHERE accident_severity = 'Slight') * 100
    /
    (SELECT CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) FROM road_accident) AS slight_casualty_ratio;
```
-- Slight casualty ratio: <fill in result>%

---

## Q9: What percentage of total casualties are classified as "Fatal"?

```sql
SELECT
    (SELECT CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) FROM road_accident WHERE accident_severity = 'Fatal') * 100
    /
    (SELECT CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) FROM road_accident) AS fatal_casualty_ratio;
```
-- Fatal casualty ratio: <fill in result>%

---

## Q10: How are casualties distributed across broader vehicle-type groups?

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
```
-- Vehicle group with the most casualties: <fill in result>

---

## Q11: What is the month-by-month casualty trend in 2022?

```sql
SELECT
    TO_CHAR(accident_date, 'Month') AS month_name,
    SUM(number_of_casualties) AS CY_Casualties
FROM road_accident
WHERE EXTRACT(YEAR FROM accident_date) = 2022
GROUP BY TO_CHAR(accident_date, 'Month'), EXTRACT(MONTH FROM accident_date)
ORDER BY EXTRACT(MONTH FROM accident_date);
```
-- Month with highest casualties in 2022: <fill in result>

---

## Q12: How are 2022 casualties distributed across road types?

```sql
SELECT road_type, SUM(number_of_casualties) AS CY_Casualties
FROM road_accident
WHERE EXTRACT(YEAR FROM accident_date) = 2022
GROUP BY road_type;
```
-- Road type with the most casualties: <fill in result>

---

## Q13: What percentage of 2022 casualties occurred in urban vs. rural areas?

```sql
SELECT urban_or_rural_area, SUM(number_of_casualties) * 100 / (SELECT SUM(number_of_casualties) FROM road_accident WHERE EXTRACT(YEAR FROM accident_date) = 2022)
FROM road_accident
WHERE EXTRACT(YEAR FROM accident_date) = 2022
GROUP BY urban_or_rural_area;
```
-- Urban vs rural split: <fill in result>

---

## Q14: What percentage of 2022 casualties occurred during day vs. night?

```sql
SELECT
    CASE
        WHEN light_conditions IN ('Daylight') THEN 'Day'
        WHEN light_conditions IN ('Darkness - lighting unknown','Darkness - lights lit','Darkness - lights unlit','Darkness - no lighting') THEN 'Night'
    END AS light_group,
    CAST(CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) * 100 /
    (SELECT CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) FROM road_accident WHERE EXTRACT(YEAR FROM accident_date) = 2022) AS DECIMAL(10,2)) AS casualty_percentage
FROM road_accident
WHERE EXTRACT(YEAR FROM accident_date) = 2022
GROUP BY light_group;
```
-- Day vs night casualty split: <fill in result>

---

## Q15: Which local authorities have the highest number of casualties?

```sql
SELECT local_authority, SUM(number_of_casualties) AS Total_Casualties
FROM road_accident
GROUP BY local_authority
ORDER BY Total_Casualties DESC
LIMIT 10;
```
-- Top local authority by casualties: <fill in result>
