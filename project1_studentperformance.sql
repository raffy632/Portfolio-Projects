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

-- Attendance vs Exam Scores
select 
Attendance,
round(avg(Exam_Score), 2) as avg_exam_score,
count(*) as student_count
from my_portfolio_project1.studentperformancefactors
group by Attendance 
order by Attendance desc;
-- students that attended all classes on average scored higher on exam scores

-- Motivation Level vs Exam Score
select 
Motivation_Level,
round(avg(Exam_Score), 2) as avg_exam_score,
count(*) as student_count
from my_portfolio_project1.studentperformancefactors
group by Motivation_Level 
order by Motivation_Level desc;
-- interestingly enough, the difference between a highly motivated student vs a lowly motivated student the difference in their exam scores is 0.95%


-- taking it further we can use a CTE and a Window Function to compare the groups to the overall average
with cleaned_data as (
-- this is to handle the previous fake null values in the data
select
school_type,
parental_involvement,
exam_score, 
case 
when trim(teacher_quality) = '' or teacher_quality is null then 'not reported'
else teacher_quality 
end as teacher_status
from my_portfolio_project1.studentperformancefactors
)
select 
teacher_status,
school_type,
-- we calculate averages for the specific groups
round(avg(exam_score), 2) as avg_score,
-- now using the a Window Function by using Baseline and creates the averages of scores for both the school types
-- allowing us to go "apples for apples" comparison 
round(avg(avg(exam_score)) over(partition by school_type), 2) as school_type_baseline,
-- we now calculate the gap, variance analysis
round(avg(exam_score) - avg(avg(exam_score)) over(partition by school_type), 2) as performance_gap
from cleaned_data
group by teacher_status, school_type
order by school_type, performance_gap desc;
-- teacher quality has higher impact on the exam scores in public schools rather than private
-- the performance gap between high quality public school teachers vs low is 1.14 points
-- while in private schools its only 0.40 points



