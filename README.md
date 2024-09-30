**Problem Statement**

The aim of this project is to analyze data from various housing projects in NYC to gain insights into project distribution, unit types, income levels, and completion trends. By understanding these metrics, stakeholders can better address housing needs, allocate resources, and evaluate the effectiveness of existing programs. Key questions include the total number of projects, the distribution of units by income type, project timelines, and how different program groups compare in terms of project count and total units.

**Methodology**

**Data Source**

The analysis is based on a dataset sourced from Affordable_Housing_Production_by_Project.csv. The dataset includes various attributes for each housing project, such as project ID, name, income unit types, completion dates, and program group classifications.

**Database Creation**

A MySQL database named housing_project was created.
A table named production was established with relevant fields for housing project attributes.
The data from the CSV file was imported into the production table using the LOAD DATA INFILE command, with proper handling for date formats and null values.

**SQL Queries**

A series of SQL queries were executed to derive insights:

Total number of projects
Projects with senior units
Average number of low-income units
Projects completed in specific years
Distribution of units across program groups
Projects with zero rental units and those exceeding average total units

**Results**

Total Number of Projects: The database contains a total of **18,536** projects.

Senior Units: There are projects with senior units greater than zero, ndicating a focus on senior housing needs.

Project Timeline: 
The earliest project completion date recorded is 2016.
Projects are distributed across various start dates, reflecting diverse timelines.

Income Unit Distribution:
The average number of low-income units across all projects is 19.85.
Breakdown of units by program group.

Projects with Zero Counted Rental Units: Projects reported zero counted rental units, highlighting potential gaps in rental housing.


**Conclusion**

The analysis provides valuable insights into the housing projects under consideration. Key findings indicate a diverse range of projects with varying income unit distributions and completion timelines. The data suggests that while there are a significant number of projects addressing low-income and senior housing needs, there are also gaps, particularly in rental units. These insights can guide policymakers and stakeholders in future housing initiatives, ensuring that resources are allocated effectively to meet community needs.
