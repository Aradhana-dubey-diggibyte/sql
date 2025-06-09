CREATE DATABASE UniversityDB;
USE UniversityDB;


-- Students table
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    name VARCHAR(100),
    age INT CHECK (age >= 17),
    email VARCHAR(100) UNIQUE
);

--  professors table
CREATE TABLE Professors (
    professor_id INT PRIMARY KEY,
    name VARCHAR(100),
    department VARCHAR(50)
);

--courses table
CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    professor_id INT,
    FOREIGN KEY (professor_id) REFERENCES Professors(professor_id)
);

--enrollments table
CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    grade CHAR(2),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

--insert professors
INSERT INTO Professors VALUES 
(1, 'Dr. Sharma', 'Mathematics'),
(2, 'Dr. Reddy', 'Computer Science'),
(3, 'Dr. Rao', 'Physics');

--insert courses
INSERT INTO Courses VALUES 
(101, 'Calculus', 1),
(102, 'Data Structures', 2),
(103, 'Quantum Mechanics', 3),
(104, 'Linear Algebra', 1);

--insert students
INSERT INTO Students VALUES 
(1001, 'Amit', 19, 'amit@gmail.com'),
(1002, 'Bhavna', 20, 'bhavna@yahoo.com'),
(1003, 'Chirag', 22, 'chirag@gmail.com'),
(1004, 'Divya', 18, 'divya@outlook.com');

--insert enrollments
INSERT INTO Enrollments VALUES 
(201, 1001, 101, 'A'),
(202, 1002, 102, 'B'),
(203, 1003, 101, 'A'),
(204, 1003, 103, 'C'),
(205, 1001, 102, 'B'),
(206, 1002, 103, 'A');

-- ex: INNER JOIN Students with Courses through Enrollments
SELECT S.name AS Student, C.course_name
FROM Students S
JOIN Enrollments E ON S.student_id = E.student_id
JOIN Courses C ON E.course_id = C.course_id;

-- Ex2: LEFT JOIN Students (including those not enrolled)
SELECT S.name, E.grade
FROM Students S
LEFT JOIN Enrollments E ON S.student_id = E.student_id;

-- Ex3: Join Courses and Professors
SELECT C.course_name, P.name AS Professor
FROM Courses C
JOIN Professors P ON C.professor_id = P.professor_id;

SELECT C.course_name, S.name AS Student
FROM Courses C
RIGHT JOIN Enrollments E ON C.course_id = E.course_id
RIGHT JOIN Students S ON S.student_id = E.student_id;

-- students with enrollments
SELECT S.student_id, S.name, E.course_id
FROM Students S
LEFT JOIN Enrollments E ON S.student_id = E.student_id

UNION

-- enrollments without valid student (in case of bad data)
SELECT E.student_id, NULL AS name, E.course_id
FROM Enrollments E
LEFT JOIN Students S ON S.student_id = E.student_id
WHERE S.student_id IS NULL;

-- Ex1: Age >= 20
SELECT name FROM Students WHERE age >= 20;

-- Ex2: Age > 18 AND email from gmail
SELECT name FROM Students WHERE age > 18 AND email LIKE '%@gmail.com';

-- Ex3: Age BETWEEN 18 and 21
SELECT name FROM Students WHERE age BETWEEN 18 AND 21;

-- Ex1: Students enrolled in 'Calculus'
SELECT name FROM Students
WHERE student_id IN (
    SELECT student_id FROM Enrollments
    WHERE course_id = (
        SELECT course_id FROM Courses WHERE course_name = 'Calculus'
    )
);

-- Ex: Professors teaching more than 1 course
SELECT name FROM Professors
WHERE professor_id IN (
    SELECT professor_id FROM Courses
    GROUP BY professor_id
    HAVING COUNT(course_id) > 1
);

-- Ex: Students enrolled in all courses taught by 'Dr. Sharma'
SELECT name FROM Students
WHERE student_id IN (
    SELECT student_id FROM Enrollments
    WHERE course_id IN (
        SELECT course_id FROM Courses
        WHERE professor_id = (
            SELECT professor_id FROM Professors WHERE name = 'Dr. Sharma'
        )
    )
);


