USE Testing_System_Assignment;
# Question 1: Tạo store để người dùng nhập vào tên phòng ban và in ra tất cả các account thuộc phòng ban đó 
DROP PROCEDURE IF EXISTS sp_GetAccFromDep;
DELIMITER $$
CREATE PROCEDURE sp_GetAccFromDep (IN in_dep_name NVARCHAR(50))
		BEGIN 
			SELECT		Ac.AccountID, Ac.FullName ,De.DepartmentName
            FROM 		Department De
            INNER JOIN	`Account` Ac ON Ac.DepartmentID = De.DepartmentID
            WHERE		De.DepartmentName = in_dep_name;
        END$$
DELIMITER ;     

-- USE
CALL  sp_GetAccFromDep('Sale');

# Question 2: Tạo store để in ra số lượng account trong mỗi group
DROP PROCEDURE IF EXISTS sp_GetCountAccFromGroup;
DELIMITER $$
CREATE PROCEDURE sp_GetCountAccFromGroup(IN in_GroupID TINYINT UNSIGNED)
	BEGIN
		SELECT 		GroupID, COUNT(AccountID)
		FROM		GroupAccount 
		WHERE		GroupID = in_GroupID
		GROUP BY	GroupID;
	END$$
DELIMITER ;
CALL sp_GetCountAccFromGroup(1);


# Question 3: Tạo store để thống kê mỗi type question có bao nhiêu question được tạo trong tháng hiện tại
DROP PROCEDURE IF EXISTS sp_GetCountTypeInMonth;
DELIMITER $$
CREATE PROCEDURE sp_GetCountTypeInMonth()
	BEGIN
		SELECT 		TQ.TypeName, count(Qu.TypeID) 
        FROM 		Question 		Qu
		INNER JOIN 	TypeQuestion 	TQ ON Qu.TypeID = TQ.TypeID
		WHERE month	(Qu.CreateDate) = MONTH(NOW()) AND YEAR(QU.CreateDate) = YEAR(NOW())
		GROUP BY 	Qu.TypeID;
	END$$
DELIMITER ;
CALL sp_GetCountTypeInMonth();
# Question 4: Tạo store để trả ra id của type question có nhiều câu hỏi nhất
DROP PROCEDURE IF EXISTS sp_GetCountQuesFromType;
DELIMITER $$
CREATE PROCEDURE sp_GetCountQuesFromType()
	BEGIN
		WITH CTE_MaxTypeID AS(
			SELECT 		COUNT(Qu.TypeID) AS SL
            FROM 		Question Qu
			GROUP BY 	Qu.TypeID
			)
		SELECT 			TQ.TypeName, COUNT(Qu.TypeID) AS So_luong
        FROM 			Question Qu
		INNER JOIN 		TypeQuestion TQ ON TQ.TypeID = Qu.TypeID
		GROUP BY 		Qu.TypeID
		HAVING 			COUNT(Qu.TypeID) = (SELECT MAX(SL) FROM CTE_MaxTypeID);
END$$
DELIMITER ;
CALL sp_GetCountQuesFromType();
# Question 5: Sử dụng store ở question 4 để tìm ra tên của type question
DROP PROCEDURE IF EXISTS id_type_question_questions_1;
DELIMITER $$
CREATE PROCEDURE id_type_question_questions_1 (IN in_id_type_ques_1 TINYINT SIGNED, OUT out_name_type_ques ENUM('Essay','Multiple-Choice'))
	BEGIN
		SELECT 		TypeID	INTO out_name_type_ques
        FROM		Question
        WHERE		TypeID = in_id_type_ques_1
        GROUP BY	TypeID
        HAVING		COUNT(QuestionID) = (SELECT MAX(CountQues) AS CountMaxQues
										 FROM	(SELECT		COUNT(QuestionID) AS CountQues
												 FROM		Question
                                                 GROUP BY	TypeID) AS CountTableQues)
        ;
    END$$
DELIMITER ;    
SET @TypeName = '';
CALL id_type_question_questions_1(2, @TypeName);  
SELECT @TypeName;

DROP PROCEDURE IF EXISTS sp_GetCountQuesFromType;
DELIMITER $$
CREATE PROCEDURE sp_GetCountQuesFromType()
	BEGIN
		WITH CTE_MaxTypeID AS(
			SELECT 		COUNT(Qu.TypeID) AS SL 
            FROM 		Question Qu
			GROUP BY 	Qu.TypeID
			)
		SELECT 			TQ.TypeName, COUNT(q.TypeID) AS SL FROM Question Qu
		INNER JOIN		TypeQuestion TQ ON TQ.TypeID = Qu.TypeID
		GROUP BY 		Qu.TypeID
		HAVING 			COUNT(Qu.TypeID) = (SELECT MAX(SL) FROM CTE_MaxTypeID);
	END$$
DELIMITER ;
CALL sp_GetCountQuesFromType();
SET @ID = 0;
CALL sp_GetCountQuesFromType(@ID);
SELECT * FROM TypeQuestion WHERE TypeID = @ID;

DROP PROCEDURE IF EXISTS sp_findNameByIDTypeQuestion;
DELIMITER $$
CREATE PROCEDURE sp_findNameByIDTypeQuestion()
BEGIN

	WITH MAX_Count_TypeID AS(
		SELECT		COUNT(TypeID)
		FROM		Question 
		GROUP BY	TypeID
        ORDER BY	COUNT(TypeID) DESC
		LIMIT 		1
    )
    SELECT 		TQ.TypeName
    FROM		Question Q 
	INNER JOIN 	TypeQuestion TQ ON Q.TypeID = TQ.TypeID
    GROUP BY 	Q.TypeID
    HAVING		COUNT(Q.TypeID) = (SELECT * FROM MAX_Count_TypeID);		
	
END$$
DELIMITER ;

CALL sp_findNameByIDTypeQuestion()
