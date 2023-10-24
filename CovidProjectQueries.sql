select *
from CovidProject..CovidDeaths
where continent is not null
order by 3,4

--select data for analysis
select location, date, total_cases, new_cases, total_deaths, population
from CovidProject..CovidDeaths
where population is not null
order by 1,2

-- total cases vs total deaths
-- percent of cases that resulted in deaths
select location, date, population, total_cases, total_deaths, (CONVERT(float, total_deaths) / CONVERT(float, total_cases)) * 100 as DeathPercentage
from CovidProject..CovidDeaths
where population is not null and continent is not null --and location = 'United States'
order by 1,2

-- total cases vs population
-- percent of population that contracted Covid
select location, date, population, total_cases, (CONVERT(float, total_cases) / CONVERT(float, population)) * 100 as PercentPopulationInfected
from CovidProject..CovidDeaths
where population is not null --and location = 'United States'
order by 1,2

-- countries with highest infection rate compared to population
select location, population, MAX(CONVERT(float, total_cases)) as HighestInfectionCount, MAX(CONVERT(float, total_cases) / CONVERT(float, population)) * 100 as PercentPopulationInfected
from CovidProject..CovidDeaths
where population is not null --and location = 'United States'
group by location, population
order by PercentPopulationInfected desc

-- countries with highest death count per population
select location, MAX(CONVERT(float, total_deaths)) as TotalDeathCount
from CovidProject..CovidDeaths
where population is not null and continent is not null
group by location
order by TotalDeathCount desc


-- CONTINENT

-- continents and classes with highest death count per population
select location, MAX(CONVERT(float, total_deaths)) as TotalDeathCount
from CovidProject..CovidDeaths
where population is not null and continent is null
group by location
order by TotalDeathCount desc


-- GLOBAL

select date, SUM(new_cases) as NewCases, SUM(new_deaths) as NewDeaths, SUM(new_deaths) / SUM(new_cases) * 100 as DeathPercentage
from CovidProject..CovidDeaths
where population is not null and continent is not null and new_cases != 0
group by date
order by 1,2

-- Total population vs vaccinated population
with TotalPopulationVSVaccinationCount (continent, location, date, population, new_vaccinations, RollingVaccinationCount)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(float, vac.new_vaccinations)) over (partition by dea.location order by dea.location,
dea.date) as RollingVaccinationCount
from CovidProject..CovidDeaths dea
join CovidProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null and dea.population is not null
)
select *, (RollingVaccinationCount / population) as VaccinationsPerPerson
from TotalPopulationVSVaccinationCount


-- creating view for later visualizations
create view TotalPopulationVSVaccinationCount as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(float, vac.new_vaccinations)) over (partition by dea.location order by dea.location,
dea.date) as RollingVaccinationCount
from CovidProject..CovidDeaths dea
join CovidProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null and dea.population is not null

select * from TotalPopulationVSVaccinationCount