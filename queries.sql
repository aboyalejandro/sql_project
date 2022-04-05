-- Normal queries

select *
from comments;

select *
from courses; 

select *
from locations; 

select *
from schools; 

select *
from badges; 

-- Performance per school

select school, sum(isAlumni) as alumni_votes, avg(overallScore) as score, avg(overall) as overall, avg(curriculum) as curriculum, avg(jobSupport) as jobSupport
from comments
group by school
order by alumni_votes desc;

-- Votes and score per jobTitle

select jobTitle, sum(isAlumni) as alumni_votes, avg(overallScore) as score
from comments
where jobTitle is not null 
group by jobTitle
order by alumni_votes desc;

-- Courses by school

select school, courses, COUNT(courses) as test_count_courses
from courses
group by school, courses
order by test_count_courses desc;

-- Qty of location where includes not online and online location 

select school, COUNT("city.name") as locations
from locations
where description != 'Online'
group by school
order by locations desc;

select school, COUNT("city.name") as locations
from locations
where description = 'Online'
group by school
order by locations desc;

-- Badges top features per school

select s.school as school, COUNT(b.name) as badges_count -- ,b.name as badge
from schools as s
inner join badges as b
	on s.school_id = b.school_id
group by school
order by badges_count desc;

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