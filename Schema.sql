--Project: Student Result Processing System
--Step 1: Create Database

CREATE DATABASE StudentResultDB;
GO

USE StudentResultDB;
GO

--Step 2: Create Tables
--Students Table

CREATE TABLE Students (
    StudentID INT PRIMARY KEY IDENTITY(1,1),
    StudentName VARCHAR(100),
    Gender VARCHAR(10),
    Department VARCHAR(50)
);

--Courses Table

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY IDENTITY(1,1),
    CourseName VARCHAR(100),
    Credits INT
);

--Semesters Table

CREATE TABLE Semesters (
    SemesterID INT PRIMARY KEY IDENTITY(1,1),
    SemesterName VARCHAR(20)
);

--Grades Table

CREATE TABLE Grades (
    GradeID INT PRIMARY KEY IDENTITY(1,1),
    StudentID INT,
    CourseID INT,
    SemesterID INT,
    Marks INT,
    GradePoint DECIMAL(3,2),

    FOREIGN KEY(StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY(CourseID) REFERENCES Courses(CourseID),
    FOREIGN KEY(SemesterID) REFERENCES Semesters(SemesterID)
);

 --Step 3: Insert Sample Data
--Students

INSERT INTO Students(StudentName,Gender,Department)
VALUES
('Naresh','Male','CSE'),
('Rahul','Male','ECE'),
('Priya','Female','CSE'),
('Sneha','Female','IT'),
('Kiran','Male','IT');

--Courses

INSERT INTO Courses(CourseName,Credits)
VALUES
('SQL',4),
('Python',3),
('Power BI',3),
('DBMS',4);

--Semesters

INSERT INTO Semesters(SemesterName)
VALUES
('Semester 1'),
('Semester 2');

--Grades

INSERT INTO Grades(StudentID,CourseID,SemesterID,Marks,GradePoint)
VALUES
(1,1,1,85,8.5),
(1,2,1,90,9.0),
(2,1,1,70,7.0),
(3,3,1,95,9.5),
(4,4,1,80,8.0),
(5,2,1,75,7.5);

--Step 4: Display Student Results

SELECT
s.StudentName,
c.CourseName,
g.Marks,
g.GradePoint
FROM Grades g
JOIN Students s ON g.StudentID=s.StudentID
JOIN Courses c ON g.CourseID=c.CourseID;

--Step 5: Calculate GPA

SELECT
s.StudentName,
AVG(g.GradePoint) AS GPA
FROM Grades g
JOIN Students s
ON g.StudentID=s.StudentID
GROUP BY s.StudentName;

--Step 6: Pass / Fail Statistics
--Pass Marks = 40

SELECT
StudentID,
Marks,
CASE
WHEN Marks >= 40 THEN 'PASS'
ELSE 'FAIL'
END AS Result
FROM Grades;

--Step 7: Student Rank List

SELECT
s.StudentName,
AVG(g.GradePoint) AS GPA,
RANK() OVER(
ORDER BY AVG(g.GradePoint) DESC
) AS RankNo
FROM Grades g
JOIN Students s
ON g.StudentID=s.StudentID
GROUP BY s.StudentName;

--Step 8: Create GPA Trigger

CREATE TRIGGER trg_GradeInsert
ON Grades
AFTER INSERT
AS
BEGIN
PRINT 'Grade Record Added Successfully';
END;

--Step 9: Create View

CREATE VIEW StudentGPAView
AS
SELECT
s.StudentName,
AVG(g.GradePoint) AS GPA
FROM Grades g
JOIN Students s
ON g.StudentID=s.StudentID
GROUP BY s.StudentName;

--View Data:

SELECT * FROM StudentGPAView;
SELECT * FROM Students;
SELECT * FROM Courses;
SELECT * FROM Semesters;
SELECT * FROM Grades;