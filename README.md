# 🚧 Road Accident Analysis Project

An end-to-end data analytics project that transforms raw road accident records (2021–2022) into an interactive Power BI dashboard, helping transport authorities and safety agencies identify accident trends, high-risk locations, and casualty patterns.

---
## Road Accident dash board image

![image alt](https://github.com/pranavkhanna26/ROAD-ACCIDENT-ANALYSIS/blob/b3c80f520af7b446ccacc63ec9c6a55f02d9b36e/ROAD%20ACCIDENT%20DB%20-overview.png)
---

## 📌 Table of Contents
- [Project Overview](#project-overview)
- [Tools & Technologies](#tools--technologies)
- [Business Requirement](#business-requirement)
- [Stakeholders](#stakeholders)
- [Project Workflow](#project-workflow)
- [Data Cleaning & Modelling](#data-cleaning--modelling)
- [DAX Measures](#dax-measures)
- [SQL Analysis](#sql-analysis)
- [Dashboard & Insights](#dashboard--insights)
- [Key Findings](#key-findings)
- [Repository Structure](#repository-structure)

---

## 📖 Project Overview

This project analyzes **road accident data for 2021 and 2022** to help stakeholders understand casualty trends, severity levels, and risk factors such as road type, weather, lighting conditions, and vehicle type. The end deliverable is an interactive **Power BI dashboard** backed by a **PostgreSQL** database, with all raw data initially explored and validated in **Excel**.

The dashboard answers key business questions such as:
- How many casualties and accidents occurred this year vs. last year?
- Which vehicle types are involved in the most accidents?
- Are casualties higher in urban or rural areas, and during the day or night?
- Which locations report the highest number of casualties?

---

## 🛠️ Tools & Technologies

| Tool | Purpose |
|------|---------|
| **Excel** | Initial raw data review, quick checks, and formatting before load |
| **PostgreSQL (pgAdmin)** | Database creation, data storage, and SQL-based analysis |
| **Power BI** | Data modelling, DAX calculations, visualization, and dashboard building |
| **DAX** | Time-intelligence calculations (YTD, YoY growth, previous year comparisons) |
| **Power Query** | Data cleaning and transformation |

---

## 🎯 Business Requirement

> The client wanted a **Road Accident Dashboard** for the years 2021 and 2022 to gain insight into the following:

- **Primary KPI** – Total Casualties and Total Accidents for the Current Year, with YoY growth
- **Primary KPIs** – Total Casualties by Accident Severity for the Current Year, with YoY growth
- **Secondary KPIs** – Total Casualties by Vehicle Type for the Current Year
- **Monthly Trend** – Comparison of casualties for Current Year vs Previous Year
- Casualties by **Road Type** for the Current Year
- Current Year casualties by **Area/Location** and by **Day/Night**
- **Total Casualties and Total Accidents by Location**

---

## 👥 Stakeholders

This dashboard was designed keeping in mind the needs of multiple stakeholders involved in road safety and transport management:

- Ministry of Transport
- Road Transport Department
- Police Force
- Emergency Services Department
- Road Safety Corps
- Transport Operators
- Traffic Management Agencies
- Public
- Media

---

## 🔄 Project Workflow

The project was executed in the following structured steps:

1. **Requirement Gathering** – Understanding client needs and defining KPIs
2. **Stakeholders Identification** – Mapping out who the dashboard serves
3. **Raw Data Overview** – Initial review of the dataset in Excel
4. **Create Database & Import Data** – Designed schema and loaded data into PostgreSQL
5. **Write SQL Queries** – Queried the database to generate outputs as per requirements
6. **Data Cleaning** – Handling nulls, formatting inconsistencies, and standardizing categories
7. **Data Processing** – Preparing the cleaned data for modelling
8. **Connecting Data with Power BI** – Importing the processed data into Power BI
9. **Data Modelling** – Building relationships between tables (including a custom Calendar table)
10. **Background Design in PowerPoint** – Creating a custom dashboard theme/background
11. **Data Visualization / Charts Design** – Selecting the right visuals for each KPI
12. **Report/Dashboard Building** – Assembling all visuals into a single interactive report
13. **Insights** – Deriving actionable conclusions from the visualized data
14. **Test Document** – Validating dashboard outputs against SQL query results

---

## 🧹 Data Cleaning & Modelling

Key Power BI functionalities applied in this project:

- Connecting to raw data / flat files
- Data cleaning in **Power Query**
- Data processing and formatting
- Building **Time Intelligence** using a custom Calendar/Date table
- **Data modelling** – establishing relationships between multiple tables
- **YTD** and **YoY growth** calculations using DAX
- KPI and Advanced KPI generation
- Creating custom columns and measures
- Importing custom icons/images for visuals
- Designing multiple chart types to generate insights
- Exporting/publishing the final report

### Grouping Applied
To simplify analysis, several columns were grouped into broader categories:
- **Vehicle Type** → Agricultural, Cars, Bike, Bus, Van, Other
- **Light Conditions** → Day, Night
- **Weather Conditions** → grouped into broader categories for cleaner visuals

---

## 🧮 DAX Measures

### Calendar Table (Time Intelligence)
A custom date table was created to support YTD and YoY calculations, since time-intelligence functions in DAX require a proper Calendar table.

```dax
Calender = CALENDAR(
    MIN('Road Accident Data xlsx - Data'[Accident Date]),
    MAX('Road Accident Data xlsx - Data'[Accident Date])
)

Year = YEAR('Calender'[Date])

Month = FORMAT('Calender'[Date], "MMM")

Month Number = MONTH('Calender'[Date])
```

### Current Year (CY) Measures
```dax
CY Accidents Count = TOTALYTD(
    COUNT('Road Accident Data xlsx - Data'[Accident_Index]),
    'Calender'[Date]
)

CY Casualties = TOTALYTD(
    SUM('Road Accident Data xlsx - Data'[Number_of_Casualties]),
    'Calender'[Date]
)
```

### Previous Year (PY) Measures
```dax
PY Acidents = CALCULATE(
    COUNT('Road Accident Data xlsx - Data'[Accident_Index]),
    SAMEPERIODLASTYEAR('Calender'[Date])
)

PY casualties = CALCULATE(
    SUM('Road Accident Data xlsx - Data'[Number_of_Casualties]),
    SAMEPERIODLASTYEAR('Calender'[Date])
)
```

### Year-over-Year (YoY) Growth
```dax
YOY Accidents = ([CY Accidents Count] - [PY Acidents]) / [PY Acidents]

YoY Casualties = ([CY Casualties] - [PY casualties]) / [PY casualties]
```

**Why these matter:** `TOTALYTD` accumulates values from the start of the year up to the current date in context, giving a running Current Year total. `SAMEPERIODLASTYEAR` shifts the same date filter back by one year, allowing a like-for-like comparison. Dividing the difference between CY and PY by PY gives the YoY growth/decline percentage shown on the dashboard KPI cards.

---

## 🗃️ SQL Analysis

Before building the Power BI model, the cleaned dataset was loaded into **PostgreSQL** to validate KPIs and generate supporting analysis using SQL. This included:

- Total and yearly casualty counts
- Casualty breakdown by severity (Fatal / Serious / Slight) and their ratios
- Casualty grouping by vehicle type
- Monthly casualty trends
- Casualties by road type, urban/rural split, and light conditions
- Top 10 locations by number of casualties

📄 Full SQL script: [`Road_Accident_Project.sql`](./Road_Accident_Project.sql)

---

## 📊 Dashboard & Insights

The final Power BI dashboard includes:

- **KPI Cards** – CY Casualties, CY Accidents, Fatal/Serious/Slight Casualties (with YoY % change)
- **Casualties by Vehicle Type** – icon-based breakdown (Car, Bike, Bus, Van, Agricultural, Other)
- **CY vs PY Monthly Trend** – area chart comparing 2021 vs 2022 casualties month-on-month
- **Casualties by Urban/Rural** – donut chart
- **Casualties by Road Type** – bar chart (Single/Dual Carriageway, Roundabout, One-way street, Slip road)
- **Casualties by Light Condition** – Day vs Night donut chart
- **Top 10 Locations by Casualties** – ranked bar chart (e.g., Birmingham, Leeds, Bradford, Manchester)
- **Slicers** – Road Surface and Weather Conditions filters for dynamic exploration

---

## 🔎 Key Findings

- Total casualties recorded: **195.7K**, across **144.4K** accidents in the current year
- Casualties dropped **11.9%** YoY, and accidents dropped **11.7%** YoY
- **Fatal casualties** declined the most, down **33.3%** YoY
- **Cars** account for the overwhelming majority of casualties (**155.8K**), followed by **Vans (15.9K)** and **Bikes (15.6K)**
- **Single carriageways** are the most dangerous road type, linked to **145K** casualties
- **Urban areas** account for **61.95%** of casualties vs **38.05%** in rural areas
- **Daytime** accidents result in more casualties (**73.84%**) than nighttime (**26.16%**)
- **Birmingham** leads all locations with the highest number of casualties (**8.6K**)

---

## 📁 Repository Structure

```
├── Road_Accident_Project.sql     # SQL scripts for data analysis
├── dashboard_preview.png         # Power BI dashboard screenshot
├── Road Accident Data.xlsx       # Raw dataset
└── README.md                     # Project documentation
```

---

## 🙌 Conclusion

This project demonstrates a complete data analytics workflow — from raw data cleaning and database design, through SQL-based validation, to a fully interactive Power BI dashboard using DAX time-intelligence functions. It highlights how disparate accident records can be transformed into clear, decision-ready insights for transport and road-safety stakeholders.
