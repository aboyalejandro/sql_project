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
where school LIKE ‘%ironhack%’ and description != ‘Online’;
-- Top Cities by number of courses offered (total) outside US and excluding Ironhack
SELECT city_name, count(*)
FROM locations
WHERE description != ‘Online’ and country_id != 1 and  school != ‘ironhack’
GROUP BY city_name
ORDER BY count(*) DESC;