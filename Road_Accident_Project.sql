
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

-- Upload the new formatted file
COPY road_accident
FROM 'C:\PGadmin(SQL)\road_accident.csv'
DELIMITER ','
CSV HEADER
NULL '';

SELECT * FROM road_accident;

-- CY casualties
SELECT SUM(number_of_casualties) as cy_casualties
FROM road_accident

-- TOTAL Casualties of 2022

SELECT SUM(number_of_casualties) as CY_Casualties
FROM road_accident
WHERE EXTRACT( YEAR FROM accident_date) = 2022;

-- TOTAL Casualties of 2022 and Dry
SELECT SUM(number_of_casualties) as CY_Casualties
FROM road_accident
WHERE EXTRACT( YEAR FROM accident_date) = 2022
AND road_surface_conditions = 'Dry';

--Total Accidents of current year

SELECT COUNT(DISTINCT accident_index) AS cy_accidents
FROM road_accident
WHERE EXTRACT(YEAR FROM accident_date) = 2022;

-- Total Fatal Casualties 2022
SELECT SUM(number_of_casualties) as CY_Fatal_Casualties
FROM road_accident
WHERE EXTRACT( YEAR FROM accident_date) = 2022
AND accident_severity = 'Fatal'

--Total Serious Casualties of 2022

SELECT SUM(number_of_casualties) as CY_Seious_Casualties
FROM road_accident
WHERE EXTRACT( YEAR FROM accident_date) = 2022
AND accident_severity = 'Serious'

--Total Slight Casualties of 2022
SELECT SUM(number_of_casualties) AS cy_slight_casualties
FROM road_accident
WHERE EXTRACT( YEAR FROM accident_date) = 2022
AND accident_severity = 'Slight';

-- Ratio of slight casualties

SELECT 
    (SELECT CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) FROM road_accident WHERE accident_severity = 'Slight') * 100
    / 
    (SELECT CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) FROM road_accident) AS slight_casualty_ratio;

-- Ratio of fatal casualties

SELECT
	(SELECT CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) FROM road_accident WHERE accident_severity = 'Fatal') * 100
	/
	(SELECT CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) FROM road_accident) AS fatal_casualty_ratio;

-- Ratio of Slight casualties

SELECT
	(SELECT CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) FROM road_accident WHERE accident_severity = 'Slight') * 100
	/
	(SELECT CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) FROM road_accident) AS fatal_Slight_ratio;

-- Changing group type

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
--WHERE EXTRACT(YEAR FROM accident_date) = 2022
GROUP BY vehicle_group;


--Current Year and Previous Year Casualties

SELECT 
    TO_CHAR(accident_date, 'Month') AS month_name, 
    SUM(number_of_casualties) AS CY_Casualties
FROM road_accident
WHERE EXTRACT(YEAR FROM accident_date) = 2022
GROUP BY TO_CHAR(accident_date, 'Month'), EXTRACT(MONTH FROM accident_date)
ORDER BY EXTRACT(MONTH FROM accident_date);

-- CASUALTIES FOR ROAD TYPE

SELECT road_type, SUM(Number_of_casualties) AS CY_Casualties FROM road_accident
WHERE EXTRACT(YEAR FROM accident_date) = 2022
GROUP BY road_type;

--CASUALTIES BY URBAN AND RURL

SELECT urban_or_rural_area,SUM(number_of_casualties)* 100/(SELECT SUM(number_of_casualties) FROM road_accident WHERE EXTRACT(YEAR FROM accident_date) = 2022)
FROM road_accident
WHERE EXTRACT(YEAR FROM accident_date) = 2022
GROUP BY urban_or_rural_area;


--
SELECT * FROM road_accident; 

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


-- TOP 10 LOCATION BY NUMBER OF CASUALTIES

SELECT local_authority, SUM(number_of_casualties) AS Total_Casualties
FROM road_accident
GROUP BY local_authority
ORDER BY Total_Casualties desc
limit 10;

	