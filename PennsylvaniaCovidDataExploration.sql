-- Pennsylvania Covid Deaths Exploration
-- Chaning date column from string to date type
update pennsylvaniadeathsbycounty
set Date_of_Death = STR_TO_DATE(Date_of_Death,'%m/%d/%Y');

-- Show full table
select *
from pennsylvaniadeathsbycounty
order by Date_of_Death;

-- Columns of Interest
select County_Name, New_Deaths, Total_Deaths, Population2019
from pennsylvaniadeathsbycounty;

-- Deaths_to_Date vs County Population
select County_Name as County, max(Total_Deaths) as Deaths_to_Date, max(Population2019) as Population2019, ((max(Total_Deaths)/max(Population2019))*100) as DeathPercentage
from pennsylvaniadeathsbycounty
group by County_Name
order by Deaths_to_Date asc;

-- Raw single day deaths
select County_Name as County, max(New_Deaths) as Most_Single_Day_Deaths, avg(New_Deaths) as Avg_Single_Day_Deaths
from pennsylvaniadeathsbycounty
group by County_Name
order by Most_Single_Day_Deaths asc;

-- Single day deaths per 100 hundred thousand
select County_Name as County,
	   ((max(New_Deaths)/max(Population2019))*100000) as Most_Single_Day_Deaths_per_Hundredthousand,
       ((avg(New_Deaths)/max(Population2019))*100000) as Avg_Single_Day_Deaths_per_Hundredthousand
from pennsylvaniadeathsbycounty
group by County_Name
order by Avg_Single_Day_Deaths_per_Hundredthousand;

-- Pennsylvania Covid Cases Exploration
-- Update date column from string to date type
update pennsylvaniacasesbycounty
set Date = STR_TO_DATE(Date,'%m/%d/%Y');

-- Show full table
select * 
from pennsylvaniacasesbycounty
order by Date;

-- Columns of Interest
select Jurisdiction, New_Cases, Cumulative_Cases, Population2019
from pennsylvaniacasesbycounty;

-- Cases to Date vs County Population
select Jurisdiction, max(Cumulative_cases) as Cases_to_Date, max(Population2019) as Population2019, ((max(Cumulative_cases)/max(Population2019))*100) as CasePercentage
from pennsylvaniacasesbycounty
group by Jurisdiction
order by Cases_to_Date;

-- Raw single day cases
select Jurisdiction as County, max(New_Cases) as Most_Single_Day_Cases, avg(New_Cases) as Avg_Single_Day_Cases
from pennsylvaniacasesbycounty
group by County
order by Most_Single_Day_Cases asc;

-- Single day cases per 100 hundred thousand
select Jurisdiction as County,
	   ((max(New_Cases)/max(Population2019))*100000) as Most_Single_Day_Cases_per_Hundredthousand,
       ((avg(New_Cases)/max(Population2019))*100000) as Avg_Single_Day_Cases_per_Hundredthousand
from pennsylvaniacasesbycounty
group by County
order by Avg_Single_Day_Cases_per_Hundredthousand;

-- Deaths vs Cases
select County,
       max(a.Cases) Cases,
	   max(a.Deaths) Deaths,
       ((max(a.Deaths)/max(a.Cases))*100) as Deaths_per_Hundred_Cases,
       max(a.Population2019) Population2019
from(
Select deaths.County_Name as County, 
       0 as Cases, 
       deaths.Total_Deaths as Deaths,
       deaths.Population2019 as Population2019
From pennsylvaniadeathsbycounty deaths
union all
Select cases.Jurisdiction as County, 
       cases.Cumulative_cases as Cases, 
       0 as Deaths,
       0 as Population2019
From pennsylvaniacasesbycounty cases) a
group by County
order by Deaths_per_Hundred_Cases asc;
