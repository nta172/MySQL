/*===================================================*/
/*================== CÂU TRUY VẤN ===================*/
/*===================================================*/

#Question 2 : Lấy ra tất cả các phòng ban
SELECT 		*
FROM 		Department;
 

#Question 3 : Lấy ra id của phong ban "Sale"
SELECT 		DepartmentID 
FROM 		Department
WHERE 		DepartmentName = N'Sale';

#Question 4 : Lấy ra thông tin account có fullname dài nhất 
SELECT 		* 
FROM 		`Account` 
WHERE		LENGTH(FullName) = (SELECT MAX(LENGTH(FullName)) FROM `Account`)
ORDER BY	FullName DESC;

#Question 5 : Lấy ra thông tin account có fullname dài nhất và thuộc phòng ban có id = 3
WITH cte_dep3 AS
(
SELECT * FROM `Account` WHERE DepartmentID =3
)
SELECT * FROM `cte_dep3`
WHERE LENGTH(Fullname) = (SELECT MAX(LENGTH(Fullname)) FROM `cte_dep3`)
ORDER BY Fullname ASC;

#Question 6 : Lấy ra tên group đã tham gia trước ngày 20/12/2023
SELECT 		GroupName
FROM 		`Group`
WHERE 		CreateDate < '2023-12-20';

#Question 7 : Lấy ra ID của question có >= 4 câu trả lời
SELECT		QuestionID, COUNT(AnswerID) AS 'So_luong_Answers'
FROM		Answer
GROUP BY 	QuestionID
HAVING		COUNT(AnswerID) >=4
;
/*===========================*/
# Muốn liệt kê danh sách 
# CONCAT Nối các cột lại với nhau 
SELECT		QuestionID, GROUP_CONCAT(AnswerID SEPARATOR ' ') ,COUNT(AnswerID) AS 'So_luong_Answers'
FROM		Answer
GROUP BY 	QuestionID
HAVING		COUNT(AnswerID) >=4
;

#Question 8 : Lấy ra các mã đề thi có thời gian thi >= 60 và được tạo trước ngày 20/12/2023
SELECT 		`Code`
FROM 		Exam
WHERE 		Duration >= 60 AND CreateDate < '2023-12-20';

#Question 9 : Lấy ra 5 group được tạo gần đây nhất
SELECT 		*
FROM 		`Group`
ORDER BY 	CreateDate DESC
LIMIT 		5;

#Question 10 : Đếm số nhân viên thuộc Department có id = 2
SELECT 		COUNT(AccountID) AS 'SO NHAN VIEN'
FROM 		`Account`
WHERE		DepartmentID = 2
##GROUP BY	DepartmentID có cũng được
;

#Question 11 : Lấy nhân viên có tên bắt đầu bằng chữ D và kết thúc bằng chữ o
SELECT 		Fullname
FROM		`Account`
WHERE		(SUBSTRING_INDEX(FullName, ' ', -1)) LIKE 'D%o' ;
/*SUBSTRING_INDEX  để tách chuỗi FullName -1 là trả về phần tên*/

#Question 12 : Xóa tất cả các exam được tạo trước ngày 20/12/2023
DELETE 
FROM Exam
WHERE CreateDate < '2023-12-20';

#Phải xóa ExamQuestion trước vì nó liên quan đến Exam nên phải xóa trước mới xóa được bên Exam
DELETE
FROM 		ExamQuestion
WHERE		ExamID IN (SELECT ExamID
						FROM Exam
						WHERE CreateDate < '2023-12-20');

SELECT 		*
FROM 		Exam ;
#Question 13 : Xóa tất cả các question có nội dung bắt đầu bằng từ "câu hỏi"
-- Question 13: xóa tất cả các Account có FullName bắt đầu bằng 2 từ "Nguyễn Hải"

DELETE 
FROM 		Question
WHERE 		Content LIKE 'Câu hỏi%';

-- Xóa các bản ghi từ bảng Answer liên quan đến các câu hỏi cần xóa
DELETE
FROM 		Answer 
WHERE 		QuestionID IN (SELECT QuestionID 
							FROM Question 
							WHERE Content LIKE 'Câu hỏi%');
-- Xóa các bản ghi từ bảng ExamQuestion liên quan đến các câu hỏi cần xóa
DELETE 
FROM 		ExamQuestion 
WHERE 		QuestionID IN (SELECT QuestionID 
						   FROM Question 
                           WHERE Content LIKE 'Câu hỏi%');

SELECT		*
FROM 		Question;

-- Tắt chế độ kiểm tra ràng buộc khóa ngoại (foreign key constraints)
SET FOREIGN_KEY_CHECKS=0;
-- Xóa các bản ghi trong các bảng có liên quan
DELETE 
FROM GroupAccount 
WHERE AccountID IN (SELECT AccountID 
					FROM `Account` 
                    WHERE FullName LIKE 'Nguyễn Hải%')
;

DELETE 
FROM Exam 
WHERE CreatorID IN (SELECT AccountID 
					FROM `Account` 
                    WHERE FullName LIKE 'Nguyễn Hải%')
;
DELETE 
FROM Question 
WHERE CreatorID IN (SELECT AccountID 
					FROM `Account` 
                    WHERE FullName LIKE 'Nguyễn Hải%')
;

-- Xóa tài khoản từ bảng Account
DELETE 
FROM `Account` 
WHERE FullName LIKE 'Nguyễn Hải%';

-- Bật lại chế độ kiểm tra ràng buộc khóa ngoại
SET FOREIGN_KEY_CHECKS=1;

#Question 14 : Update thông tin của account có id = 5 thành tên "Nguyễn Bá Lộc" và email thành loc.nguyenba@vti.com.vn
UPDATE 		`Account` 
SET 		Fullname 	= 	N'Nguyễn Bá Lộc', 
			Email 		= 	'loc.nguyenba@vti.com.vn'
WHERE 		AccountID 	= 	5;

#Question 15 : Update account có id = 5 sẽ thuộc group có id = 4
UPDATE 		`GroupAccount` 
SET 		AccountID = 5 
WHERE 		GroupID = 4;

SELECT *
FROM `GroupAccount`;


