select *
from MyPortfolio..CovidDeaths
where continent is not null
order by 3,4


--select *
--from MyPortfolio..CovidVaccination
--order by 3,4


--select data that I am goin to be using:
select location,date, total_cases, new_cases, total_deaths, population
from MyPortfolio..CovidDeaths
order by 1, 2

--Looking at total cases vs total deaths:
select location,date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPer
from MyPortfolio..CovidDeaths
where location like '%Mauritania%'
order by 1,2


--what persentage of population got Covid:
select location,date, total_cases,population,(total_cases/population)*100 as CasesPer
from MyPortfolio..CovidDeaths
where location like '%Canada%'
order by 1,2

--looking at the countries with the highest infection rate compared to population:
select location, population, Max(total_cases) as highestInfectionCount, Max((total_cases/population))*100 as PercentPolulationInfect
from MyPortfolio..CovidDeaths
group by location, population
order by PercentPolulationInfect desc

--showing countries with highest deats counts per poputation:
select location, Max(cast(total_deaths as int)) as totalDeathCounts
from MyPortfolio..CovidDeaths
where continent is not null  --to remove the name of the continet from th location
group by location
order by totalDeathCounts desc

--Let's bring things down by Continent:
select continent, Max(cast(total_deaths as int)) as totalDeathCounts
from MyPortfolio..CovidDeaths
where continent is not null  --to remove the name of the continet from th location
group by continent
order by totalDeathCounts desc

select location, Max(cast(total_deaths as int)) as totalDeathCounts
from MyPortfolio..CovidDeaths
where continent is null  --to remove the name of the continet from th location
group by location
order by totalDeathCounts desc

--showing continents with highest death count per population:
select continent, max(cast(total_deaths as int)/population) as deathCount
from MyPortfolio..CovidDeaths
group by continent
order by deathCount

--global Numbers:
select sum(new_cases) as totolCases, sum(cast(new_deaths as int)) as totalDeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from MyPortfolio..CovidDeaths
where continent is not null
----------------------------------------------------------------------------------
--Looking at population vs vaccinations

select det.continent, det.location, det.date, det.population, vac.new_vaccinations
,sum(convert(BIGINT, vac.new_vaccinations)) over(partition by det.location order by det.date ) as RoalingPepoleVaccinated
from MyPortfolio..CovidDeaths det
join MyPortfolio..CovidVaccination vac
   on det.location = vac.location
   and det.date = vac.date
where  det.continent is not null 
order by 2,3

--use CTE
with PepvsVac (continent, location, date,population, new_vaccinations,RoalingPepoleVaccinated )
as (select det.continent, det.location, det.date, det.population, vac.new_vaccinations
,sum(convert(BIGINT, vac.new_vaccinations)) over(partition by det.location order by det.date ) as RoalingPepoleVaccinated
from MyPortfolio..CovidDeaths det
join MyPortfolio..CovidVaccination vac
   on det.location = vac.location
   and det.date = vac.date
where  det.continent is not null 
)
select *, (RoalingPepoleVaccinated/population)*100 as percentage
from PepvsVac

--------------------------------------------------------------------------------------------------------------
--Temp Table
create table #myFirstTable
(
continent nvarchar(255),
 location nvarchar(255),
date datetime,
population numeric ,
new_vaccinations numeric,
RoalingPepoleVaccinated numeric
)
insert into #myFirstTable
select det.continent, det.location, det.date, det.population, vac.new_vaccinations
,sum(convert(BIGINT, vac.new_vaccinations)) over(partition by det.location order by det.date ) as RoalingPepoleVaccinated
from MyPortfolio..CovidDeaths det
join MyPortfolio..CovidVaccination vac
   on det.location = vac.location
   and det.date = vac.date
where  det.continent is not null
order by 2,3
select *,(RoalingPepoleVaccinated/population)*100 as percentage
from #myFirstTable

----------------------------------------------------------
create table #myFirstTable
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric ,
new_vaccinations numeric,
RoalingPepoleVaccinated numeric
)
insert into #myFirstTable
select det.continent,det.location, det.date, det.population, vac.new_vaccinations
,sum(convert(BIGINT, vac.new_vaccinations)) over(partition by det.location order by det.date ) as RoalingPepoleVaccinated
from MyPortfolio..CovidDeaths det
join MyPortfolio..CovidVaccination vac
   on det.location = vac.location
   and det.date = vac.date
where  det.continent is not null
order by 2,3


-----------------------------------------------------
--Create view to store data for later visualization 
drop view if exists myView
create view populationVaccinated as
select det.continent,det.location, det.date, det.population, vac.new_vaccinations
,sum(convert(BIGINT, vac.new_vaccinations)) over(partition by det.location order by det.date ) as RoalingPepoleVaccinated
from MyPortfolio..CovidDeaths det
join MyPortfolio..CovidVaccination vac
   on det.location = vac.location
   and det.date = vac.date
where  det.continent is not null
--order by 2,3

select *
from populationVaccinated












