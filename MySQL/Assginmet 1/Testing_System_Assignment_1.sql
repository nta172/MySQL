DROP DATABASE IF EXISTS Testing_System_Assignment_1;
CREATE DATABASE Testing_System_Assignment_1;
USE Testing_System_Assignment_1;

DROP TABLE IF EXISTS Department;
CREATE TABLE Department (
	DepartmentID	INT,
    DepartmentName	VARCHAR(50)
);

DROP TABLE IF EXISTS `Position`;
CREATE TABLE `Position` (
	PositionID		INT,
    PositionName	VARCHAR(50)
);

DROP TABLE IF EXISTS `Account`;
CREATE TABLE `Account` (
	AccountID 		INT,
    Email			VARCHAR(50),
    Username		VARCHAR(50),
    FullName		VARCHAR(59),
    DepartmentID	VARCHAR(50),
    PositionID		VARCHAR(50),
    CreateDate		DATE
);

DROP TABLE IF EXISTS `Group`;
CREATE TABLE `Group`(
	GroupID			INT,
    GroupName		VARCHAR(50),
    CreatorID		INT,
    CreateDate		DATE
);

DROP TABLE IF EXISTS GroupAccount;
CREATE TABLE GroupAccount(
	GroupID			INT,
    AccountID		INT,
    JoinDate		DATE
);

DROP TABLE IF EXISTS TypeQuestion;
CREATE TABLE TypeQuestion(
	TypeID			INT,
    TypeName		VARCHAR(50)
);

DROP TABLE IF EXISTS CategoryQuestion;
CREATE TABLE CategoryQuestion(
	CategoryID		INT,
    CategoryName	VARCHAR(50)
);

DROP TABLE IF EXISTS Question;
CREATE TABLE Question(
	QuestionID		INT,
    Content			VARCHAR(188),
    CategoryID		INT,
    TypeID			INT,
    CreatorID		INT,
    CreateDate		DATE
);

DROP TABLE IF EXISTS Answer;
CREATE TABLE Answer(
	AnswerID		INT,
    Content			VARCHAR(100),
    QuestionID		INT,
    isCorrect		VARCHAR(50)
);

DROP TABLE IF EXISTS Exam;
CREATE TABLE Exam(
	ExamID			INT,
    `Code`			INT,
    Title			VARCHAR(58),
    CategoryID		INT,
    Duration		DATE,
    CreatorID		INT,
    CreateDate		DATE
);

DROP TABLE IF EXISTS ExamQuestion;
CREATE TABLE ExamQuestion(
	ExamID			INT,
    QuestionID		INT
);