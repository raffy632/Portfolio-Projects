/* Personal Project: Student Performance Analysis 
Goal: Identifying the drivers for a succesful exam score */ 

create database my_portfolio_project1;

select * 
from my_portfolio_project1.studentperformancefactors; 
-- once the dataset is in, let's check for any dirty data, as a way to verify the dataset


select min(Exam_score) as min_score,
 max(Exam_Score) as max_score, 
 avg(Exam_score) as avg_score 
 from my_portfolio_project1.studentperformancefactors; 
-- there is a max score of 101, I will leave it in the dataset because I am assuming that this person got a bonus mark but otherwise the dataset looks accurate and realistic


-- Analysis


-- Hours Studied vs Sleeping Hours, does sleeping more help? 
select 
Sleep_Hours,
Hours_Studied,
Exam_Score 
from my_portfolio_project1.studentperformancefactors;
-- now let's group them


select
Sleep_Hours, 
round(avg(Exam_Score), 2) as avg_exam_score,
count(*) as student_count
from my_portfolio_project1.studentperformancefactors
group by Sleep_Hours
order by Sleep_Hours DESC;
-- the data shows that sleeping well or not well does NOT usually result in a better exam score

select * 
from my_portfolio_project1.studentperformancefactors;

-- Teacher Quality vs Exam Scores
select 
Teacher_Quality,
round(avg(Exam_Score), 2) as avg_exam_score,
count(*) as student_count
from my_portfolio_project1.studentperformancefactors
group by Teacher_Quality;
-- now there are 78 students that did not have a label for their teacher quality, it can simply be due to human error or a data gap
-- in the results it did not differ much between the labeled data but let's investigate
 
 select distinct teacher_quality 
from my_portfolio_project1.studentperformancefactors;
-- this is to find out exactly what is put in the cell
-- they are appearing as empty in results but have actual characters in them

select school_type, count(*) as missing_count
from my_portfolio_project1.studentperformancefactors
where trim(teacher_quality) = '' 
or teacher_quality is null
group by school_type;
-- used the TRIM command to clean up the fake nulls in the Teacher_Quality columns
-- most of the students were public and the rest are 23, now lets narrow it down even more to see if we can explain this

select *
from my_portfolio_project1.studentperformancefactors
where Teacher_Quality is null 
or Teacher_Quality = '' 
or Teacher_Quality = ' ';

select Tutoring_Sessions, count(*) as missing_count
from my_portfolio_project1.studentperformancefactors
where trim(teacher_quality) = '' 
or teacher_quality is null
group by Tutoring_Sessions;
-- now this shows that the students that some tutoring







