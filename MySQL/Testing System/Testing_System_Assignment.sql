DROP DATABASE IF EXISTS Testing_System_Assignment;
CREATE DATABASE Testing_System_Assignment;
USE Testing_System_Assignment;

/*===================================================*/
/*=================TẠO BẢNG DỮ LIỆU==================*/
/*===================================================*/

-- Create table Department
DROP TABLE IF EXISTS Department;
CREATE TABLE Department (
	DepartmentID	TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    DepartmentName	NVARCHAR(30) NOT NULL UNIQUE KEY
);

-- Create table Position
DROP TABLE IF EXISTS `Position` ;
CREATE TABLE `Position` (
	PositionID		TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    PositionName	ENUM('Dev', 'Test', 'Scrum Master', 'PM') NOT NULL UNIQUE KEY
);

-- Create table Account
DROP TABLE IF EXISTS `Account`;
CREATE TABLE `Account` (
	AccountID 		TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    Email			VARCHAR(50) NOT NULL UNIQUE KEY,
    Username		VARCHAR(50) NOT NULL UNIQUE KEY,
    FullName		NVARCHAR(50) NOT NULL,
    DepartmentID	TINYINT UNSIGNED, #NOT NULL
    PositionID		TINYINT UNSIGNED NOT NULL,
    CreateDate		DATETIME DEFAULT NOW(),
    
    FOREIGN KEY (DepartmentID)  REFERENCES Department(DepartmentID),
    FOREIGN KEY (PositionID)	REFERENCES `Position`(PositionID)
);

-- Create table `Group`
DROP TABLE IF EXISTS `Group`;
CREATE TABLE `Group`(
	GroupID			TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    GroupName		NVARCHAR(50) NOT NULL UNIQUE KEY,
    CreatorID		TINYINT UNSIGNED,
    CreateDate		DATETIME DEFAULT NOW(),
    
    -- Creator ID ID của người tạo liên quan đến `AccountID` dùng foreign key
    FOREIGN KEY (CreatorID)    	REFERENCES `Account`(AccountID)
);

-- Create table GroupAccount
DROP TABLE IF EXISTS GroupAccount;
CREATE TABLE GroupAccount(
	GroupID			TINYINT UNSIGNED NOT NULL,
    AccountID		TINYINT UNSIGNED NOT NULL,
    JoinDate		DATETIME DEFAULT NOW(),
    
    PRIMARY KEY (GroupID, AccountID),
    FOREIGN KEY (GroupID) 		REFERENCES `Group`(GroupID),
	FOREIGN KEY (AccountID) 	REFERENCES `Account`(AccountID)
);

-- Create table TypeQuestion
DROP TABLE IF EXISTS TypeQuestion;
CREATE TABLE TypeQuestion(
	TypeID			TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    TypeName		ENUM('Essay', 'Multiple-Choice') NOT NULL UNIQUE KEY
);

-- Create table CategoryQuestion
DROP TABLE IF EXISTS CategoryQuestion;
CREATE TABLE CategoryQuestion(
	CategoryID		TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    CategoryName	NVARCHAR(50) NOT NULL UNIQUE KEY
);

-- Create table Question
DROP TABLE IF EXISTS Question;
CREATE TABLE Question(
	QuestionID		TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    Content			NVARCHAR(100) NOT NULL,
    CategoryID		TINYINT UNSIGNED NOT NULL,
    TypeID			TINYINT UNSIGNED NOT NULL,
    CreatorID		TINYINT UNSIGNED NOT NULL,
    CreateDate		DATETIME DEFAULT NOW(),
    
    FOREIGN KEY (CategoryID) REFERENCES CategoryQuestion(CategoryID),
    FOREIGN KEY (TypeID) 	 REFERENCES TypeQuestion(TypeID),
    FOREIGN KEY (CreatorID)  REFERENCES `Account`(AccountID)
);

-- Create table Answer
DROP TABLE IF EXISTS Answer;
CREATE TABLE Answer(
	AnswerID		TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    Content			NVARCHAR(100) NOT NULL,
    QuestionID		TINYINT UNSIGNED NOT NULL,
    isCorrect		BIT DEFAULT 1,

    FOREIGN KEY (QuestionID) REFERENCES Question(QuestionID)
);

-- Create table Exam
DROP TABLE IF EXISTS Exam;
CREATE TABLE Exam(
	ExamID			TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `Code`			CHAR(10) NOT NULL,
    Title			NVARCHAR(50) NOT NULL,
    CategoryID		TINYINT UNSIGNED NOT NULL,
    Duration		TINYINT UNSIGNED NOT NULL,
    CreatorID		TINYINT UNSIGNED NOT NULL,
    CreateDate		DATETIME DEFAULT NOW(),
    
    FOREIGN KEY (CategoryID) REFERENCES CategoryQuestion(CategoryID),
    FOREIGN KEY (CreatorID)  REFERENCES `Account`(AccountID)
);

-- Create table ExamQuestion
DROP TABLE IF EXISTS ExamQuestion;
CREATE TABLE ExamQuestion(
	ExamID			TINYINT UNSIGNED NOT NULL,
    QuestionID		TINYINT UNSIGNED NOT NULL,
    
    FOREIGN KEY (QuestionID) REFERENCES Question(QuestionID),
    FOREIGN KEY (ExamID) 	 REFERENCES Exam(ExamID),
    PRIMARY KEY (ExamID, QuestionID)
);

/*=============================================================*/
/*==================== Insert Database ========================*/
/*=============================================================*/

-- Add data Department
INSERT INTO Department(DepartmentName)
VALUES 				(N'Marketing'),
					(N'Sale'),
                    (N'Bảo vệ'),
                    (N'Nhân sự'),
                    (N'Kỹ thuật'),
                    (N'Tài chính'),
                    (N'Phó giám đốc'),
                    (N'Giám đốc'),
                    (N'Thư kí'),
                    (N'Bán hàng'),
                    (N'Waiting Department');
 
-- Add data Position 
INSERT INTO `Position` (PositionName)
VALUES				   ('Dev'),
					   ('Test'),
                       ('Scrum Master'),
                       ('PM');
                  
-- Add data Account                  
INSERT INTO `Account`   (Email , Username, FullName, DepartmentID, PositionID, CreateDate )
VALUES					 ('haidang29productions@gmail.com'  , 'dangblack'  		, 'Nguyễn Hải Đăng'      , 5  , 1 , '2024-03-05'),
						 ('account1@gmail.com'  			, 'quanganh'   		, 'Nguyen Chien Thang2'  , 1  , 2 , '2024-03-05'),
                         ('account2@gmail.com'  			, 'vanchien'   	  	, 'Nguyen Van Chien'     , 2  , 2 , '2024-03-07'),
                         ('account3@gmail.com'  			, 'cocoduongqua'    , 'Duong Do'             , 3  , 4 , '2024-03-08'),
                         ('account4@gmail.com'  			, 'doccocaubai'  	, 'Nguyen Chien Thang1'  , 4  , 4 , '2024-03-10'),
                         ('dapphatchetngay@gmail.com'  		, 'khabanh' 	    , 'Ngo Ba Kha'  		 , 6  , 3 , '2024-04-05'),
                         ('songcodaoly@gmail.com'           , 'huanhoahong'     , 'Bui Xuan Huan'        , 2  , 2 ,  NULL       ),
                         ('sontungmtp@gmail.com'  			, 'tungnui' 	    , 'Nguyen Thanh Tung'    , 8  , 1 , '2024-04-07'),
                         ('duongghuu@gmail.com'  			, 'duongghuu' 	    , 'Duong Van Huu'  		 , 2  , 2 , '2024-04-07'),
                         ('vtiaccademy@gmail.com' 			, 'vtiaccedemy'     , 'Vi Ti Ai' 			 , 10 , 1 , '2024-04-09');
                   
-- Add data Group                   
INSERT INTO `Group`    (GroupName , CreatorID , CreateDate )
VALUES                  (N'Testing System'   , 5  , '2023-03-05'),
                        (N'Development'      , 1  , '2024-03-07'),
                        (N'VTI Sale 01'      , 2  , '2024-03-09'),
                        (N'VTI Sale 02'      , 3  , '2024-03-10'),
                        (N'VTI Sale 03'      , 4  , '2024-03-28'),
                        (N'VTI Creator'      , 6  , '2024-04-06'),
                        (N'VTI Marketing 01' , 7  , '2024-04-07'),
                        (N'Management'       , 8  , '2024-04-08'),
                        (N'Chat with love'   , 9  , '2024-04-09'),
                        (N'Vi Ti Ai'         , 10 , '2024-04-10');

-- Add data GroupAccount                        
INSERT INTO GroupAccount   ( GroupID , AccountID , JoinDate )
VALUES                  ( 1  , 1  , '2023-03-05'),   
                        ( 1  , 2  , '2024-03-07'), 
                        ( 3  , 3  , '2024-03-09'), 
                        ( 3  , 4  , '2024-03-10'), 
                        ( 5  , 5  , '2024-03-28'), 
                        ( 1  , 3  , '2024-04-06'), 
                        ( 1  , 7  , '2024-04-07'), 
                        ( 8  , 3  , '2024-04-08'), 
                        ( 1  , 9  , '2024-04-09'), 
                        ( 10 , 10 , '2024-04-10');

-- Add data TypeQuestion                        
INSERT INTO TypeQuestion  ( TypeName )    
VALUES                  ('Essay'),
                        ('Multiple-Choice');
                          
INSERT INTO CategoryQuestion (CategoryName)
VALUES                  ('Java'      ),
                        ('ASP.NET'   ),
                        ('ADO.NET'   ),
                        ('SQL'       ),
                        ('Postman'   ),
                        ('Ruby'      ),
                        ('Python'    ),
                        ('C++'       ),
                        ('C Sharp'   ),
                        ('PHP'       );
 
-- Add data Question 
INSERT INTO   Question  (Content, CategoryID , TypeID , CreatorID , CreateDate )
VALUES                  (N'Câu hỏi về Java' , 1  , 1 , 2  , '2024-04-05'),
                        (N'Câu hỏi về PHP'  , 10 , 2 , 2  , '2024-04-05'),
                        (N'Hỏi về C#'       , 9  , 2 , 3  , '2024-04-06'),
                        (N'Hỏi về Ruby'     , 6  , 1 , 1  , '2024-04-06'),
                        (N'Hỏi về Postman'  , 5  , 1 , 5  , '2024-04-06'),
                        (N'Hỏi về ADO.NET'  , 3  , 2 , 6  , '2024-04-06'),
                        (N'Hỏi về ASP.NET'  , 2  , 1 , 7  , '2024-04-06'),
                        (N'Hỏi về C++'      , 8  , 1 , 8  , '2024-04-07'),
                        (N'Hỏi về SQL'      , 4  , 2 , 9  , '2024-04-07'),
                        (N'Hỏi về Python'   , 7  , 1 , 10 , '2024-04-07');
 
 -- Add  data Answer
INSERT INTO Answer   (Content , QuestionID , isCorrect )
VALUES                  (N'Trả lời 01'      , 1 , 0 ),   
                        (N'Trả lời 02'      , 1 , 1 ), 
                        (N'Trả lời 03'      , 1 , 0 ), 
                        (N'Trả lời 04'      , 1 , 1 ), 
                        (N'Trả lời 05'      , 2 , 1 ), 
                        (N'Trả lời 06'      , 3 , 1 ), 
                        (N'Trả lời 07'      , 4 , 0 ), 
                        (N'Trả lời 08'      , 8 , 0 ), 
                        (N'Trả lời 09'      , 9 , 1 ), 
                        (N'Trả lời 10'      , 10 , 1 );

-- Add data Exam
INSERT INTO Exam   ( `Code` , Title , CategoryID , Duration , CreatorID , CreateDate )
VALUES                  ('VTIQ001' , N'Đề thi C#'        , 1  , 60  , 5  , '2020-04-05'),   
                        ('VTIQ002' , N'Đề thi PHP'       , 10 , 60  , 2  , '2023-04-05'),
                        ('VTIQ003' , N'Đề thi C++'       , 9  , 120 , 2  , '2023-04-07'),
                        ('VTIQ004' , N'Đề thi Java'      , 6  , 60  , 3  , '2024-04-08'),
                        ('VTIQ005' , N'Đề thi Ruby'      , 5  , 120 , 4  , '2024-04-10'),
                        ('VTIQ006' , N'Đề thi Postman'   , 3  , 60  , 6  , '2024-04-05'),
                        ('VTIQ007' , N'Đề thi SQL'       , 2  , 60  , 7  , '2024-04-05'),
                        ('VTIQ008' , N'Đề thi Python'    , 8  , 60  , 8  , '2024-04-07'),
                        ('VTIQ009' , N'Đề thi ADO.NET'   , 4  , 90  , 9  , '2024-04-07'),
                        ('VTIQ010' , N'Đề thi ASP.NET'   , 7  , 90  , 10 , '2024-04-08');
 
 -- Add data ExamQuestion
INSERT INTO ExamQuestion (ExamID , QuestionID )
VALUES                  ( 1   , 5   ),
                        ( 2   , 10  ),
                        ( 3   , 4   ),
                        ( 4   , 3   ),
                        ( 5   , 7   ),
                        ( 6   , 10  ),
                        ( 7   , 2   ),
                        ( 8   , 10  ),
                        ( 9   , 9   ),
                        ( 10  , 8   );




