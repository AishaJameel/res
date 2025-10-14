create database university_management;
use university_management;
create table department(
dep_id int primary key,
dep_name varchar(100),
building varchar(100)
);
create table instructor(
instructor_id int primary key,
dep_id int,
foreign key (dep_id) references department(dep_id),
first_name varchar(50),
last_name varchar(50),
email varchar(100),
hire_date date,
salary decimal(10,2)
);
create table students(
student_id int primary key,
first_name varchar(50),
last_name varchar(50),
email varchar(100),
dob date,
admission_year year,
status enum('active','graduated','dropped')
);
create table courses(
course_id int primary key,
dep_id int,
foreign key (dep_id) references department(dep_id),
course_course varchar(10),
title varchar(100),
credits int
);
create table course_offerings(
offering_id int primary key,
course_id int,
foreign key (course_id) references courses(course_id),
instructor_id int,
foreign key (instructor_id) references instructor(instructor_id),
semester varchar(100),
seats int
);
create table enrollments(
enroll_id int primary key,
student_id int,
foreign key (student_id) references students(student_id)on delete cascade,
offering_id int,
foreign key (offering_id) references course_offerings(offering_id),
enroll_date date,
grade varchar(2),
status enum('enrolled','dropped','completed')
);
alter table students add column phone_no varchar(50);
select * from students;
alter table students rename column status to student_status;
alter table instructor drop column salary;
select * from instructor;
INSERT INTO department VALUES
(1, 'Computer Science', 'Block A'),
(2, 'IT', 'Block B'),
(3, 'IT', 'Block C'),
(4, 'Computer Science', 'Block D'),
(5, 'Mathematics', 'Block E');
INSERT INTO instructor VALUES
(101, 1, 'Aisha', 'Khan', 'aisha.khan@uni.edu', '2019-03-15'),
(102, 2, 'Bilal', 'Ahmed', 'bilal.ahmed@uni.edu', '2020-06-10'),
(103, 3, 'Sara', 'Raza', 'sara.raza@uni.edu', '2018-01-22'),
(104, 4, 'Omar', 'Farooq', 'omar.farooq@uni.edu', '2021-07-12'),
(105, 5, 'Zainab', 'Ali', 'zainab.ali@uni.edu', '2022-02-01');
INSERT INTO students(student_id,first_name,last_name,email,dob,admission_year,student_status)
VALUES
(201, 'Romaisa', 'Dildar', 'romaisa.d@uni.edu', '2003-05-12', 2021, 'active'),
(202, 'Aisha', 'Jameel', 'aisha.j@uni.edu', '2002-09-18', 2020, 'graduated'),
(203, 'Hamza', 'Iqbal', 'hamza.i@uni.edu', '2004-02-25', 2022, 'active'),
(204, 'Fatima', 'Nadeem', 'fatima.n@uni.edu', '2003-11-03', 2021, 'active'),
(205, 'Ali', 'Raza', 'ali.r@uni.edu', '2001-07-19', 2019, 'graduated');
INSERT INTO courses VALUES
(301, 1, 'CS101', 'Introduction to Programming', 3),
(302, 1, 'CS102', 'Database Systems', 3),
(303, 2, 'EE201', 'Circuit Analysis', 4),
(304, 4, 'BA101', 'Principles of Management', 3),
(305, 5, 'MA101', 'Database Systems', 3);
INSERT INTO course_offerings VALUES
(401, 301, 101, 'Fall 2024', 40),
(402, 302, 101, 'Spring 2025', 35),
(403, 303, 102, 'Fall 2024', 30),
(404, 304, 104, 'Fall 2024', 45),
(405, 305, 105, 'Spring 2025', 50);
INSERT INTO enrollments VALUES
(501, 201, 401, '2024-09-01', 'A', 'completed'),
(502, 202, 402, '2025-02-10', 'B', 'enrolled'),
(503, 203, 403, '2024-09-03', 'A', 'completed'),
(504, 204, 404, '2024-09-05', 'B', 'enrolled'),
(505, 205, 405, '2025-02-15', 'C', 'enrolled');
select * from instructor;
UPDATE instructor
SET salary = 90000
WHERE instructor_id IN (
  SELECT instructor_id 
  FROM course_offerings
  JOIN courses ON course_offerings.course_id = courses.course_id
  WHERE courses.title = 'Database Systems'
);
alter table instructor add column salary int;
delete from students where admission_year < 2020;
update courses
set title="programming fundamentals"
where title="Introduction to Programming";
select * from courses;
SELECT * FROM students WHERE student_id = 2;
SELECT * FROM course_offerings WHERE offering_id = 1;
select concat(first_name,' ',last_name) as full_name from students where student_status='active' order by last_name;
select * from instructor order by hire_date desc limit 5;
select distinct admission_year from students;
SELECT *
FROM students
WHERE TIMESTAMPDIFF(YEAR, dob, CURDATE()) < 20;
SELECT *
FROM courses
WHERE credits > 3;
SELECT 
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    c.title AS course_title,
    co.semester
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN course_offerings co ON e.offering_id = co.offering_id
JOIN courses c ON co.course_id = c.course_id;
SELECT 
    CONCAT(i.first_name, ' ', i.last_name) AS instructor_name,
    c.title AS course_title
FROM instructor i
JOIN course_offerings co ON i.instructor_id = co.instructor_id
JOIN courses c ON co.course_id = c.course_id;
SELECT 
    c.title AS course_title,
    COUNT(e.student_id) AS total_students
FROM courses c
JOIN course_offerings co ON c.course_id = co.course_id
LEFT JOIN enrollments e ON co.offering_id = e.offering_id
GROUP BY c.title;
SELECT 
    CONCAT(s.first_name, ' ', s.last_name) AS student_name
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
WHERE e.enroll_id IS NULL;
SELECT 
    CONCAT(i.first_name, ' ', i.last_name) AS instructor_name,
    d.dep_name AS department
FROM instructor i
JOIN department d ON i.dep_id = d.dep_id
WHERE d.dep_name = 'Computer Science';
SELECT 
    d.dep_name AS department_name,
    COUNT(s.student_id) AS total_students
FROM department d
JOIN courses c ON d.dep_id = c.dep_id
JOIN course_offerings co ON c.course_id = co.course_id
JOIN enrollments e ON co.offering_id = e.offering_id
JOIN students s ON e.student_id = s.student_id
GROUP BY d.dep_name;

SELECT AVG(grade) AS average_gpa
from enrollments;
SELECT 
    MIN(credits) AS min_credits,
    MAX(credits) AS max_credits
FROM courses;
SELECT 
    COUNT(instructor_id) AS instructors_above_70000
FROM instructor
WHERE salary > 70000;
SELECT 
    s.first_name, 
    s.last_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN course_offerings co ON e.offering_id = co.offering_id
JOIN instructor i ON co.instructor_id = i.instructor_id
WHERE i.salary = (SELECT MAX(salary) FROM instructor);