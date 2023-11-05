# Confirm data is properly structured
Use PortfolioProject1_92623;

SELECT * 
FROM CovidDeaths
order by 3, 4;

# Noticed CovidDeaths has too many columns so dropping the ones that are duplicated by the CovidVaccinations table
Alter table CovidDeaths
DROP COLUMN total_tests_per_thousand,
DROP COLUMN new_tests_per_thousand,
DROP COLUMN new_tests_smoothed,
DROP COLUMN new_tests_smoothed_per_thousand,
DROP COLUMN positive_rate,
DROP COLUMN tests_per_case,
DROP COLUMN tests_units,
DROP COLUMN total_vaccinations,
DROP COLUMN people_vaccinated,
DROP COLUMN people_fully_vaccinated,
DROP COLUMN new_vaccinations,
DROP COLUMN new_vaccinations_smoothed,
DROP COLUMN total_vaccinations_per_hundred,
DROP COLUMN people_vaccinated_per_hundred,
DROP COLUMN people_fully_vaccinated_per_hundred,
DROP COLUMN new_vaccinations_smoothed_per_million,
DROP COLUMN stringency_index,
DROP COLUMN population_density,
DROP COLUMN median_age,
DROP COLUMN aged_65_older,
DROP COLUMN aged_70_older,
DROP COLUMN gdp_per_capita,
DROP COLUMN extreme_poverty,
DROP COLUMN cardiovasc_death_rate,
DROP COLUMN diabetes_prevalence,
DROP COLUMN female_smokers,
DROP COLUMN male_smokers,
DROP COLUMN handwashing_facilities,
DROP COLUMN hospital_beds_per_thousand,
DROP COLUMN life_expectancy,
DROP COLUMN human_development_index;

# Looking at Total Cases vs Total Deaths for countries
SELECT 
    *
FROM
    CovidVaccinations
ORDER BY 3 , 4;

Select location, date, total_cases, new_cases, total_deaths, population, (total_deaths/total_cases)*100 as death_percentage
FROM CovidDeaths
ORDER BY 1,2;

   # looking at death_% in the US
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
FROM CovidDeaths
WHERE location LIKE '%states%'
ORDER BY 1,2;
   # Peak & valley death_% in US & when
Select location, ROUND(MAX((total_deaths/total_cases)*100), 1) as peak_death_percentage, ROUND(MIN((total_deaths/total_cases)*100), 1) as lowest_death_percentage
FROM CovidDeaths
GROUP BY location
HAVING location LIKE '%states'; # Max = 10.9% Min = 1.7%
   # Determine when the max & min death %'s occur
SELECT location, max_death_percentage, min_death_percentage
FROM (
	Select 
		location, 
		ROUND(MAX((total_deaths/total_cases)*100), 1) as max_death_percentage, 
		ROUND(MIN((total_deaths/total_cases)*100), 1) as min_death_percentage
	FROM CovidDeaths
	GROUP BY location
	HAVING location LIKE '%states'
) as a;
 -- Return to the above attempt -- 
 
# Total Cases vs Population - shows what % of population got Covid
Select location, date, total_cases, population, ROUND((total_cases/population)*100, 1) as cases_percentage
FROM CovidDeaths
WHERE location LIKE '%states%'
ORDER BY 1,2;

# Looking at countries with highest infection rate compared to population
Select location, population, MAX(total_cases) as highest_infection_count, ROUND(MAX((total_cases/population)*100), 1) as pop_infected_percentage
FROM CovidDeaths
GROUP BY location, population
ORDER BY pop_infected_percentage DESC
LIMIT 20;

# Showing Countries with Highest Death Count per Population
Select location, population, MAX(total_deaths) as highest_death_count, ROUND(MAX((total_deaths/population)*100), 1) as death_percentage
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY death_percentage DESC 
;

# Break things down by continent
Select location, MAX(total_deaths) as highest_death_count, ROUND(MAX((total_deaths/population)*100), 1) as death_percentage
FROM CovidDeaths
WHERE continent IS NULL #and location IN('Europe', 'North America', 'South America', 'Asia', 'Africa', 'Oceania')
GROUP BY location
ORDER BY death_percentage DESC 
;

SELECT * FROM CovidDeaths WHERE continent IS NULL and location IN('Europe', 'North America', 'South America', 'Asia', 'Africa', 'Oceania');

-- Looking at Total Population (countries) vs Vaccinations --
# First confirm Joining the deaths & vaccinations tables works
Select *
From CovidDeaths d
		JOIN
    CovidVaccinations v ON d.location = v.location AND d.date = v.date; # to confirm, visually check the dates in both date columns and see if they match
    
SELECT # new_vaccinations is per day
	d.continent, d.location, d.date, d.population, v.new_vaccinations, SUM(v.new_vaccinations) OVER (Partition by d.location ORDER BY d.location, d.date) as rolling_count_vaccinated
FROM
	CovidDeaths d
		JOIN
	CovidVaccinations v ON d.location = v.location AND d.date = v.date
WHERE v.new_vaccinations IS NOT NULL AND d.continent IS NOT NULL
ORDER BY 1,2,3;

# Expand further by seeing statistics of rolling population vaccinations
  -- Using a CTE --
WITH cte AS (SELECT 
	d.continent, d.location, d.date, d.population, v.new_vaccinations, SUM(v.new_vaccinations) OVER (Partition by d.location ORDER BY d.location, d.date) as rolling_count_vaccinated
    FROM 
		CovidDeaths d
			JOIN
		CovidVaccinations v ON d.location = v.location AND d.date = v.date
	WHERE v.new_vaccinations IS NOT NULL AND d.continent IS NOT NULL)
SELECT *
FROM cte;

# Refine the CTE & query with specifics on what you are looking for
WITH cte AS (SELECT 
	d.continent, d.location, d.date, d.population, v.new_vaccinations, SUM(v.new_vaccinations) OVER (Partition by d.location ORDER BY d.location, d.date) as rolling_count_vaccinated
    FROM 
		CovidDeaths d
			JOIN
		CovidVaccinations v ON d.location = v.location AND d.date = v.date
	WHERE v.new_vaccinations IS NOT NULL AND d.continent IS NOT NULL)
SELECT 
	*, (rolling_count_vaccinated/population)*100 as rolling_percent_vaccinated
FROM
	cte;
	
  -- Same query concept now using a TEMPORARY TABLE --
DROP TEMPORARY TABLE IF EXISTS rolling_count_vac;

CREATE TEMPORARY TABLE rolling_count_vac
SELECT 
	d.continent, d.location, d.date, d.population, v.new_vaccinations, SUM(v.new_vaccinations) OVER (Partition by d.location ORDER BY d.location, d.date) as rolling_count_vaccinated
FROM 
	CovidDeaths d
		JOIN
	CovidVaccinations v ON d.location = v.location AND d.date = v.date
WHERE v.new_vaccinations IS NOT NULL AND d.continent IS NOT NULL;

SELECT
	*,
    (rolling_count_vaccinated/population)*100 as rolling_percent_vaccinated
FROM rolling_count_vac;


  -- Creating VIEW to store data for later visualizations --
Create or Replace VIEW rolling_vaccinations AS
SELECT 
	d.continent, d.location, d.date, d.population, v.new_vaccinations, SUM(v.new_vaccinations) OVER (Partition by d.location ORDER BY d.location, d.date) as rolling_count_vaccinated
FROM 
	CovidDeaths d
		JOIN
	CovidVaccinations v ON d.location = v.location AND d.date = v.date
WHERE v.new_vaccinations IS NOT NULL AND d.continent IS NOT NULL;