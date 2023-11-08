SELECT * 
FROM MyPortfolioProject..Covid__Deaths$
WHERE continent IS NOT NULL
ORDER BY 3,4

--SELECT * 
--FROM MyPortfolioProject..Covid__Deaths$
--ORDER BY 3,4

-- Select data that we are going to be using

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM MyPortfolioProject..Covid__Deaths$
WHERE continent IS NOT NULL
ORDER BY 1,2

-- Looking at Total Cases vs Total Deaths
-- Likelihood of dying if you contacted covid in your country

SELECT Location, date, total_cases, total_deaths, 
CONVERT(float,total_deaths) / (total_cases ) * 100 AS Death_percentage
FROM MyPortfolioProject..Covid__Deaths$
ORDER BY 1,2

-- Looking at Total Cases Vs Population
-- Shows what percentage of population got covid

SELECT Location, date, population, total_cases, 
(total_cases/population ) * 100 AS InfectedPercentage
FROM MyPortfolioProject..Covid__Deaths$
--WHERE Location LIKE '%nigeria%' AND continent IS NOT NULL
ORDER BY 1,2

-- Looking at Countries with Highest Infection Rate compared to populations

SELECT Location, population, MAX(total_cases) AS HighestInfectionCount,
MAX(total_cases/population ) * 100 AS InfectedPercentage
FROM MyPortfolioProject..Covid__Deaths$
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY InfectedPercentage DESC


-- Showing Country with highest death count by population

SELECT Location, SUM(new_deaths) as TotalDeathCounts
FROM MyPortfolioProject..Covid__Deaths$
--WHERE Location LIKE '%nigeria%'
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCounts DESC

-- Breaking things down by continent

SELECT continent, SUM(new_deaths) as TotalDeathCounts
FROM MyPortfolioProject..Covid__Deaths$
--WHERE Location LIKE '%nigeria%'
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCounts DESC

SELECT location, MAX(CAST (total_deaths AS INT)) as TotalDeathCounts
FROM MyPortfolioProject..Covid__Deaths$
--WHERE Location LIKE '%nigeria%'
WHERE continent IS NULL
GROUP BY location
ORDER BY TotalDeathCounts DESC

 
 -- Showing continents with the highest death counts per population

 SELECT continent, SUM(new_deaths) as TotalDeathCounts
FROM MyPortfolioProject..Covid__Deaths$
--WHERE Location LIKE '%nigeria%'
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCounts DESC



-- GLOBAL NUMBERS

SELECT SUM(new_cases) as Total_Cases, SUM(new_deaths) as Total_Deaths,
SUM(new_deaths)/NULLIF(SUM(new_cases), 0)*100 as DeathPercentage
FROM MyPortfolioProject..Covid__Deaths$
-- WHERE Location LIKE '%nigeria%'
WHERE continent IS NOT NULL
-- GROUP BY continent
ORDER BY 1,2


-- Looking at Total Population vs Cumulative Total Vaccinations Per Day

SELECT dea.continent, dea.location, dea.date, dea.population, 
vac.new_vaccinations, SUM(CONVERT(BIGINT, vac.new_vaccinations)) 
OVER (PARTITION BY dea.location 
ORDER BY dea.date ROWS UNBOUNDED PRECEDING) 
AS CumulativeTotalVaccinations
FROM MyPortfolioProject..Covid__Deaths$ dea

JOIN

MyPortfolioProject..Covid__Vaccinations$ vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3


-- Looking at Total Population vs Cumulative Percentage of People vaccinated Per Day
-- Using CTE

WITH popVSvac as
(SELECT dea.continent, dea.location, dea.date, dea.population, 
vac.new_vaccinations, SUM(CONVERT(BIGINT, vac.new_vaccinations)) 
OVER (PARTITION BY dea.location 
ORDER BY dea.location, dea.date ROWS UNBOUNDED PRECEDING) 
AS CumulativeTotalVaccinations
FROM MyPortfolioProject..Covid__Deaths$ dea

JOIN

MyPortfolioProject..Covid__Vaccinations$ vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3
)
SELECT *, (CumulativeTotalVaccinations/population) * 100 AS VaccinatedPercentage
FROM
popVSvac

-- Total percentage of people vaccinated per location

SELECT dea.location, dea.population,
MAX(CONVERT(BIGINT, vac.new_vaccinations)/dea.population) *100 AS VaccinatedPercentage
FROM MyPortfolioProject..Covid__Deaths$ dea

JOIN

MyPortfolioProject..Covid__Vaccinations$ vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
GROUP BY dea.location, dea.population
ORDER BY VaccinatedPercentage DESC


-- USING TEMP TABLE
DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
CumulativeTotalVaccinations numeric
)


INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, 
vac.new_vaccinations, SUM(CONVERT(BIGINT, vac.new_vaccinations)) 
OVER (PARTITION BY dea.location 
ORDER BY dea.location, dea.date ROWS UNBOUNDED PRECEDING) 
AS CumulativeTotalVaccinations
FROM MyPortfolioProject..Covid__Deaths$ dea

JOIN

MyPortfolioProject..Covid__Vaccinations$ vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2

SELECT *, (CumulativeTotalVaccinations/population) * 100 AS VaccinatedPercentage
FROM
#PercentPopulationVaccinated


-- VIEWS
-- Creating view to store data for later visualizations

-- Views for Total Population vs Cumulative Percentage of People vaccinated Per Day
CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, 
vac.new_vaccinations, SUM(CONVERT(BIGINT, vac.new_vaccinations)) 
OVER (PARTITION BY dea.location 
ORDER BY dea.location, dea.date ROWS UNBOUNDED PRECEDING) 
AS CumulativeTotalVaccinations
FROM MyPortfolioProject..Covid__Deaths$ dea

JOIN

MyPortfolioProject..Covid__Vaccinations$ vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3


SELECT * FROM PercentPopulationVaccinated


-- Views showing infection counts and infected percentage per Location
CREATE VIEW InfectionCountAndPercentage AS
SELECT Location, population, MAX(total_cases) AS HighestInfectionCount,
MAX(total_cases/population ) * 100 AS InfectedPercentage
FROM MyPortfolioProject..Covid__Deaths$
WHERE continent IS NOT NULL
GROUP BY location, population
--ORDER BY InfectedPercentage DESC

SELECT * FROM InfectionCountAndPercentage


-- Views for Total Cases, Total Deaths, and Death Percentage Globally
CREATE VIEW GlobalNumbers AS
SELECT SUM(new_cases) as Total_Cases, SUM(new_deaths) as Total_Deaths,
SUM(new_deaths)/NULLIF(SUM(new_cases), 0)*100 as DeathPercentage
FROM MyPortfolioProject..Covid__Deaths$
-- WHERE Location LIKE '%nigeria%'
WHERE continent IS NOT NULL
-- GROUP BY continent
--ORDER BY 1,2

SELECT * FROM GlobalNumbers


-- Views Showing continents Total Death Counts
CREATE VIEW ContinentTotalDeathCounts AS
 SELECT continent, SUM(new_deaths) as TotalDeathCounts
FROM MyPortfolioProject..Covid__Deaths$
--WHERE Location LIKE '%nigeria%'
WHERE continent IS NOT NULL
GROUP BY continent
--ORDER BY TotalDeathCounts DESC

SELECT * FROM ContinentTotalDeathCounts


-- View showing Total Cases, Total Deaths, and death percentage per country

CREATE VIEW CountryTotalDeathCountsPercentage AS
SELECT Location, SUM(new_cases) AS Total_Cases, SUM(new_deaths) AS Total_Deaths, 
SUM(CONVERT(float,new_deaths)) / NULLIF(SUM(new_cases), 0) * 100 AS Death_percentage
FROM MyPortfolioProject..Covid__Deaths$
WHERE continent IS NOT NULL
GROUP BY location
-- ORDER BY 1,2

SELECT * FROM CountryTotalDeathCountsPercentage
