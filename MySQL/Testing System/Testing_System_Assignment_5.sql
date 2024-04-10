# Question 1 : Tạo view có chứa danh sách nhân viên thuộc phòng ban sale
# Dùng View
CREATE OR REPLACE VIEW 	`DSNV_Sale` AS
SELECT			Ac.Email, Ac.Username , Ac.FullName, De.DepartmentName
FROM			`Account` Ac
INNER JOIN		Department De	ON	Ac.DepartmentID = De.DepartmentID
WHERE			De.DepartmentName = 'Sale'
;
SELECT 		*
FROM		`DSNV_Sale`;

# Dùng Subquery
SELECT			Ac.Email, Ac.Username , Ac.FullName, De.DepartmentName
FROM			`Account` Ac
INNER JOIN		Department De	ON	Ac.DepartmentID = De.DepartmentID
WHERE			De.DepartmentID = ALL (SELECT 	De1.DepartmentID
									   FROM		Department De1
                                       WHERE	De1.DepartmentName = 'Sale') ;

# Dùng CTE
WITH DSNV_Sale AS (
	SELECT 		Ac.Email, Ac.Username , Ac.FullName, De.DepartmentName
	FROM		`Account` 	Ac
    INNER JOIN	Department De ON Ac.DepartmentID = De.DepartmentID
    WHERE		DepartmentName = 'Sale'
)
SELECT		*
FROM		DSNV_Sale
;

# Question 2 : Tạo view có chứa thông tin account tham gia vào nhiều group nhất
# INNER JOIN
SELECT		Ac.AccountID, Ac.Username ,COUNT(GA.AccountID) AS 'THONG_KE'
FROM		GroupAccount GA
INNER JOIN	`Account`	Ac  ON Ac.AccountID = GA.AccountID
GROUP BY	GA.AccountID
HAVING		COUNT(GA.AccountID) = (SELECT MAX(CountGr) AS CountMaxGr
								   FROM	 (SELECT		COUNT(GA1.AccountID) AS CountGr
										 FROM		GroupAccount GA1
                                         GROUP BY	GA1.AccountID) AS CountTableGr)
;

# Tạo View
CREATE OR REPLACE VIEW `vw_GetAccount` AS
SELECT		COUNT(GA1.AccountID) AS CountGr
FROM		GroupAccount GA1
GROUP BY	GA1.AccountID
;
SELECT		Ac.AccountID, Ac.Username ,COUNT(GA.AccountID) AS 'THONG_KE'
FROM		GroupAccount GA
INNER JOIN	`Account`	Ac  ON Ac.AccountID = GA.AccountID
GROUP BY	GA.AccountID
HAVING		COUNT(GA.AccountID) = (SELECT MAX(CountGr) AS CountMaxGr
								   FROM `vw_GetAccount` AS CountTable)
;                                   

#Dùng CTE
WITH `vw_GetAccount` AS (
	SELECT  	COUNT(GA1.AccountID) AS CountGA
    FROM		GroupAccount	GA1
    GROUP BY	GA1.AccountID
)
SELECT		Ac.AccountID, Ac.Username , COUNT(GA.AccountID) AS 'SO_LUONG'
FROM		GroupAccount 	GA
INNER JOIN	`Account`		Ac ON GA.AccountID = Ac.AccountID
GROUP BY	GA.AccountID
HAVING		COUNT(GA.AccountID) = (SELECT MAX(CountGA) AS CountMaxGA
									FROM	`vw_GetAccount` AS CountTableMaxGA)
;    

# Question 3: Tạo view có chứa câu hỏi có những content quá dài (content trên 18 từ
-- được coi là quá dài) và xóa nó đi
# Dùng View
CREATE OR REPLACE VIEW `vw_ContentTren18Tu` AS
SELECT		*
FROM		Question
WHERE		LENGTH(Content) > 18
;
SELECT	*
FROM	`vw_ContentTren18Tu`
;

DELETE
FROM		Answer
WHERE		QuestionID IN (SELECT 	QuestionID
							 FROM		`vw_ContentTu18TroLen`)
;

DELETE
FROM		ExamQuestion
WHERE		QuestionID IN 	(SELECT 	QuestionID
							 FROM		`vw_ContentTu18TroLen`)
;

DELETE		
FROM `vw_ContentTu18TroLen`;

# Cách nhanh nhưng k biết có áp dụng được ko =))
SET FOREIGN_KEY_CHECKS = 0;
DELETE	
FROM 		`vw_ContentTren18Tu`
WHERE		LENGTH(Content) > 18
;
SET FOREIGN_KEY_CHECKS = 1;
# Question 4: Tạo view có chứa danh sách các phòng ban có nhiều nhân viên nhất
CREATE OR REPLACE VIEW `vw_MaxNV` AS
	SELECT 		De.DepartmentName ,COUNT(De.DepartmentID) AS 'THONG_KE'
    FROM 		`Account`	Ac
    INNER JOIN	Department 	De ON Ac.DepartmentID = De.DepartmentID
	GROUP BY	De.DepartmentID
    HAVING		COUNT(De.DepartmentID) = (SELECT MAX(CountNV) AS CountMaxNV
										  FROM		(SELECT		COUNT(Ac2.DepartmentID) AS CountNV
													 FROM		`Account` Ac2
                                                     GROUP BY	Ac2.DepartmentID) AS CountTableNV)
;
SELECT		*
FROM		`vw_MaxNV`;

#Dùng CTE :
WITH `vw_MaxNV` AS (
	SELECT  	COUNT(Ac2.DepartmentID) AS CountNV
    FROM		`Account` Ac2
    GROUP BY	Ac2.DepartmentID 
)
SELECT 		De.DepartmentName , COUNT(Ac.DepartmentID) AS 'SO_LUONG'
FROM		`Account`	Ac
INNER JOIN	Department	De ON Ac.DepartmentID = De.DepartmentID
GROUP BY	Ac.DepartmentID
HAVING		COUNT(Ac.DepartmentID) = (SELECT MAX(CountNV) AS CountMaxNV
									  FROM	 `vw_MaxNV` AS CountTableNV);
# Question 5: Tạo view có chứa tất các các câu hỏi do user họ Nguyễn tạo
# Dùng View
CREATE OR REPLACE VIEW `vw_UserNguyen` AS
SELECT 		Qu.CategoryID, Qu.Content, Ac.FullName
FROM		`Account` 	Ac
INNER JOIN	Question	Qu 	ON Ac.AccountID = Qu.CreatorID
WHERE		SUBSTRING_INDEX(Ac.FullName,' ', 1) LIKE 'Nguyen'
;
SELECT 		*
FROM		`vw_UserNguyen`;

# Dùng CTE
WITH	`vw_UserNguyen` AS (
SELECT 		Qu.CategoryID, Qu.Content, Ac.FullName
FROM		`Account` 	Ac
INNER JOIN	Question	Qu 	ON Ac.AccountID = Qu.CreatorID
WHERE		SUBSTRING_INDEX(Ac.FullName,' ', 1) LIKE 'Nguyen%'
)
SELECT 		*
FROM		`vw_UserNguyen`;