-- Data is from World Health Orgainzation Coronavirus Dashboard

-- Received Data in CSV format. Given the excess data, I decided to narrow down the data in Excel to information related to the USA, and constructed two tables. 
---   Table one related to information on covid deaths in the US and the other table on information related to covid vaccinations in the USA. 


create table Covid_death(
	iso_code varchar(25),
	date_Covid date,
	total_cases int,
	new_cases int, 
	total_deaths int,
	new_deaths int,
	icu_patient int, 
	hosp_patients int,
	
	primary key(iso_code,date_Covid)

);
select * from Covid_death;

create table Covid_Vaccinations(
	iso_code varchar(25),
	date_Covid date,
	total_vaccination int, 
	people_vaccinated decimal(10,4),
	people_fully_vaccinated decimal(10,4),
	total_boosters decimal(10,4),
	new_vaccinations varchar(30),
	diabetes_prevalence decimal(10,4),
	life_expectancy decimal(10,4),
	population int,

	primary key(iso_code,date_Covid)
	
);

select * from covid_vaccinations;
select * from covid_death;

-- Find the deaths/cases for dates between 2020 and 2024 in the USA.

select iso_code,date_covid,total_cases,new_cases,total_deaths,new_deaths 
from covid_death;

-- Find the percent death by the total cases in the USA.
select date_covid,total_cases,total_deaths, (total_deaths/cast(total_cases as decimal(45,15)))*100 as percent_of_death 
from covid_death;

-- Find the percent of the people in the USA who came into contact with Covid
select total_cases from covid_death;

select covid_death.total_cases, covid_vaccinations.population,covid_vaccinations.date_Covid,covid_death.total_cases/cast(covid_vaccinations.population as decimal(50,10))*100 as percent_contact_with_covid
from covid_death
join covid_vaccinations
on covid_death.date_Covid = covid_vaccinations.date_Covid;
-- A error or important format in which the data was published is that total_cases kept increasing, and using the top formula, its seems like it summed the total_cases after each day. Not the total_cases found in that day.

-- Show the new deaths and new cases in the USA. Data is obtained after a week, which can be seen in the table
select new_deaths,new_cases, date_Covid
from Covid_death; 


-- Shows the data where new deaths/cases was being entered.
select new_deaths,new_cases, date_Covid
from Covid_death 
where new_deaths <> 0;

-- Lets see the percent of new deaths for new cases after a week, during the 2020 - 2024 period.
select new_deaths,new_cases, date_Covid, (new_deaths/cast(new_cases as decimal(45,10)))*100 as percent_new_deaths_cases
from Covid_death
where new_cases <> 0
-- shows largest percent at top
order by percent_new_deaths_cases desc;


-- from the data above, show the number of patients in hospital  and in ICU
select icu_patient, hosp_patients , date_Covid , new_cases , new_deaths ,(new_deaths/cast(new_cases as decimal(45,10)))*100 as percent_new_deaths_cases
from Covid_death
where date_Covid in (
	select date_Covid from Covid_death
	where new_cases<> 0

)
order by percent_new_deaths_cases desc;




select date_Covid,iso_code,icu_patient, hosp_patients , new_cases , new_deaths ,(new_deaths/cast(new_cases as decimal(45,10)))*100 as percent_new_deaths_cases
from Covid_death
where date_Covid in (
	select date_Covid from Covid_death
	where new_cases<> 0

)
order by new_cases desc;
-- order by new_deaths desc;
-- order by icu_patient;
   -- Many great ways to order data.



-- Now lets focus on the seond table.
select * from covid_vaccinations;

--Lets see the people fully vaccinated, new deaths, and the date. 
select date_Covid,new_deaths from covid_death;
select date_Covid,total_vaccination from covid_vaccinations;


-- Lets see the percent of deaths for total vaccination from 2020-2024
select covid_death.date_Covid,covid_death.new_deaths,covid_vaccinations.total_vaccination, covid_vaccinations.total_boosters, round((new_deaths/cast(total_vaccination as decimal(25,5))),5) as newdeaths_for_totalvaccinations
from covid_death
join covid_vaccinations 
on covid_death.date_Covid = covid_vaccinations.date_Covid
where covid_death.new_deaths <> 0 and covid_vaccinations.total_boosters is not NULL
order by newdeaths_for_totalvaccinations desc
limit 30;
-- Looking at the data for the 30 days in which the percent of deaths for total vaccination from 2020-2024 is at its highest.
	-- We see that the highest percent occured during the early stages of Covid, where the Vaccinations were still in production.
	
