USE sql_project;

SELECT * 
FROM comments;

SELECT *
FROM courses;

SELECT * 
FROM locations;

SELECT * 
FROM schools;

SELECT *
FROM badges;

-- ANALYSIS

-- We are analyzing 78 schools with comments
SELECT school
FROM comments
GROUP BY school;

-- Performance per school
  -- We can see  by the rating of the alumni the performance for each school order by the schools with more alumni
SELECT school, sum(isAlumni) AS alumni_votes,
 AVG(overallscore) AS score,
 AVG(overall) AS overall ,
 avg(curriculum) as curriculim,
 AVG(jobSupport) as jobSupport
FROM comments
GROUP BY school
HAVING alumni_votes > 50;
-- ORDER BY score DESC

-- Ironhack is above the mean for score 
-- Average/mean score 4.6837
SELECT AVG(overallscore) AS score
FROM comments;
-- Average/mean Ironhack score 4.7979
SELECT AVG(overallscore) AS score
FROM comments
WHERE school = 'ironhack';

-- Analysis for the hight vs lowest score for coment vs variation 
SELECT school,
 min(overallScore) AS mix_score,
 max(overallScore) AS max_score,
 max(overallScore) - min(overallScore) AS variation,
 SUM(isAlumni) AS alumni
FROM comments
GROUP BY school
ORDER BY variacion;
-- VALUE TO RATE THE SCHOOLS BY SOCRE AND QTY OF COMMENTS
SELECT 
 school,
 AVG(overallscore)/SUM(isAlumni) AS score_qtyvotes
FROM comments
GROUP BY school
ORDER BY score_qtyvotes DESC;

-- Votes and score per jobTitle
SELECT jobTitle, 
 SUM(isAlumni) AS alumni_votes,
 AVG(overallScore) AS score
FROM comments
WHERE jobTitle IS NOT NULL
GROUP BY jobTitle
ORDER BY alumni_votes DESC;

-- Votes and score per jobTitle in Ironhack
SELECT jobTitle, 
 SUM(isAlumni) AS alumni_votes,
 AVG(overallScore) AS score
FROM comments
WHERE jobTitle IS NOT NULL AND school = 'ironhack'
GROUP BY jobTitle
ORDER BY alumni_votes DESC;

SELECT * FROM comments;
SELECT * FROM courses;
SELECT * FROM locations;
SELECT * FROM schools;
SELECT * FROM badges;

-- How many courses by country 
SELECT case 
		when locations.description = 'Online' then "Online"
        else country_name
	end as country_name , COUNT(distinct school) AS qty_school
FROM locations
GROUP BY country_name
ORDER BY qty_school DESC;

--  1 EVOLUTION OF SCHOOLS THROUGH TIME
--  groth by country over the year, 2020,
-- Inputs for years the top 5  
select c.graduatingYear as g_year,country_name, COUNT(DISTINCT s.school) as school_count, COUNT(distinct c.tagline) as comments_total, avg(c.overall) as overall, avg(c.curriculum) as curriculum, avg(c.jobSupport) as jobSupport
from schools as s
inner join locations as l
	on s.school_id = l.school_id
inner join comments as c
	on s.school = c.school
where c.graduatingYear != '2022' and c.graduatingYear != '0' and l.country_name is not null 
group by country_name, g_year
Having school_count > 5
order by g_year desc, school_count desc;

-- Online
--  groth by country over the year, 2020,
-- Inputs for years the top 5  
select c.graduatingYear as g_year,country_name, l.description AS type_course , COUNT(DISTINCT s.school) as school_count, COUNT(distinct c.tagline) as comments_total, avg(c.overall) as overall, avg(c.curriculum) as curriculum, avg(c.jobSupport) as jobSupport
from schools as s
inner join locations as l
	on s.school_id = l.school_id
inner join comments as c
	on s.school = c.school
where c.graduatingYear != '2022' and c.graduatingYear != '0' and l.description = 'Online'
group by country_name, g_year
Having school_count > 1
order by g_year desc, school_count desc;

-- Courses by school
SELECT school, courses, COUNT(courses) AS test_count_courses
FROM courses
GROUP BY school, courses
ORDER BY test_count_courses DESC;

-- Top 5  Course with highest rate in the last 3 years in IRONHACK
SELECT c.program AS course, AVG(overallScore) AS Score, school
FROM comments as c 
wHERE (graduatingYear < 2022) AND (graduatingYear >= 2019) and school = 'ironhack'
GROUP BY c.program
ORDER BY score DESC
LIMIT 7;


-- Qty of locations which includes not online and online location 
SELECT school, COUNT(country_name) AS locations
FROM locations 
WHERE description != 'Online'
GROUP BY school
ORDER BY locations DESC
LIMIT 11;

-- Badges top features per school
SELECT s.school AS school, COUNT(b.name) as badges_count , b.name as badge
FROM schools AS s
INNER JOIN badges AS b
	ON s.school_id = b.school_id
GROUP BY school
order by badges_count DESC;

-- Qty Badges top features per school
SELECT school, COUNT(name) AS badges_count 
FROM badges 
GROUP BY school
ORDER BY badges_count DESC;

-- Badges top features per school (TBD to put in ppt) puede ser analisis de competencia
SELECT school, name AS badge
FROM badges 
WHERE school = 'ironhack';

SELECT name AS badge
FROM badges 
GROUP BY badge;

-- Evolution in the industry by shools and users/comments
-- Important to split the the analysis by online courses/school
-- Try to identify difference between bootcamp and course

select graduatingYear, COUNT(tagline) as comments_total-- , sum(isAlumni) as alumni_votes,
,avg(overall) as overall, avg(curriculum) as curriculum, avg(jobSupport) as jobSupport
from comments
where graduatingYear != '2022'
group by graduatingYear
order by graduatingYear desc
limit 10;


select graduatingYear, COUNT(DISTINCT school) as school_count, COUNT(tagline) as comments_total-- , sum(isAlumni) as alumni_votes,
,avg(overall) as overall, avg(curriculum) as curriculum, avg(jobSupport) as jobSupport
from comments
where graduatingYear != '2022'
group by graduatingYear
order by graduatingYear desc
limit 10;

-- Online vs onCampus evolution over time by comments and qty of schools

select c.graduatingYear as g_year,
	case 
		when l.description = 'Online' then "Online"
        else 'Campus'
	end as course_type, COUNT(DISTINCT s.school) as school_count, COUNT(distinct c.tagline) as comments_total, avg(c.overall) as overall, avg(c.curriculum) as curriculum, avg(c.jobSupport) as jobSupport
from schools as s
inner join locations as l
	on s.school_id = l.school_id 
inner join comments as c
	on s.school = c.school
where c.graduatingYear != '2022' and c.graduatingYear != '0'
group by course_type, g_year 
order by course_type desc, g_year desc; 

SELECT * FROM comments;
SELECT * FROM courses;
SELECT * FROM locations;
SELECT * FROM schools;
SELECT * FROM badges;


-- Schools
select graduatingYear, COUNT(tagline) as comments_total-- , sum(isAlumni) as alumni_votes,
,avg(overall) as overall, avg(curriculum) as curriculum, avg(jobSupport) as jobSupport
from comments
where graduatingYear != '2022'
group by graduatingYear
order by graduatingYear desc
limit 10;

-- Checking out the cities where Ironhack offers courses
select city_name, school, country_abbrev description, country_name
from locations
where school LIKE '%ironhack%' and description != 'Online';

-- Top Cities by number of courses offered (total) outside US and excluding Ironhack
SELECT city_name, count(*)
FROM locations
WHERE description != ‘Online’ and country_id != 1 and  school != ‘ironhack’
GROUP BY city_name
ORDER BY count(*) DESC;

-- Schools by Country  (On-site/ comments rate over mean)
-- mean commments rate 4.68 / Not Null = Online
SELECT l.country_name, l.country_abbrev ,c.school, AVG(c.overallScore) AS score
FROM comments as c
JOIN locations as l
ON c.school = l.school
GROUP BY country_abbrev,c.school
HAVING score > (SELECT AVG(overallscore) AS score FROM comments) AND country_name IS NOT NULL
ORDER BY country_name, score DESC;

-- COUNT Schools by Country  (On-site/ comments rate over mean)
-- mean commments rate 4.68 / Not Null = Online
SELECT l.country_name,country_abbrev, COUNT( DISTINCT l.school) AS qty_schools
FROM comments as c
JOIN locations as l
ON c.school = l.school
GROUP BY l.country_name
HAVING AVG(c.overallScore) > (SELECT AVG(overallscore) FROM comments) AND country_name IS NOT NULL
ORDER BY country_name;

-- Understand job_vacancy rates on countries where Ironhack is not present
CREATE VIEW job_vacancy_IT_stats AS
select TIME as year, GEO as country, Value as IT_vacancy_rate
from jvs_table
where TIME = '2019' or TIME = '2020' or TIME = '2021' 
					and GEO != 'United States' 
					and GEO != 'Germany' 
					and GEO !='France' 
                    and GEO != 'Spain' 
                    and GEO != 'Portugal' 
                    and GEO != 'Netherlands' 
                    and GEO != 'United Kingdom' 
                    and GEO != 'Brazil' 
                    and GEO != 'Mexico'
order by TIME desc, Value desc;

select *
from job_vacancy_IT_stats
where year = '2019'
limit 5;

select *
from job_vacancy_IT_stats
where year = '2020'
limit 5;

select *
from job_vacancy_IT_stats
where year = '2021'
limit 5;

-- Understand government expenditure on education on countries where Ironhack is not present

ALTER TABLE government_expenditure
RENAME COLUMN `Expenditure ($M)` to Expenditure_M; 

ALTER TABLE government_expenditure
RENAME COLUMN `Education Expenditure (%Bud.)` to Expenditure_budget; 

ALTER TABLE government_expenditure
RENAME COLUMN `Expenditure (%GDP)` to Expenditure_gdp; 

ALTER TABLE government_expenditure
RENAME COLUMN `Ch.` to YOY_growth;

ALTER TABLE government_expenditure
DROP COLUMN `Gov. Health Exp. (%Bud.)`; 

ALTER TABLE government_expenditure
DROP COLUMN `Defence Expenditure (%Bud.)`;  

CREATE VIEW country_expenditure_excluded AS
select distinct ge.Countries, ge.Date, 
				ge.Expenditure_M as expenditure_millions, 
				ROUND(ge.Expenditure_gdp*100,2) as expenditure_gdp, 
                ROUND(ge.Expenditure_budget*100,2) as expenditure_budget, 
                ge.YOY_growth
from locations as l
inner join government_expenditure as ge
	on l.country_name = ge.Countries
					and Countries != 'United States' 
					and Countries != 'Germany' 
					and Countries !='France' 
                    and Countries != 'Spain' 
                    and Countries != 'Portugal' 
                    and Countries != 'Netherlands' 
                    and Countries != 'United Kingdom' 
                    and Countries != 'Brazil' 
                    and Countries != 'Mexico'
order by ge.Expenditure_M desc, ge.Date desc;

select *
from country_expenditure_excluded
where date = '2019'
order by expenditure_millions desc
limit 10;

select *
from country_expenditure_excluded
where date = '2020'
order by expenditure_millions desc
limit 10;

-- Understanding school count share on opportunity countries

CREATE VIEW market_share_schools AS
select l.country_name as country_name, count(distinct s.school) as schools_count
from locations as l
inner join schools as s
	on l.school_id = s.school_id
where country_name is not null 
					and country_name != 'United States' 
					and country_name != 'Germany' 
					and country_name !='France' 
                    and country_name != 'Spain' 
                    and country_name != 'Portugal' 
                    and country_name != 'Netherlands' 
                    and country_name != 'United Kingdom' 
                    and country_name != 'Brazil' 
                    and country_name != 'Mexico'
group by country_name
order by schools_count desc;

select *
from market_share_schools
where country_name = 'Belgium' or country_name = 'Norway' or country_name = 'Canada';

select l.country_name as country_name, s.school as school
from schools as s
inner join locations as l	
	on l.school_id = s.school_id
where country_name = 'Belgium' or country_name = 'Norway' or country_name = 'Canada'
group by  country_name, school
order by country_name desc; 

select l.country_name as country_name, s.school as school, c.courses as courses, -- sum(com.tagline) as comments, 
avg(com.overall) as overall, avg(com.curriculum) as curriculum, avg(com.jobSupport) as job_support
from schools as s
inner join locations as l	
	on l.school_id = s.school_id
inner join courses as c
	on l.school_id = c.school_id
inner join comments as com
	on l.school = com.school
where country_name = 'Belgium' or country_name = 'Norway'  -- or country_name = 'Canada'
group by  country_name, school, courses
HAVING AVG(com.overallScore) > (SELECT AVG(overallscore) FROM comments) -- AND country_name IS NOT NULL
order by country_name desc; 

-- Note: only le-wagon has a franchise model, not a branded model for opening campuses. 
-- Norway: le-wagon is the only one here
-- Canada & Belgium: la-capsule & wild-code-schools mainly works on French speaking countries, so competition would be harder if the bootcamp are not taught in French.
-- Web development courses would the best first option because of the highest overall rates

-- adding location tables

CREATE VIEW locations_tables AS 
select l.country_name as country_name, l.country_abbrev as country_abbrev -- pending metrics to add
from locations as l
inner join gdp_table as gdp
	on l.country_abbrev = gdp.geo
inner join mean_annual_earning as mae
	on l.country_abbrev = mae.geo
inner join part_empl_edu as pee
	on l.country_abbrev = pee.geo
inner join itc_services as itc
	on l.country_name = itc.GEO
inner join jvs_table as jvs
	on l.country_name = jvs.GEO


