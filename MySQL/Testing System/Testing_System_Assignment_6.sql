USE Testing_System_Assignment;
# Question 1: Tạo store để người dùng nhập vào tên phòng ban và in ra tất cả các account thuộc phòng ban đó 
DROP PROCEDURE IF EXISTS sp_GetAccFromDep;
DELIMITER $$
CREATE PROCEDURE 	sp_GetAccFromDep(IN in_dep_name NVARCHAR(50))
	BEGIN
		SELECT 		Ac.AccountID, Ac.FullName, De.DepartmentName 
        FROM 		`Account` Ac
		INNER JOIN 	Department De ON De.DepartmentID = Ac.DepartmentID
		WHERE 		De.DepartmentName = in_dep_name;
	END$$
DELIMITER ;
CALL sp_GetAccFromDep('Sale');
# Question 2: Tạo store để in ra số lượng account trong mỗi group
DROP PROCEDURE IF EXISTS sp_GetCountAccFromGroup;
DELIMITER $$
	CREATE PROCEDURE sp_GetCountAccFromGroup(IN in_group_name NVARCHAR(50))
		BEGIN
		SELECT 		Gr.GroupName, COUNT(GA.AccountID) AS So_Luong 
        FROM 		GroupAccount GA
		INNER JOIN 	`Group` 	 Gr ON GA.GroupID = Gr.GroupID
		WHERE 		Gr.GroupName = in_group_name
        GROUP BY	Gr.GroupID;
END$$
DELIMITER ;
Call sp_GetCountAccFromGroup('Testing System');
# Question 3: Tạo store để thống kê mỗi type question có bao nhiêu question được tạo trong tháng hiện tại
DROP PROCEDURE IF EXISTS sp_GetCountTypeInMonth;
DELIMITER $$
	CREATE PROCEDURE sp_GetCountTypeInMonth()
		BEGIN
			SELECT 		TQ.TypeName, COUNT(Qu.TypeID) 
			FROM 		Question 	 Qu
			INNER JOIN 	TypeQuestion TQ ON Qu.TypeID = TQ.TypeID
			WHERE 		MONTH(Qu.CreateDate) = MONTH(NOW()) AND YEAR(Qu.CreateDate) = YEAR(NOW())
			GROUP BY 	Qu.TypeID;
END$$
DELIMITER ;
CALL sp_GetCountTypeInMonth();
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
SET 	@ID =0;
CALL 	sp_GetCountQuesFromType(@ID);
SELECT 	@ID;
# Question 5: Sử dụng store ở question 4 để tìm ra tên của type question
DROP PROCEDURE IF EXISTS sp_GetCountQuesFromType;
DELIMITER $$
	CREATE PROCEDURE sp_GetCountQuesFromType()
		BEGIN
			WITH CTE_MaxTypeID AS(
            SELECT		COUNT(Qu.TypeID) AS So_luong
            FROM 		Question Qu
            GROUP BY	Qu.TypeID
            )
            SELECT		TQ.TypeName, COUNT(Qu.TypeID) AS So_luong
            FROM		Question		Qu
            INNER JOIN	TypeQuestion 	TQ ON Qu.TypeID = TQ.TypeID
            GROUP BY	Qu.TypeID
            HAVING		COUNT(Qu.TypeID) = (SELECT MAX(So_luong)
											FROM 	CTE_MaxTypeID)
			;
        END$$
DELIMITER ;    

CALL 	sp_GetCountQuesFromType();
# Question 6: Viết 1 store cho phép người dùng nhập vào 1 chuỗi và trả về group có tên
 -- chứa chuỗi của người dùng nhập vào hoặc trả về user có username chứa
 -- chuỗi của người dùng nhập vào
 DROP PROCEDURE IF EXISTS sp_getNameAccOrNameGroup;
 DELIMITER $$
	CREATE PROCEDURE sp_getNameAccOrNameGroup (IN var_String VARCHAR(50))
		BEGIN 
			SELECT		Gr.GroupName
			FROM		`Group`	Gr
            WHERE		Gr.GroupName LIKE CONCAT("%", var_String ,"%");

            SELECT		Ac.Username
            FROM		`Account`	Ac
            WHERE 		Ac.Username LIKE CONCAT("%", var_String ,"%")
            ;
        END$$
DELIMITER ;        

CALL sp_getNameAccOrNameGroup('s');
# Question 7: Viết 1 store cho phép người dùng nhập vào thông tin fullName, email và
-- trong store sẽ tự động gán:
-- username sẽ giống email nhưng bỏ phần @..mail đi
-- positionID: sẽ có default là developer
-- departmentID: sẽ được cho vào 1 phòng chờ
--  Sau đó in ra kết quả tạo thành công

DROP PROCEDURE IF EXISTS sp_importInf_Of_Account;
DELIMITER $$
CREATE PROCEDURE sp_importInf_Of_Account
(IN	in_Email VARCHAR(50), IN in_FullName NVARCHAR(50))
BEGIN
	DECLARE Username 		VARCHAR(50) DEFAULT SUBSTRING_INDEX(in_Email,'@',1);
    DECLARE PositionID 		TINYINT UNSIGNED DEFAULT 1;
    DECLARE DepartmentID 	TINYINT UNSIGNED DEFAULT 11;
    DECLARE CreateDate 		DATETIME DEFAULT NOW();
	INSERT INTO `Account` 	(Email		,Username, FullName		, DepartmentID,	PositionID,	CreateDate)
    VALUE					(in_Email	,Username, in_FullName	, DepartmentID, PositionID, CreateDate);
    SELECT 	*
    FROM 	`Account`	A
    WHERE	A.Username = Username;
END$$
DELIMITER ;
CALL sp_importInf_Of_Account('nguyentheanh7182@gmail.com', 'Nguyen The Anh');
# Question 8: Viết 1 store cho phép người dùng nhập vào Essay hoặc Multiple-Choice
-- để thống kê câu hỏi essay hoặc multiple-choice nào có content dài nhất
DROP PROCEDURE IF EXISTS sp_getMaxNameQuesFormNameType;
DELIMITER $$
CREATE PROCEDURE sp_getMaxNameQuesFormNameType(IN var_Choice VARCHAR(50))
	BEGIN
		DECLARE v_TypeID TINYINT UNSIGNED;
			SELECT 		TQ.TypeID INTO v_TypeID 
			FROM 		TypeQuestion TQ
			WHERE 		TQ.TypeName = var_Choice;
		IF var_Choice = 'Essay' THEN
		WITH CTE_LengContent AS(
			SELECT 		LENGTH(Qu.Content) AS leng 
            FROM 		Question Qu
			WHERE 		TypeID = v_TypeID)
			SELECT 		* 
            FROM 		Question Qu
			WHERE 		TypeID = v_TypeID  AND LENGTH(Qu.Content) = (SELECT MAX(leng)
																	 FROM CTE_LengContent);
			ELSEIF 		var_Choice = 'Multiple-Choice' THEN
		WITH CTE_LengContent AS(
			SELECT 		LENGTH(Qu.Content) AS leng 
            FROM 		Question Qu
			WHERE 		TypeID = v_TypeID)
			SELECT 		* 
            FROM 		Question Qu
			WHERE 		TypeID = v_TypeID	AND LENGTH(Qu.Content) = (SELECT MAX(leng) 
																	 FROM CTE_LengContent);
		END IF;
    END$$
DELIMITER ;    

CALL sp_getMaxNameQuesFormNameType('Essay');

#Question 9: Viết 1 store cho phép người dùng xóa exam dựa vào ID
DROP PROCEDURE IF EXISTS sp_DeleteExamWithID;
DELIMITER $$
CREATE PROCEDURE sp_DeleteExamWithID (IN in_ExamID TINYINT UNSIGNED)
	BEGIN
		DELETE FROM ExamQuestion 
        WHERE 		ExamID = in_ExamID;
		DELETE FROM Exam 
        WHERE 		ExamID = in_ExamID;
	END$$
DELIMITER ;
CALL sp_DeleteExamWithID(7);

select * from exam;
# Question 10: Tìm ra các exam được tạo từ 3 năm trước và xóa các exam đó đi, sau đó in số lượng record đã remove từ các table liên quan
-- trong khi removing
DROP PROCEDURE IF EXISTS sp_DeleteUser3Years;
DELIMITER $$
CREATE PROCEDURE sp_DeleteUser3Years()
BEGIN
	WITH ExamID3Year AS(
		SELECT 	ExamID
		FROM 	Exam
		WHERE	(YEAR(NOW()) - YEAR(CreateDate)) > 3
    )
	DELETE
    FROM Exam
    WHERE ExamID = (
		SELECT * FROM ExamID3Year
    );
END$$
DELIMITER ;
-- Question 11: Viết store cho phép người dùng xóa phòng ban bằng cách người dùng
-- nhập vào tên phòng ban và các account thuộc phòng ban đó sẽ được chuyển về phòng
-- ban default là phòng ban chờ việc

DROP PROCEDURE IF EXISTS sp_DeleteDepartment;
DELIMITER $$
CREATE PROCEDURE sp_DeleteDepartment
(IN	in_DepartmentName NVARCHAR(50))
BEGIN
	UPDATE 	`Account`
    SET		DepartmentID = 10
    WHERE	DepartmentID = (SELECT 	DepartmentID	
							FROM	Department
							WHERE 	DepartmentName = in_DepartmentName);
	DELETE 
    FROM	Department
    WHERE	DepartmentName = in_DepartmentName;
END$$
DELIMITER ;

-- Question 12: Viết store để in ra mỗi tháng có bao nhiêu câu hỏi được tạo trong năm nay

DROP PROCEDURE IF EXISTS sp_CountQuesInMonth;
DELIMITER $$
CREATE PROCEDURE sp_CountQuesInMonth()
BEGIN
		SELECT EachMonthInYear.MONTH, COUNT(QuestionID) AS COUNT
		FROM
		(
					SELECT 1 AS MONTH
                    UNION SELECT 2 AS MONTH
                    UNION SELECT 3 AS MONTH
                    UNION SELECT 4 AS MONTH
                    UNION SELECT 5 AS MONTH
                    UNION SELECT 6 AS MONTH
                    UNION SELECT 7 AS MONTH
                    UNION SELECT 8 AS MONTH
                    UNION SELECT 9 AS MONTH
                    UNION SELECT 10 AS MONTH
                    UNION SELECT 11 AS MONTH
                    UNION SELECT 12 AS MONTH
        ) AS EachMonthInYear
		LEFT JOIN Question ON EachMonthInYear.MONTH = MONTH(CreateDate)
		GROUP BY EachMonthInYear.MONTH
		ORDER BY EachMonthInYear.MONTH ASC;
END$$
DELIMITER ;

CALL sp_CountQuesInMonth();
-- Question 13: Viết store để in ra mỗi tháng có bao nhiêu câu hỏi được tạo trong 6
-- tháng gần đây nhất (nếu tháng nào không có thì sẽ in ra là "không có câu hỏi nào
-- trong tháng")
/* -- Hàm DATE_SUB trả về một ngày mà sau đó một khoảng thời gian/ngày nhất định đã bị trừ */
DROP PROCEDURE IF EXISTS sp_CountQuesPrevious6Month;
DELIMITER $$
CREATE PROCEDURE sp_CountQuesPrevious6Month()
BEGIN
		SELECT Previous6Month.MONTH, COUNT(QuestionID) AS COUNT
		FROM
		(
			SELECT MONTH(CURRENT_DATE - INTERVAL 5 MONTH) AS MONTH
			UNION
			SELECT MONTH(CURRENT_DATE - INTERVAL 4 MONTH) AS MONTH
			UNION
			SELECT MONTH(CURRENT_DATE - INTERVAL 3 MONTH) AS MONTH
			UNION
			SELECT MONTH(CURRENT_DATE - INTERVAL 2 MONTH) AS MONTH
			UNION
			SELECT MONTH(CURRENT_DATE - INTERVAL 1 MONTH) AS MONTH
			UNION
			SELECT MONTH(CURRENT_DATE - INTERVAL 0 MONTH) AS MONTH
        ) AS Previous6Month
		LEFT JOIN Question ON Previous6Month.MONTH = MONTH(CreateDate)
		GROUP BY Previous6Month.MONTH
		ORDER BY Previous6Month.MONTH ASC;
END$$
DELIMITER ;

CALL sp_CountQuesPrevious6Month();