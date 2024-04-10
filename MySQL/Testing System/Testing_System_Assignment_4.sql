# EXERCISE 1 : JOIN
# Question 1: Viết lệnh để lấy ra danh sách nhân viên và thông tin phòng ban của họ
SELECT			Ac.Email, Ac.Username , Ac.FullName, De.DepartmentName
FROM			`Account` Ac
INNER JOIN		Department De	ON	Ac.DepartmentID = De.DepartmentID
;
# Question 2: Viết lệnh để lấy ra thông tin các account được tạo sau ngày 20/3/2024
SELECT			Ac.Email, Ac.Username , Ac.FullName, De.DepartmentName
FROM			`Account` Ac
INNER JOIN		Department De 	ON 	Ac.DepartmentID = De.DepartmentID
WHERE			Ac.CreateDate < '2024-3-20'
;
# Question 3: Viết lệnh để lấy ra tất cả các developer
SELECT			Ac.FullName, Ac.Email, Po.PositionName
FROM			`Account` Ac
INNER JOIN		`Position` Po ON Po.PositionID = Ac.PositionID
WHERE			Po.PositionName = 'Dev'
;
# Question 4: Viết lệnh để lấy ra danh sách các phòng ban có >3 nhân viên
SELECT			DepartmentName , COUNT(Ac.DepartmentID) AS 'Nhan_vien'
FROM			Department De
INNER JOIN		`Account` Ac 	ON	De.DepartmentID = Ac.DepartmentID
GROUP BY 		Ac.DepartmentID
HAVING			COUNT(Ac.DepartmentID) >= 2
;
# Question 5: Viết lệnh để lấy ra danh sách câu hỏi được sử dụng trong đề thi nhiều nhất
SELECT		EQ.QuestionID, Qu.Content
FROM		ExamQuestion EQ
INNER JOIN	Question Qu 	ON	EQ.QuestionID = Qu.QuestionID
GROUP BY 	EQ.QuestionID
HAVING		COUNT(EQ.QuestionID) = (SELECT MAX(CountQues) AS MaxCountQues
									 FROM (SELECT 		COUNT(EQ.QuestionID) AS CountQues
											FROM 		ExamQuestion EQ 
											GROUP BY 	EQ.QuestionID) AS CountTable)						
;

# Question 6: Thông kê mỗi category Question được sử dụng trong bao nhiêu Question
SELECT		Ca.CategoryID , Ca.CategoryName , COUNT(Qu.CategoryID)	AS 'Thống_kê_CategoryQuestion'
FROM		Question Qu
LEFT JOIN 	CategoryQuestion Ca  ON	 Qu.CategoryID = Ca.CategoryID
GROUP BY	Ca.CategoryID
ORDER BY	Ca.CategoryID ASC
;

# Question 7: Thông kê mỗi Question được sử dụng trong bao nhiêu Exam
SELECT		Qu.Content ,COUNT(EQ.QuestionID) AS 'Thong_ke_Question'
FROM		Question Qu
LEFT JOIN	ExamQuestion EQ ON	EQ.QuestionID = Qu.QuestionID
GROUP BY	Qu.QuestionID
ORDER BY	COUNT(EQ.QuestionID) ASC
;
# Question 8: Lấy ra Question có nhiều câu trả lời nhất
SELECT 		Qu.QuestionID, Qu.Content, COUNT(An.QuestionID) AS 'SO LUONG'
FROM		Question Qu 
INNER JOIN  Answer An 	ON	Qu.QuestionID = An.QuestionID
GROUP BY	An.QuestionID
HAVING		COUNT(An.QuestionID) =	(SELECT 	MAX(CountQu)
									 FROM		(SELECT 		COUNT(An.QuestionID) AS CountQu
												FROM			Answer An 
												GROUP BY		An.QuestionID) AS MaxCountQu);
# Question 9: Thống kê số lượng account trong mỗi group
SELECT			GA.GroupID, COUNT(Ac.AccountID) AS 'SO_LUONG_Account'
FROM			`Account` Ac
INNER JOIN		GroupAccount GA
ON				Ac.AccountID = GA.AccountID
GROUP BY		GA.GroupID
ORDER BY		GA.GroupID ASC
;
/*====================================================================*/
SELECT 		Gr.GroupID, Gr.GroupName ,COUNT(GA.GroupID) AS 'THONG_KE'
FROM		`Group` 	 Gr
INNER JOIN	GroupAccount GA ON Gr.GroupID = GA.GroupID
GROUP BY	GA.GroupID
HAVING	    COUNT(GA.GroupID)
ORDER BY	GA.GroupID ASC		
;
#Question 10 : Tìm chức vụ có ít người nhất
SELECT			Po.PositionID, Po.PositionName , COUNT(Ac.PositionID) AS 'SO_LUONG'
FROM			`Account` Ac
INNER JOIN		`Position` Po 	ON Ac.PositionID = Po.PositionID
GROUP BY		Po.PositionID
HAVING			COUNT(Ac.PositionID) = (SELECT 	MIN(CountPo)
										 FROM 	(SELECT 	COUNT(Ac.PositionID) AS CountPo
												 FROM		`Account` Ac 
                                                 GROUP BY   Ac.PositionID) AS CountMinPo);
# Question 11: Thống kê mỗi phòng ban có bao nhiêu dev, test, scrum master, PM
SELECT			De.DepartmentID ,De.DepartmentName,Po.PositionName, COUNT(Po.PositionID) AS 'SO_LUONG'
FROM			`Account` Ac
INNER JOIN 		`Position` Po	ON	Ac.PositionID = Po.PositionID
INNER JOIN		Department De	ON	Ac.DepartmentID = De.DepartmentID
GROUP BY 		Ac.DepartmentID, Po.PositionID
ORDER BY		Ac.DepartmentID ASC
;
# Question 12: Lấy thông tin chi tiết của câu hỏi bao gồm: thông tin cơ bản của question, loại câu hỏi, ai là người tạo ra câu hỏi, câu trả lời là gì, ngày
SELECT 			Qu.QuestionID , CQ.CategoryName, TQ.TypeName, Ac.FullName, An.Content
FROM			Question 	     Qu 
INNER JOIN		CategoryQuestion CQ 	ON	Qu.CategoryID = CQ.CategoryID
INNER JOIN		TypeQuestion 	 TQ		ON 	Qu.TypeID = TQ.TypeID
INNER JOIN		`Account`		 Ac 	ON 	Qu.CategoryID = Ac.AccountID
INNER JOIN		Answer           An     ON 	Qu.QuestionID = An.QuestionID
ORDER BY		Qu.QuestionID ASC
;
# Question 13: Lấy ra số lượng câu hỏi của mỗi loại tự luận hay trắc nghiệm
SELECT 			TQ.TypeID, TQ.TypeName, COUNT(Qu.TypeID) AS 'SO_LUONG'
FROM			Question Qu 
INNER JOIN		TypeQuestion TQ ON Qu.TypeID = TQ.TypeID
GROUP BY 		Qu.TypeID
;
# Question 14: Lấy ra group không có account nào
SELECT		*
FROM		`Group` 
WHERE		GroupID  NOT IN
					 (SELECT		GroupID
					  FROM			GroupAccount);
# Question 15: Lấy ra group không có account nào
SELECT		*
FROM		`Group` Gr 
LEFT JOIN	GroupAccount GA	ON Gr.GroupID = GA.GroupID
WHERE		GA.AccountID IS NULL;
# Question 16: Lấy ra question không có answer nào
SELECT 		* 
FROM		Question Qu
LEFT JOIN	Answer An  	ON	Qu.QuestionID = An.QuestionID
WHERE		An.AnswerID IS NULL;
# Exercise 2: Union
-- Question 17:
-- a) Lấy các account thuộc nhóm thứ 1
-- b) Lấy các account thuộc nhóm thứ 2
-- c) Ghép 2 kết quả từ câu a) và câu b) sao cho không có record nào trùng nhau
SELECT		*
FROM		`Account` Ac
INNER JOIN	GroupAccount GA	ON	Ac.AccountID = GA.AccountID
WHERE		GA.GroupID = 1
UNION
SELECT 		*
FROM		`Account` Ac
INNER JOIN 	GroupAccount GA	ON 	Ac.AccountID = GA.AccountID
WHERE		GA.GroupID = 2;

# Question 18:
-- a) Lấy các group có lớn hơn 5 thành viên
-- b) Lấy các group có nhỏ hơn 7 thành viên
-- c) Ghép 2 kết quả từ câu a) và câu b)		
SELECT 			Gr.GroupName , COUNT(GA.GroupID) AS 'SO_LUONG'
FROM			`Group` Gr
INNER JOIN		GroupAccount GA ON Gr.GroupID = GA.GroupID
GROUP BY		GA.GroupID
HAVING			COUNT(GA.GroupID) >= 5
UNION
SELECT 			Gr.GroupName , COUNT(GA.GroupID) AS 'SO_LUONG'
FROM			`Group` Gr
INNER JOIN		GroupAccount GA ON Gr.GroupID = GA.GroupID
GROUP BY		GA.GroupID
HAVING			COUNT(GA.GroupID) <= 7
;