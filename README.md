# COVID-19-SQL-PROJECT

## Project Overview

The objective of this data analysis project is to explore and analyze the COVID-19 dataset to gain insights into various aspects of the pandemic. The analysis focuses on key metrics such as total cases, total deaths, infection rates, death rates, and vaccination trends. The dataset used for this analysis includes information on COVID-19 cases, deaths, and vaccinations, with a specific emphasis on continental and global perspectives.

## Data Source

The data is sourced from the World Health Organization website, where it was originally available in an Excel format. To facilitate easier analysis, the dataset was converted into a structured database format and integrated into the "MyPortfolioProject" database. The conversion process involved importing the dataset into the database management system. The dataset contains information on COVID-19 cases, deaths, and vaccinations across different locations and continents.

## SQL Queries and Analysis

1. Data Selection
The initial SQL queries focus on selecting relevant data for analysis. The data is filtered to include only rows where the continent is not null, and columns such as location, date, total_cases, new_cases, total_deaths, and population are selected.

``` SQL
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM MyPortfolioProject..Covid__Deaths$
WHERE continent IS NOT NULL
ORDER BY 1,2;
```
![screenshot of SQL selected query result](/SQL PROJECT IMAGE/SQL_selected_query.jpg


3. Likelihood of Death
This analysis calculates the likelihood of dying if an individual contracts COVID-19 in a specific country. It includes the calculation of death percentages based on total cases and total deaths.

4. Infection Rates
This analysis explores the percentage of the population that has contracted COVID-19 in different countries, providing insights into the spread of the virus.

5. Countries with Highest Infection Rates
Identifies and ranks countries based on their infection rates compared to their populations, showcasing those with the highest percentages.

6. Countries with Highest Death Counts
Identifies and ranks countries based on their total death counts.

7. Continental Analysis
Provides insights into COVID-19-related metrics on a continental level, including total death counts.

8. Global Numbers
Presents global statistics on total cases, total deaths, and death percentages.

9. Vaccination Trends
Analyzes the cumulative total vaccinations over time and calculates the percentage of the population vaccinated.

Views
To facilitate further analysis and visualization, several views are created:

GlobalNumbers: Total Cases, Total Deaths, and Death Percentage Globally.
ContinentTotalDeathCounts: Total Death Counts per Continent.
InfectionCountAndPercentage: Infection Counts and Infected Percentage per Location.
PercentPopulationVaccinated: Total Population vs Cumulative Percentage of People Vaccinated per Day.
CountryTotalDeathCountsPercentage: Total Cases, Total Deaths, and Death Percentage per Country.


Conclusion
This data analysis project provides valuable insights into the impact of COVID-19 on a global and regional scale. The analysis covers key metrics, including infection rates, death rates, and vaccination trends, enabling a comprehensive understanding of the pandemic's dynamics. The views created serve as a foundation for further exploration and visualization of the data.

Note: The SQL queries and views are intended for use in a SQL database environment. Visualization tools or additional programming may be used for further analysis and presentation.
