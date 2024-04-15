# Question 1: Tạo store để người dùng nhập vào tên phòng ban và in ra tất cả các
-- account thuộc phòng ban đó
DROP PROCEDURE IF EXISTS in_dept_out_account;
DELIMITER $$
CREATE PROCEDURE in_dept_out_account (IN var_dept VARCHAR(50))
	BEGIN
		SELECT		Ac.AccountID, Ac.Username, Ac.FullName, De.DepartmentName
        FROM		`Account`	Ac
        INNER JOIN	Department	De ON Ac.DepartmentID = De.DepartmentID
        WHERE		De.DepartmentName = var_dept
        ;
    END$$
DELIMITER ;    

CALL in_dept_out_account('Sale');
# Question 2: Tạo store để in ra số lượng account trong mỗi group
DROP PROCEDURE IF EXISTS sp_quantityAccountInGroup;
DELIMITER $$
CREATE PROCEDURE sp_quantityAccountInGroup()
	BEGIN
		SELECT		GA.GroupID, COUNT(Gr.GroupID) AS So_luong
        FROM		`Group`	Gr
        INNER JOIN	GroupAccount	GA ON Gr.GroupID = GA.GroupID
        GROUP BY	Gr.GroupID
        ;
    END$$
DELIMITER ;    

CALL sp_quantityAccountInGroup();
# Question 3: Tạo store để thống kê mỗi type question có bao nhiêu question được tạo
-- trong tháng hiện tại
DROP PROCEDURE IF EXISTS sp_TypeQuestionInQuestion;
DELIMITER $$
CREATE PROCEDURE sp_TypeQuestionInQuestion()
	BEGIN
		SELECT 		TQ.TypeName , COUNT(Qu.TypeID) AS So_luong
        FROM 		Question Qu
        INNER JOIN	TypeQuestion TQ ON Qu.TypeID = TQ.TypeID
        WHERE		MONTH(Qu.CreateDate) = MONTH(NOW()) AND YEAR(Qu.CreateDate) = YEAR(NOW())
        GROUP BY	Qu.TypeID
        ;
    END$$
DELIMITER ; 

CALL sp_TypeQuestionInQuestion();   
# Question 4: Tạo store để trả ra id của type question có nhiều câu hỏi nhất
DROP PROCEDURE IF EXISTS sp_GetCountQuesFromType;
DELIMITER $$
	CREATE PROCEDURE sp_GetCountQuesFromType(OUT v_ID TINYINT)
		BEGIN
			WITH CTE_CountTypeID AS (
			SELECT 		COUNT(Qu.TypeID) AS So_Luong
            FROM 		Question Qu
			GROUP BY 	Qu.TypeID)
			SELECT 		Qu.TypeID INTO v_ID
            FROM 		Question Qu
			GROUP BY 	Qu.TypeID
			HAVING 		COUNT(Qu.TypeID) = (SELECT MAX(So_Luong) FROM CTE_CountTypeID);
END$$
DELIMITER ;
SET @v_ID = 0;
CALL sp_GetCountQuesFromType(@v_ID);
SELECT @v_ID;
# Question 5: Sử dụng store ở question 4 để tìm ra tên của type question
DROP PROCEDURE IF EXISTS sp_NameOfTypeQuestion;
DELIMITER $$
CREATE PROCEDURE sp_NameOfTypeQuestion()
	BEGIN
		WITH CTE_CountTypeID AS (
        SELECT		COUNT(Qu.TypeID) AS So_luong
        FROM		Question Qu
        GROUP BY	Qu.TypeID)
        SELECT 		TQ.TypeName
        FROM		Question	Qu
        INNER JOIN	TypeQuestion TQ ON Qu.TypeID = TQ.TypeID
        GROUP BY	Qu.TypeID
        HAVING 		COUNT(Qu.TypeID) = (SELECT MAX(So_luong)
										FROM 	CTE_CountTypeID);
    END$$
DELIMITER ;

CALL sp_NameOfTypeQuestion();
# Question 6: Viết 1 store cho phép người dùng nhập vào 1 chuỗi và trả về group có tên
-- chứa chuỗi của người dùng nhập vào hoặc trả về user có username chứa
-- chuỗi của người dùng nhập vào
DROP PROCEDURE IF EXISTS in_StringAccountOrGroup;
DELIMITER $$
CREATE PROCEDURE in_StringAccountOrGroup(IN var_String VARCHAR(50))
	BEGIN
		SELECT		Ac.Username
        FROM		`Account`	Ac
        WHERE		Ac.Username LIKE CONCAT('%', var_String , '%');
        
        SELECT 		Gr.GroupName
        FROM		`Group`	Gr
        WHERE		Gr.GroupName LIKE CONCAT('%', var_String , '%');
    END$$
DELIMITER ;    

CALL in_StringAccountOrGroup('a');
# Question 7: Viết 1 store cho phép người dùng nhập vào thông tin fullName, email và
-- trong store sẽ tự động gán:
-- username sẽ giống email nhưng bỏ phần @..mail đi
-- positionID: sẽ có default là developer
-- departmentID: sẽ được cho vào 1 phòng chờ
-- Sau đó in ra kết quả tạo thành công
DROP PROCEDURE IF EXISTS sp_AccountNew;
DELIMITER $$
CREATE PROCEDURE sp_AccountNew (IN var_Email VARCHAR(50),IN var_FullName VARCHAR(50))
	BEGIN
        DECLARE 	Username	VARCHAR(50) DEFAULT SUBSTRING_INDEX(var_Email,'@',1);
        DECLARE 	PositionID	TINYINT UNSIGNED DEFAULT 1;
        DECLARE		DepartmentID	TINYINT UNSIGNED DEFAULT 11;
        DECLARE		CreateDate		DATETIME DEFAULT NOW();
		INSERT INTO	`Account` (Email, Username , FullName, DepartmentID, PositionID, CreateDate)
		VALUES				  (var_Email, Username, var_FullName, DepartmentID, PositionID, CreateDate);
        
        SELECT 		*
        FROM		`Account` A
        WHERE		A.Username = Username
        ;
    END$$
DELIMITER ;

CALL sp_AccountNew('nguyentheanh170203@gmail.com', 'Nguyen The Anh');
# Question 8: Viết 1 store cho phép người dùng nhập vào Essay hoặc Multiple-Choice
-- để thống kê câu hỏi essay hoặc multiple-choice nào có content dài nhất
# Question 9: Viết 1 store cho phép người dùng xóa exam dựa vào ID
# Question 10: Tìm ra các exam được tạo từ 3 năm trước và xóa các exam đó đi (sử
-- dụng store ở câu 9 để xóa)
-- Sau đó in số lượng record đã remove từ các table liên quan trong khi removing
# Question 11: Viết store cho phép người dùng xóa phòng ban bằng cách người dùng
-- nhập vào tên phòng ban và các account thuộc phòng ban đó sẽ được
-- chuyển về phòng ban default là phòng ban chờ việc
# Question 12: Viết store để in ra mỗi tháng có bao nhiêu câu hỏi được tạo trong năm nay

# Question 13: Viết store để in ra mỗi tháng có bao nhiêu câu hỏi được tạo trong 6
-- tháng gần đây nhất
-- (Nếu tháng nào không có thì sẽ in ra là "không có câu hỏi nào trong tháng")