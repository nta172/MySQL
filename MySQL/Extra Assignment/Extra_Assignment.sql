DROP DATABASE IF EXISTS Fresher_management;
CREATE DATABASE Fresher_management;
USE Fresher_management;
/*================TẠO BẢNG=======================*/
/*===============================================*/
-- =Question1=
-- Tao bang Trainee
DROP TABLE IF EXISTS Trainee;
CREATE TABLE Trainee(
	TraineeID 			TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    Full_Name			NVARCHAR(50) NOT NULL,
    Birth_Date			DATE NOT NULL,
    Gender				ENUM('male','female','unknown') NOT NULL,
    ET_IQ				TINYINT UNSIGNED CHECK(ET_IQ<=20) NOT NULL,
    ET_Gmath			TINYINT UNSIGNED CHECK(ET_Gmath<=20) NOT NULL,
    ET_English			TINYINT UNSIGNED CHECK(ET_English<=20) NOT NULL,
    Trainning_Class		CHAR(6) NOT NULL,
    Evaluation_Notes	NVARCHAR(50) DEFAULT NULL
);
-- Them cot VTI_Account
ALTER TABLE Trainee ADD COLUMN VTI_Account VARCHAR(30) NOT NULL UNIQUE KEY;


-- =Question2=
DROP TABLE IF EXISTS Ques2;
CREATE TABLE Ques2(
	ID 				TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    Name			VARCHAR(50) NOT NULL,
    Code			CHAR(5) NOT NULL UNIQUE KEY,
    ModifiedDate	DATETIME DEFAULT NOW()
);

-- =Question3=
DROP TABLE IF EXISTS Ques3;
CREATE TABLE Ques3(
	ID 				TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    Name			VARCHAR(50) NOT NULL,
    BirthDate		DATETIME NOT NULL DEFAULT NOW(),
    Gender			ENUM('0','1','2'), -- 0: Male, 1: Female, 2:Unknown
    IsDeletedFlag	ENUM('0','1') -- 0: Active,	1: Deleted
);

/*================THÊM DỮ LIỆU VÀO BẢNG=======================*/
/*===========================================================*/

-- Thêm dữ liệu cho bagnr Trainee
INSERT INTO Trainee (   Full_Name		,   Birth_Date	, Gender	, ET_IQ	, ET_Gmath	, ET_English	, Trainning_Class	, Evaluation_Notes	, VTI_Account		)
VALUE 				('Nguyễn Hải Đăng'	,  '2000-04-29'	, 'male'	,	20	,	20		,	20			,		'VTI001'	,		'Very good'	,	'dangblack'		),
					('Nguyễn Văn Bảo'	,  '2000-05-09'	, 'male'	,	18	,	16		,	16			,		'VTI002'	,		'Normal'	,	'bao123'		),
                    ('Hoàng Thị Thường'	,  '2000-06-22'	, 'female'	,	11	,	17		,	10			,		'VTI003'	,		'Good'		,	'thuong69'		),
                    ('Huấn Râu Sì'		,  '2000-07-24'	, 'male'	,	20	,	12		,	20			,		'VTI004'	,		'Good'		,	'huanrose'		),
                    ('Ngô Bá Khá'		,  '2000-08-05'	, 'male'	,	16	,	20		,	16			,		'VTI005'	,		'Normal'	,	'khabanh'		),
                    ('Nguyễn Văn Dũng'	,  '2000-09-08'	, 'female'	,	19	,	10		,	19			,		'VTI006'	,		'Good'		,	'dungtroc'		),
                    ('Nguyễn Hải Hậu'	,  '2000-10-11'	, 'male'	,	20	,	19		,	18			,		'VTI007'	,		'Normal'	,	'haumon'		),
                    ('Tống Quang Anh'	,  '2000-11-12'	, 'female'	,	15	,	20		,	17			,		'VTI008'	,		'Good'		,	'antondev'		),
                    ('Nguyễn Thị Chiến'	,  '2000-11-13'	, 'unknown'	,	20	,	19		,	20			,		'VTI009'	,		'Normal'	,	'chienpanda'	),
					('Nguyễn Thị Hảo'	,  '2000-11-13'	, 'female'	,	20	,	19		,	15			,		'VTI010'	,		'Good'		,	'haohaochucay'	);
      
-- Thêm dữ liệu cho bảng Ques2   
INSERT INTO Ques2	 (   `Name`,  	   `Code`, 		`ModifiedDate`	)
VALUE 				('NOW OR NEVER'	, 'VT001'	,	'2020-03-05'	),
					('DEAD OR LIVE'	, 'VT002'	,	'2020-03-05'	),
                    ('BE CAREFULL'	, 'VT003'	,	'2020-03-07'	),
                    ('PAY LAK'		, 'VT004'	,	'2020-03-08'	),
                    ('LET DO IT'	, 'VT005'	,	'2020-03-10'	),
                    ('DOING STH'	, 'VT006'	,	'2020-04-05'	),
                    ('GET OUT'		, 'VT007'	,	'2020-04-05'	),
                    ('OUTLAST'		, 'VT008'	,	'2020-04-07'	),
                    ('GET IT'		, 'VT009'	,	'2020-04-07'	),
					('TAKE OUT'		, 'VT010'	,	'2020-04-09'	);
				
-- Thêm dữ liệu cho bảng Ques3
INSERT INTO Ques3 	(   `Name`			,   `BirthDate`		, `Gender`	, `IsDeletedFlag`	)
VALUE 				('Nguyễn Hải Đăng'	,  '2000-04-29'		, 	'0'		,		'0'			),                    
					('Nguyễn Văn Bảo'	,  '2000-05-09'		, 	'0'		,		'1'			),
                    ('Hoàng Thị Thường'	,  '2000-06-22'		, 	'1'		,		'0'			),
                    ('Huấn Râu Sì'		,  '2000-07-24'		, 	'1'		,		'1'			),
                    ('Ngô Bá Khá'		,  '2000-08-05'		, 	'2'		,		'0'			),
                    ('Nguyễn Văn Dũng'	,  '2000-09-08'		, 	'1'		,		'1'			),
                    ('Nguyễn Hải Hậu'	,  '2000-10-11'		, 	'0'		,		'1'			),
                    ('Tống Quang Anh'	,  '2000-11-12'		, 	'0'		,		'0'			),
                    ('Nguyễn Thị Chiến'	,  '2000-11-13'		, 	'0'		,		'0'			),
					('Nguyễn Thị Hảo'	,  '2000-11-13'		, 	'1'		,		'1'			);
                    
				
/* ======TẠO BẢNG DỮ LIỆU (Q1)========*/
-- Department (Department_Number, Department_Name)
-- Employee_Table (Employee_Number, Employee_Name, Department_Number)
-- Employee_Skill_Table (Employee_Number, Skill_Code, Date Registered)

-- Tạo bảng Department
DROP TABLE IF EXISTS Department;
CREATE TABLE Department(
	Department_Number 	TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    Department_Name		NVARCHAR(50) UNIQUE KEY NOT NULL
);

-- Tạo bảng Employee_Table
DROP TABLE IF EXISTS Employee_Table;
CREATE TABLE Employee_Table(
	Employee_Number 	TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    Employee_Name		NVARCHAR(50) NOT NULL,
    Department_Number	TINYINT UNSIGNED NOT NULL,
    FOREIGN KEY(Department_Number) REFERENCES Department(Department_Number)
);

-- Tạo bảng Employee_Skill_Table
DROP TABLE IF EXISTS Employee_Skill_Table;
CREATE TABLE Employee_Skill_Table(
	Employee_Number 	TINYINT UNSIGNED AUTO_INCREMENT,
    Skill_Code			NVARCHAR(20) NOT NULL,
    Date_Registered		DATETIME DEFAULT NOW(),
    FOREIGN KEY(Employee_Number) REFERENCES Employee_Table(Employee_Number)
);

/* ======INSERT DỮ LIỆU (Q2)========*/
INSERT INTO Department	(Department_Name) 
VALUE 					(N'Marketing'	),
						(N'Sale'		),
						(N'Bảo vệ'		),
						(N'Nhân sự'		),
						(N'Kỹ thuật'	),
						(N'Tài chính'	),
						(N'Phó giám đốc'),
						(N'Giám đốc'	),
						(N'Thư kí'		),
						(N'Bán hàng'	);


INSERT INTO Employee_Table 	(Employee_Name		, Department_Number	)
VALUE						(N'Nguyễn Hải Đăng'	,		1			),
							(N'Dương Văn Quá'	,		1			),
                            (N'Tiểu Long Nữ'	,		2			),
                            (N'Chu Chỉ Nhược'	,		5			),
                            (N'Trương Vô Kị'	,		6			),
                            (N'Hoàng Dược Sư'	,		5			),
                            (N'Lý Mạc Sầu'		,		5			),
                            (N'Quách Tĩnh'		,		1			),
                            (N'Hoàng Dung'		,		9			),
                            (N'Chu Bá Thông'	,		10			);


INSERT INTO Employee_Skill_Table 	(Employee_Number, Skill_Code	, Date_Registered	)
VALUE								( 	1,				'Java'		, '2020-03-15'		),
									( 	2,				'Android'	, '2020-03-16'		),
									( 	3,				'C#'		, '2020-03-17'		),
									( 	1,				'SQL'		, '2020-03-20'		),
									( 	1,				'Postman'	, '2020-03-21'		),
									( 	4,				'Ruby'		, '2020-04-22'		),
									( 	5,				'Java'		, '2020-04-24'		),
									( 	6,				'C++'		, '2020-04-27'		),
									( 	7,				'C Sharp'	, '2020-04-04'		),
									( 	10,				'PHP'		, '2020-04-10'		);