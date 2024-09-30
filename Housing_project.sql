create database housing_project;

Create table if not exists production (
Project_ID int,
Project_Name varchar(255) not null,
Program_Group varchar(255) not null,
Project_Start_Date DATE,
Project_Completion_Date DATE,
Extended_Affordability_Only varchar(255) not null,
Prevailing_Wage_Status varchar(255) not null,
Planned_Tax_Benefit varchar(255) not null,
Extremely_Low_Income_Units int,
Very_Low_Income_Units int,
Low_Income_Units int,	
Moderate_Income_Units int,	
Middle_Income_Units	int,
Other_Income_Units int,
Counted_Rental_Units int,	
Counted_Homeownership_Units int,	
All_Counted_Units int,	
Total_Units int,
Senior_Units int
);


LOAD DATA INFILE 'Affordable_Housing_Production_by_Project.csv'
INTO TABLE production
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Project_ID, Project_Name, Program_Group, @Project_Start_Date, @Project_Completion_Date,
 Extended_Affordability_Only, Prevailing_Wage_Status, Planned_Tax_Benefit,
 Extremely_Low_Income_Units, Very_Low_Income_Units, Low_Income_Units, 
 Moderate_Income_Units, Middle_Income_Units, Other_Income_Units,
 Counted_Rental_Units, Counted_Homeownership_Units, All_Counted_Units, 
 Total_Units, Senior_Units)
SET 
    Project_Start_Date = CASE 
                             WHEN @Project_Start_Date = '' THEN NULL 
                             ELSE STR_TO_DATE(@Project_Start_Date, '%m/%d/%Y') 
                          END,
    Project_Completion_Date = CASE 
                                 WHEN @Project_Completion_Date = '' THEN NULL 
                                 ELSE STR_TO_DATE(@Project_Completion_Date, '%m/%d/%Y') 
                               END;
                               
--  Total number of projects?

SELECT 
    COUNT(*) AS 'Total projects'
FROM
    production;
    
-- Projects having senior units greater than zero?

SELECT 
    *
FROM
    production
WHERE
    Senior_Units > 0;
    
--  Names and start dates of all projects?

SELECT 
    project_name, project_start_date
FROM
    production;
    
-- What is the earliest project completion date?

SELECT 
    project_name,
    project_completion_date AS 'Earliest completion date'
FROM
    production
where project_completion_date is not null	 
order by 'Earliest completion date' asc;

-- All projects ordered by their start date.

SELECT 
    *
FROM
    production
ORDER BY Project_Start_Date;

-- How many projects are there in each program group?

SELECT 
    program_group, COUNT(*) AS project_count
FROM
    production
GROUP BY program_group;

-- Total number of units planned for each program group?

SELECT 
    program_group, SUM(Total_Units) AS 'Total units'
FROM
    production
GROUP BY program_group;

-- Which projects were completed in 2022?

SELECT 
    project_name, project_completion_date
FROM
    production
WHERE
    YEAR(Project_Completion_Date) = 2022;
    
-- Average number of low-income units across all projects?

SELECT 
    avg(Low_Income_Units) AS 'Average Low Income Units '
FROM production;
    
-- Projects that have zero counted rental units.

select project_name
from production
where Counted_Rental_Units = 0;

-- Projects exceed the average total number of units?

SELECT 
    project_name, total_units
FROM
    production
WHERE
    total_units > (SELECT 
            AVG(total_units)
        FROM
            production);
            
-- Total number of units for each program group, only for those groups that have more than 10000 total units?
            
	SELECT 
    *
FROM
    (SELECT 
        program_group, SUM(total_units) AS total_units
    FROM
        production
    GROUP BY program_group) AS t
WHERE
    t.total_units > 10000;
    
-- Rank projects by their total number of units.

SELECT PROJECT_NAME, TOTAL_UNITS,
dense_rank() OVER (ORDER BY TOTAL_UNITS DESC) AS Unit_Rank 
FROM production;

-- Breakdown of extremely low and low-income units by program group?

SELECT 
    PROGRAM_GROUP,
    SUM(Extremely_Low_Income_Units) AS 'Extremely Low Income Units',
    SUM(Low_Income_Units) AS 'Low Income Units'
FROM
    production
GROUP BY program_group;

-- Which projects were completed before January 1, 2023?

SELECT 
    project_name, project_completion_date
FROM
    production
WHERE
    YEAR(project_completion_date) < 2023;
    
-- Total number of units for each program group?

SELECT 
    program_group, SUM(total_units) AS total_units
FROM
    production
GROUP BY program_group;

-- Which projects are still pending completion?

SELECT 
    project_name, project_completion_date
FROM
    production
WHERE
    project_completion_date IS NULL;
    
-- Distribution of various income unit types across all projects?

SELECT 
    project_name,
    SUM(Extremely_Low_Income_Units) AS Extremely_Low,
    SUM(Very_Low_Income_Units) AS Very_Low,
    SUM(Low_Income_Units) AS Low,
    SUM(Moderate_Income_Units) AS Moderate,
    SUM(Middle_Income_Units) AS Middle,
    SUM(Other_Income_Units) AS Other
FROM
    production
GROUP BY project_name;

-- Average duration (in days) of completed projects?

SELECT 
    project_name,
    DATEDIFF(project_completion_date,
            project_start_date) AS 'Duration of completion'
FROM
    production
WHERE project_completion_date IS NOT NULL;

-- Projects have the highest number of counted rental units?

SELECT 
    project_name,
    COUNT(counted_rental_units) AS counted_rental_units
FROM
    production
GROUP BY project_name
ORDER BY counted_rental_units DESC
LIMIT 10;

-- Percentage of total units falls under each affordability type?

SELECT 
    Extended_Affordability_Only,
    SUM(total_units) / (SELECT 
            SUM(total_units) AS total_units
        FROM
            production) * 100 AS Percentage
FROM
    production
GROUP BY Extended_Affordability_Only;

--  How many projects exist under each prevailing wage status?

SELECT 
    project_name, Prevailing_Wage_Status,
    COUNT(Prevailing_Wage_Status) AS count
FROM
    production
GROUP BY project_name,Prevailing_Wage_Status;

-- What is the ratio of counted rental units to counted homeownership units for each project?
    
SELECT 
    project_name,
    ROUND(Counted_Rental_Units / All_Counted_Units * 100,
            0) AS 'percentage of rental units',
    ROUND(Counted_Homeownership_Units / All_Counted_Units * 100,
            0) AS 'percentage of homeownership units'
FROM
    production;
    




