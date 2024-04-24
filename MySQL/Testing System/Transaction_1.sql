USE Testing_System_Assignment;
# Insert Account
# Insert Account --> Group
# Insert Account --> Change Department

SET autocommit = ON;
# Tự thực hiện Start transaction cho mỗi dòng lệnh.

SET autocommit = OFF;
# Bắt đầu một cái giao dịch
START TRANSACTION;

INSERT INTO `Account`    (			Email 				, Username	  , FullName			  , DepartmentID, PositionID, CreateDate  )
VALUES					 ('nguyentheanh2003@gmail.com'  , 'ngtheanh'  , 'Nguyễn Thế Anh'      ,      5  	,     1 	, '2024-03-05');

INSERT INTO GroupAccount    ( GroupID , AccountID ,   JoinDate  )
VALUES                  	(    1    ,     11    , '2023-03-05');

# ROLLBACK;

UPDATE 		`Account`
SET			DepartmentID = 6
WHERE		AccountID = 11;

COMMIT;

SELECT * FROM  `Account`;
SELECT * FROM  GroupAccount;