-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/gF7sph
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE `Student` (
    `StudentID` int  NOT NULL ,
    `Name` varchar(30)  NOT NULL ,
    `DepartmentID` int  NOT NULL ,
    `Adress` varchar(50)  NOT NULL ,
    `DateOfBirth` date  NOT NULL ,
    PRIMARY KEY (
        `StudentID`
    )
);

CREATE TABLE `Course` (
    `CourseID` int  NOT NULL ,
    `StudentID` int  NOT NULL ,
    `LessonID` int  NOT NULL ,
    `Description` varchar(50)  NOT NULL ,
    `StartDate` date  NOT NULL ,
    `EndDate` date  NOT NULL ,
    PRIMARY KEY (
        `CourseID`
    )
);

CREATE TABLE `Lesson` (
    `LessonID` int  NOT NULL ,
    `Description` varchar(30)  NOT NULL ,
    `TutorID` int  NOT NULL ,
    PRIMARY KEY (
        `LessonID`
    )
);

CREATE TABLE `Tutor` (
    `TutorID` int  NOT NULL ,
    `Name` varchar(30)  NOT NULL ,
    `Title` varchar(30)  NOT NULL ,
    PRIMARY KEY (
        `TutorID`
    )
);

ALTER TABLE `Student` ADD CONSTRAINT `fk_Student_StudentID` FOREIGN KEY(`StudentID`)
REFERENCES `Course` (`StudentID`);

ALTER TABLE `Lesson` ADD CONSTRAINT `fk_Lesson_LessonID` FOREIGN KEY(`LessonID`)
REFERENCES `Course` (`LessonID`);

ALTER TABLE `Tutor` ADD CONSTRAINT `fk_Tutor_TutorID` FOREIGN KEY(`TutorID`)
REFERENCES `Lesson` (`TutorID`);
