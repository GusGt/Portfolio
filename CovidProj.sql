SELECT *
From Portfolio_Prog..CovidDeaths
Where continent is not null
order by 3,4

--SELECT *
--From Portfolio_Prog..CovidVaccinations$
--order by 3,4

--Selecting Data to be used

Select Location, date, total_cases, new_cases, total_deaths, population
From Portfolio_Prog..CovidDeaths
Where continent is not null
order by 1,2
--Basic Query shows when the first deaths began to occur (specifically in afghanistan, first death ~one month from first case)

--Shows Percentage of deaths according to total cases within the United States
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathRate
From Portfolio_Prog..CovidDeaths
where location = 'United States'
order by 1,2

--Locating countries with most infection rate according to population
Select Location, population, MAX(total_cases) as HighestInfected, MAX((total_cases/population))*100 as PercentInfected
From Portfolio_Prog..CovidDeaths
Group by location, population
order by PercentInfected desc

--Showing countries with highest mortality rate
Select Location, MAX(cast(total_deaths as int)) as DeathCount
From Portfolio_Prog..CovidDeaths
Where continent is not null
Group by location
order by DeathCount desc


--Showing continent mortality rates
Select location, MAX(cast(total_deaths as int)) as DeathCount
From Portfolio_Prog..CovidDeaths
Where continent is null
Group by location
order by DeathCount desc

--Global statistics on each date since beginning of data collection
Select date, SUM(new_cases) as totalCases, SUM(cast(new_deaths as int)) as totalDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as Percentage
From Portfolio_Prog..CovidDeaths
where continent is not null
Group by date
order by 1,2

--Global numbers of all data collection
Select SUM(new_cases) as totalCases, SUM(cast(new_deaths as int)) as totalDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as Percentage
From Portfolio_Prog..CovidDeaths
where continent is not null
order by 1,2


--COVID VACCINATIONS DATA EXPLORATION--

Select *
From Portfolio_Prog..CovidDeaths deaths
join Portfolio_Prog..CovidVaccinations$ vacs
	On deaths.location = vacs.location
	and deaths.date = vacs.date

With OverallVacs (Continent, Location, Date, population, New_Vaccinations, AggregatedCountVacs)
as 
(
Select deaths.continent, deaths.location, deaths.date, deaths.population, vacs.new_vaccinations, 
SUM(CONVERT(bigint, vacs.new_vaccinations)) OVER (Partition by deaths.location Order by deaths.location, deaths.Date) as AggregatedCountVacs
From Portfolio_Prog..CovidDeaths deaths
join Portfolio_Prog..CovidVaccinations$ vacs
	On deaths.location = vacs.location
	and deaths.date = vacs.date
where deaths.continent is not null
)
Select *, (AggregatedCountVacs/Population)*100
From OverallVacs


--Temp Table practice--

DROP Table if exists #PercentofVacs
Create Table #PercentofVacs
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
AggregatedCountVacs numeric
)

Insert into #PercentofVacs
Select deaths.continent, deaths.location, deaths.date, deaths.population, vacs.new_vaccinations, 
SUM(CONVERT(bigint, vacs.new_vaccinations)) OVER (Partition by deaths.location Order by deaths.location, deaths.Date) as AggregatedCountVacs
From Portfolio_Prog..CovidDeaths deaths
join Portfolio_Prog..CovidVaccinations$ vacs
	On deaths.location = vacs.location
	and deaths.date = vacs.date
where deaths.continent is not null

Select *, (AggregatedCountVacs/Population)*100
From #PercentofVacs

------------------------


--VIEWS for Visualizations--

Create View PercentofVacs as
Select deaths.continent, deaths.location, deaths.date, deaths.population, vacs.new_vaccinations, 
SUM(CONVERT(bigint, vacs.new_vaccinations)) OVER (Partition by deaths.location Order by deaths.location, deaths.Date) as AggregatedCountVacs
From Portfolio_Prog..CovidDeaths deaths
join Portfolio_Prog..CovidVaccinations$ vacs
	On deaths.location = vacs.location
	and deaths.date = vacs.date
where deaths.continent is not null


Select *
From PercentofVacs