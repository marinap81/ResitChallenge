--MARINA PAJVANCIC
--103340660

--RELATIONAL SCHEMA

--SUBJECT(SUBJCODE, DESCRIPTION)
--PRIMARY KEY (SUBJCODE)

--TEACHER (STAFFID, SURNAME, GIVENNAME)
--PRIMARY KEY (STAFFID)

--STUDENT(STUDENTID, SURNAME, GIVENNAME, GENDER)
--PRIMARY KEY (STUDENTID)

--SUBJECTOFFERING (SUBJCODE, YEAR, SEMESTER, FEE, STAFFID)
--PRIMARY KEY (SUBJCODE, YEAR, SEMESTER)
--FOREIGN KEY (SUBJCODE) REF SUBJECT
--FOREIGN KEY (STAFFID) REF TEACHER

--ENROLMENT (STUDENTID, SUBJCODE, YEAR, SEMESTER, GRADE, DATE_ENROLLED,)
--PRIMARY KEY (STUDENTID, YEAR, SEMESTER, SUBJCODE) 
--FOREIGN KEY (STUDENTID, YEAR, SEMESTER, SUBJCODE) REF SUBJECTOFFERING 
--FOREIGN KEY (STUDENTID) REF STUDENT

CREATE TABLE SUBJECT
(
    SUBJCODE NVARCHAR(100),
    DESCRIPTION NVARCHAR(500),
    PRIMARY KEY (SUBJCODE)
);

CREATE TABLE TEACHER 
(STAFFID INT,
 SURNAME NVARCHAR(100) NOT NULL,
 GIVENNAME NVARCHAR(100) NOT NULL,
PRIMARY KEY (STAFFID),
CONSTRAINT CHK_TEACHER_STAFFID CHECK (LEN (STAFFID)= 8));

CREATE TABLE STUDENT
(STUDENTID NVARCHAR(10), 
SURNAME NVARCHAR(100) NOT NULL, 
GIVENNAME NVARCHAR(100) NOT NULL, 
GENDER NVARCHAR(100),
PRIMARY KEY (STUDENTID),
CONSTRAINT CHK_STUDENT_GENDER CHECK (GENDER IN ('M', 'F', 'I')));

CREATE TABLE SUBJECTOFFERING 
(SUBJCODE NVARCHAR(100),
YEAR INT, 
SEMESTER INT,
FEE MONEY not null,
STAFFID INT,
PRIMARY KEY (SUBJCODE,YEAR, SEMESTER),
FOREIGN KEY (SUBJCODE) REFERENCES SUBJECT,
FOREIGN KEY (STAFFID) REFERENCES TEACHER,
CONSTRAINT CHK_SUBJECTOFFERING_SEMESTER CHECK (SEMESTER IN (1,2)),
CONSTRAINT CHK_SUBJECTOFFERING_FEE CHECK (FEE > 0),
CONSTRAINT CHK_SUBJECTOFFERING_YEAR CHECK (LEN (YEAR) = 4),
);

CREATE TABLE ENROLMENT  
(STUDENTID NVARCHAR(10), 
SUBJCODE NVARCHAR(100), 
YEAR INT, 
SEMESTER INT, 
GRADE NVARCHAR(2),
DATE_ENROLLED DATE, 
PRIMARY KEY (STUDENTID, SUBJCODE, YEAR, SEMESTER), /*refereces the primary keys of tables STUDENT AND SUBJOFFERING*/
FOREIGN KEY (SUBJCODE,YEAR, SEMESTER) REFERENCES SUBJECTOFFERING, 
FOREIGN KEY (STUDENTID) REFERENCES STUDENT,
CONSTRAINT CHK_ENROLMENT_YEAR CHECK (LEN (YEAR) = 4),
CONSTRAINT CHK_ENROLMENT_SEMESTER CHECK (SEMESTER IN (1,2))
);

SELECT NAME FROM sys.objects
WHERE TYPE = 'U';

--task 2 completed
INSERT INTO SUBJECT
(SUBJCODE, DESCRIPTION)
VALUES
('ICTPRG418','Apply SQL to extract & manipulate data'),
('ICTBSB430','Create Basic Databases'),
('ICTDBS205', 'Design a Database');

INSERT INTO TEACHER
(STAFFID, SURNAME, GIVENNAME)
VALUES
(98776655,'Young','Angus'),
(87665544,'Scott','Bon'),
(76554433,'Slade','Chris');

INSERT INTO STUDENT
(STUDENTID, SURNAME, GIVENNAME, GENDER)
VALUES
('s12233445','Baird', 'Tim','M'),
('s23344556','Nguyen','Anh','M'),
('s34455667','Hallinan','James','M'),
('s103340660', 'Pajvancic', 'Marina', 'F');

INSERT INTO SUBJECTOFFERING
(SUBJCODE,YEAR, SEMESTER, FEE, STAFFID)
VALUES
('ICTPRG418',	2019,	1,	200,	98776655),
('ICTPRG418',	2020,	1,	225,  98776655),
('ICTBSB430',	2020,	1,	200,	87665544),
('ICTBSB430',	2020,	2,	200,	76554433),
('ICTDBS205',	2019,	2,	225,	87665544);

INSERT INTO ENROLMENT
(STUDENTID, SUBJCODE, YEAR, SEMESTER, GRADE, DATE_ENROLLED)
VALUES
('s12233445',	'ICTPRG418',	2019,	1,	'D',	'02/25/2019'),
('s23344556',	'ICTPRG418',	2019,	1,	'P',	'02/15/2019'),
('s12233445',	'ICTPRG418',	2020,	1,	'C',	'01/30/2020'),
('s23344556',	'ICTPRG418',	2020,	1,	'HD',	'02/26/2020'),
('s34455667',	'ICTPRG418',	2020,	1,	'P',	'01/28/2020'),
('s12233445',	'ICTBSB430',	2020,	1,	'C',	'02/08/2020'),
('s23344556',	'ICTBSB430',	2020,	2,	NULL,	'06/30/2020'),
('s34455667',	'ICTBSB430',	2020,	2,	NULL,	'07/03/2020'),
('s23344556',	'ICTDBS205',	2019,	2,	'P',	'07/01/2019'),
('s34455667',	'ICTDBS205',	2019,	2,	'N',	'07/13/2019'),
('s103340660', 'ICTBSB430',     2020,   2,  'D',    '07/14/2020');

Select * from student

--task 3 completed

--Task 4 Query 1
--Write a query that shows the student first name and surname, the subject code and
--description, the subject offering year, semester & fee and the given name and surname of the
--teacher for that subject offering. 

SELECT ST.GIVENNAME, ST.SURNAME, SO.SUBJCODE, SU.DESCRIPTION, SO.YEAR, SO.SEMESTER, 
SO.FEE, T.GIVENNAME, T.SURNAME
FROM ENROLMENT E 
INNER JOIN SUBJECTOFFERING SO
ON
SO.SUBJCODE = E.SUBJCODE AND SO.YEAR = E.YEAR AND SO.SEMESTER = E.SEMESTER  
                                                                           
INNER JOIN STUDENT ST
ON ST.STUDENTID = E.STUDENTID
INNER JOIN
TEACHER T
ON T.STAFFID=SO.STAFFID
INNER JOIN SUBJECT SU
ON SU.SUBJCODE = SO.SUBJCODE;


--Query 2
--Write a query which shows the number of enrolments, for each year and semester

SELECT YEAR, SEMESTER, COUNT(StudentID) as NumEnrolments
FROM ENROLMENT e
GROUP BY YEAR, SEMESTER
ORDER BY YEAR, SEMESTER;

--Query 3
--Write a query which lists all enrolments which for the subject offering
-- which has the highest fee. (This query must use a sub-query.)

SELECT subjcode, Fee, Max(Fee) as maximumfee
From SubjectOffering
WHERE Fee = (Select Max (Fee) from SubjectOffering)
group by subjcode, fee

--Task 4 complete

--Task 5
CREATE VIEW query1 AS 
SELECT ST.GIVENNAME as stugivename, ST.SURNAME as stusurname, SO.SUBJCODE, SU.DESCRIPTION, SO.YEAR, SO.SEMESTER, 
SO.FEE, T.GIVENNAME, T.SURNAME
FROM ENROLMENT E 
INNER JOIN SUBJECTOFFERING SO
ON
SO.SUBJCODE = E.SUBJCODE AND SO.YEAR = E.YEAR AND SO.SEMESTER = E.SEMESTER  
INNER JOIN STUDENT ST
ON ST.STUDENTID = E.STUDENTID
INNER JOIN
TEACHER T
ON T.STAFFID=SO.STAFFID
INNER JOIN SUBJECT SU
ON SU.SUBJCODE = SO.SUBJCODE;


--Task 6

--example would be for query 2
--This query can be cross checked by applying the entry: select count(*) from enrolment.
-- the count returned from the query should match the sum of the
--number of enrolments provided from the data.

--Task 3 can be verified by entry: select fee from subjectoffering, this will also display the highest fee 
--from the list of data provided