USE Testing_System_Assignment;
#Question 1 : Tạo trigger KHÔNG cho phép người dùng nhập vào Group có ngày tạo trước 1 năm trước
DROP TRIGGER IF EXISTS Trigger_CheckInsertGroup;
DELIMITER $$
	CREATE TRIGGER Trigger_CheckInsertGroup
    BEFORE INSERT ON `Group`
    FOR EACH ROW
    BEGIN
		DECLARE v_CreateDate DATETIME;
        SET v_CreateDate = DATE_SUB(NOW(), INTERVAL 1 YEAR);
        IF (NEW.CreateDate <= v_CreateDate) THEN
			SIGNAL SQLSTATE '12345'
            SET MESSAGE_TEXT = 'Cannot create this group';
        END IF;
    END$$
DELIMITER ;

INSERT INTO `Group` (`GroupName`, `CreatorID`, `CreateDate`)
VALUES ('2', '1', '2023-04-10 00:00:00');
#Question 2 : Tạo trigger KHÔNG cho phép người dùng thêm bất kì User nào vào department 'Sale' nữa, 
-- khi thêm thì hiện ra thông báo "Department "Sale" cannot add more user"
DROP TRIGGER IF EXISTS Trigger_NotAddUserToSale;
DELIMITER $$
	CREATE TRIGGER Trigger_NotAddUserToSale
	BEFORE INSERT ON `Account` 
    FOR EACH ROW
    BEGIN
    DECLARE v_DeptID TINYINT;
		SELECT 		D.DepartmentID INTO v_DeptID 
        FROM		Department D
        WHERE		D.DepartmentName = 'Sale';
        IF (NEW.DepartmentID = v_DeptID) THEN
			SIGNAL SQLSTATE '12345'
            SET MESSAGE_TEXT = 'Cannot add more User to Sale';
        END IF;    
     END$$       
DELIMITER ;

INSERT INTO `Account` (`Email`, `Username`, `FullName`, `DepartmentID`, `PositionID`, `CreateDate`)
VALUES ('1','1', '1', '2', '1', '2023-11-13 00:00:00');
# Question 3 : Cấu hình 1 group có nhiều nhất là 5 user
DROP TRIGGER IF EXISTS Trigger_CheckToAddAccountToGroup;
DELIMITER $$
	CREATE TRIGGER Trigger_CheckToAddAccountToGroup
    BEFORE INSERT ON GroupAccount
    FOR EACH ROW
	BEGIN
		DECLARE var_CountGroupID TINYINT;
		SELECT 	COUNT(GA.GroupID) INTO var_CountGroupID
        FROM 	GroupAccount	GA
        WHERE	GA.AccountID = NEW.AccontID;
        IF (var_CountGroupID > 5) THEN
			SIGNAL SQLSTATE '12345'
            SET MESSAGE_TEXT = 'Cannot add more User to this Group';
        END IF;    
    END$$
DELIMITER ;

INSERT INTO GroupAccount (`GroupID`, `AccountID`, `JoinDate`)
VALUES (1, 6, '2020-05-11 00:00:00');
# Question 4 : Cấu hình 1 bài thi có nhiều nhất là 10 question
DROP TRIGGER IF EXISTS Trigger_LimitQuesNumInExam10;
DELIMITER $$
	CREATE TRIGGER Trigger_LimitQuesNumInExam10
    BEFORE INSERT ON ExamQuestion
    FOR EACH ROW
    BEGIN
		DECLARE 	v_CountQuesInExam TINYINT;
        SELECT 		COUNT(EQ.QuestionID) INTO v_CountQuesInExam
        FROM		ExamQuestion EQ
        WHERE		EQ.ExamID = NEW.ExamID;
        IF (v_CountQuesInExam > 10) THEN
			SIGNAL SQLSTATE '12345'
            SET MESSAGE_TEXT = 'Num Question in this Exam is limited 10';
        END IF;    
    END$$
DELIMITER ;

INSERT INTO `ExamQuestion`(`ExamID`, `QuestionID`) 
VALUES (2, 3);
# Question 5 : Tạo trigger không cho phép người dùng xóa tài khoản có email là admin@gmail.com
-- (đây là tài khoản admin, không cho phép user xóa), còn lại các tài khoản khác thì sẽ xóa tất cả 
-- các thông tin liên quan tới user đó
DROP TRIGGER IF EXISTS Trigger_Delete_Account;
DELIMITER $$
	CREATE TRIGGER Trigger_Delete_Account
    BEFORE DELETE ON `Account`
    FOR EACH ROW
    BEGIN
		DECLARE v_Email VARCHAR(50);
        SET 	v_Email = 'haidang29productions@gmail.com';
        IF (OLD.Email = v_Email) THEN
			SIGNAL SQLSTATE '12345'
            SET MESSAGE_TEXT = 'Cannot delete Email of Admin';
        END IF;    
    END$$
DELIMITER ;

DELETE 
FROM `Account`
WHERE Email = 'haidang29productions@gmail.com';

# Question 6: Không sử dụng cấu hình default cho field DepartmentID của table Account
-- hãy tạo trigger cho phép người dùng khi tạo account không điền vào departmentID 
-- thì sẽ được phân vào phòng ban "waiting Department"
DROP TRIGGER IF EXISTS Trigger_SetDepWaittingRoom;
DELIMITER $$
	CREATE TRIGGER Trigger_SetDepWaittingRoom
    BEFORE INSERT ON `Account`
    FOR EACH ROW
    BEGIN
		DECLARE v_WaitingRoom VARCHAR(50);
        SELECT	D.DepartmentID INTO v_WaitingRoom
        FROM	Department D
        WHERE	D.DepartmentName = 'Waiting Department';
        IF (NEW.DepartmentID IS NULL) THEN
			SET NEW.DepartmentID = v_WaitingRoom;
        END IF;    
    END$$
DELIMITER ;

INSERT INTO `Account` (`Email`, `Username`, `FullName`, `PositionID`, `CreateDate`)
VALUES ('ngtheanh@gmail.com','ngtheanh', 'Nguyen The Anh', '1', '2024-07-15 00:00:00');
SELECT * FROM `Account`;
SELECT * FROM Department;
# Question 7: Cấu hình 1 bài thi chỉ cho phép user tạo tối đa 4 answers cho mỗi question, 
-- trong đó có tối đa 2 đáp án đúng.

# Cách tác giả =)) hơi lỏ
DROP TRIGGER IF EXISTS Trigger_SetMaxAnswer;
DELIMITER $$
	CREATE TRIGGER Trigger_SetMaxAnswer
    BEFORE INSERT ON Answer 
    FOR EACH ROW
    BEGIN
		DECLARE 	v_CountAnsInQues TINYINT;
        DECLARE 	v_CountAnsCorrects TINYINT;
		SELECT		COUNT(A.QuestionID)	INTO v_CountAnsInQues
        FROM		Answer A
        WHERE		A.QuestionID = NEW.QuestionID AND A.isCorrect = NEW.isCorrect;
        SELECT 		COUNT(1) INTO v_CountAnsCorrects
        FROM		Answer A
        WHERE		A.QuestionID = NEW.QuestionID AND A.isCorrect = NEW.isCorrect;
        IF (v_CountAnsInQues > 4) OR (v_CountAnsCorrects > 2) THEN
			SIGNAL SQLSTATE '12345'
            SET MESSAGE_TEXT = 'Cannot insert more data please check again!';
        END IF;    
    END$$
DELIMITER ;

# Tự hiểu theo chỉnh sửa : Đúng theo hướng dẫn đề bài
DROP TRIGGER IF EXISTS Trigger_SetMaxAnswer;
DELIMITER $$
	CREATE TRIGGER Trigger_SetMaxAnswer
    BEFORE INSERT ON Answer
    FOR EACH ROW
    BEGIN
		DECLARE CountAnswer TINYINT UNSIGNED;
        DECLARE CountCorrectAnswer TINYINT UNSIGNED;
			SELECT 	COUNT(AnswerID) INTO CountAnswer
            FROM 	Answer
            WHERE 	QuestionID = NEW.QuestionID;
            
			SELECT 	COUNT(1) INTO CountCorrectAnswer
            FROM 	Answer
            WHERE 	QuestionID = NEW.QuestionID AND isCorrect = NEW.isCorrect;
            
		IF CountAnswer >= 4 OR CountCorrectAnswer >= 2 THEN 
			SIGNAL SQLSTATE '12345'
			SET MESSAGE_TEXT = 'Cannot insert data';
		END IF;
	END $$
DELIMITER ;

INSERT INTO Answer (`Content`, `QuestionID`, `isCorrect`) 
VALUES ('Trả lời 11', '1', 1);
SELECT * FROM Answer;

# Question 8: Viết trigger sửa lại dữ liệu cho đúng:
-- Nếu người dùng nhập vào gender của account là nam, nữ, chưa xác định
-- Thì sẽ đổi lại thành M, F, U cho giống với cấu hình ở database
DROP TRIGGER IF EXISTS Trigger_GenderFromInput;
DELIMITER $$
	CREATE TRIGGER Trigger_GenderFromInput
    BEFORE INSERT ON `Account` 
    FOR EACH ROW
    BEGIN
		IF (NEW.Gender = 'Nam') THEN
			SET NEW.Gender = 'M';
		ELSEIF (NEW.Gender = 'Nữ') THEN
			SET NEW.Gender = 'F';
        ELSEIF (NEW.Gender = 'Unknown') THEN
			SET	NEW.Gender = 'U';
        END IF;    
    END$$
DELIMITER ;
#Question 9: Viết trigger không cho phép người dùng xóa bài thi mới tạo được 2 ngày
DROP TRIGGER IF EXISTS Trigger_CheckBefDelExam;
DELIMITER $$
	CREATE TRIGGER Trigger_CheckBefDelExam
    BEFORE DELETE ON Exam
    FOR EACH ROW
    BEGIN
		DECLARE	v_CreateDate DATETIME;
        SET v_CreateDate = DATE_SUB(NOW(), INTERVAL 2 DAY);
        IF (OLD.CreateDate > v_CreateDate) THEN
			SIGNAL SQLSTATE '12345'
            SET MESSAGE_TEXT = 'Cannot Delete This Exam';
        END IF;    
    END$$
DELIMITER ;
DELETE 
FROM 	Exam E 
WHERE 	E.ExamID =1;
SELECT * FROM Exam;

# Question 10: Viết trigger chỉ cho phép người dùng chỉ được update, 
-- delete các question khi question đó chưa nằm trong exam nào
DROP TRIGGER IF EXISTS Trg_CheckBefUpdateQues;
DELIMITER $$
	CREATE TRIGGER Trg_CheckBefUpdateQues
	BEFORE UPDATE ON Question
	FOR EACH ROW
	BEGIN
		DECLARE v_CountQuesByID TINYINT;
		SET 	v_CountQuesByID = -1;
		SELECT 	COUNT(1) INTO v_CountQuesByID 
        FROM 	ExamQuestion Ex 
        WHERE 	Ex.QuestionID = NEW.QuestionID;
		IF (v_CountQuesByID != -1) THEN
			SIGNAL SQLSTATE '12345'
			SET MESSAGE_TEXT = 'Cant Update This Question';
		END IF ;
	END $$
DELIMITER ;
UPDATE 	Question 
SET 	`Content` = 'Question VTI 2599 lL6 1' 
WHERE 	(`QuestionID` = '1');
# Trường hợp DELETE :
DROP TRIGGER IF EXISTS Trg_CheckBefDeleteQues;
DELIMITER $$
	CREATE TRIGGER Trg_CheckBefDeleteQues
	BEFORE DELETE ON Question
	FOR EACH ROW
	BEGIN
		DECLARE v_CountQuesByID TINYINT;
		SET v_CountQuesByID = -1;
		SELECT 	COUNT(1) INTO v_CountQuesByID 
        FROM 	ExamQuestion Ex
        WHERE 	Ex.QuestionID = OLD.QuestionID;
			IF (v_CountQuesByID != -1) THEN
		SIGNAL SQLSTATE '12345'
		SET MESSAGE_TEXT = 'Cant Delete This Question';
			END IF ;
	END $$
DELIMITER ;
DELETE 
FROM 	Question 
WHERE 	(`QuestionID` = '1');

select * from question;
#Question 12 : Lấy ra thông tin exam trong đó:
-- Duration <= 30 thì sẽ đổi thành giá trị "Short time"
-- 30 < Duration <= 60 thì sẽ đổi thành giá trị "Medium time"
-- Duration > 60 thì sẽ đổi thành giá trị "Long time"

SELECT * FROM exam;
SELECT E.ExamID, E.`Code`, E.Title , CASE
		WHEN Duration <= 30 THEN 'Short time'
		WHEN Duration <= 60 THEN 'Medium time'
		ELSE 'Longtime'
END AS Duration, E.CreateDate, E.Duration
FROM Exam E;

# Question 13: Thống kê số account trong mỗi group và in ra thêm 1 column nữa có tên
-- là the_number_user_amount và mang giá trị được quy định như sau:
-- Nếu số lượng user trong group =< 5 thì sẽ có giá trị là few
-- Nếu số lượng user trong group <= 20 và > 5 thì sẽ có giá trị là normal
-- Nếu số lượng user trong group > 20 thì sẽ có giá trị là higher

SELECT 		GA.GroupID, COUNT(GA.GroupID),
			CASE
				WHEN COUNT(GA.GroupID) <= 5 THEN 'Few'
                WHEN 5 < COUNT(GA.GroupID) <= 20 THEN 'Normal'
			ELSE 'Higher'
            END AS 'the_number_user_amount'
FROM		GroupAccount GA
GROUP BY	GA.GroupID;

# Question 14: Thống kê số mỗi phòng ban có bao nhiêu user, nếu phòng ban nào
-- không có user thì sẽ thay đổi giá trị 0 thành "Không có User"
SELECT 		D.DepartmentName,
			CASE 
				WHEN COUNT(A.DepartmentID) = 0 THEN 'Không có User'
                ELSE COUNT(A.DepartmentID)
				END AS SL
FROM		Department D
LEFT JOIN	`Account` A ON D.DepartmentID = A.DepartmentID
GROUP BY	D.DepartmentID
;
