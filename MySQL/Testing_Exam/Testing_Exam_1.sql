DROP DATABASE IF EXISTS Testing_Exam_1;
CREATE DATABASE IF NOT EXISTS Testing_Exam_1;
-- Use Database
USE Testing_Exam_1;

-- Create Table Employee
CREATE TABLE 	CUSTOMER ( 
	CustomerID 					INT AUTO_INCREMENT PRIMARY KEY,
	`Name`						VARCHAR(30) NOT NULL,
	Phone 						CHAR(13) NOT NULL,
	Email 						VARCHAR(50) UNIQUE NOT NULL,
	Address 					VARCHAR(100) NOT NULL,
    Note						VARCHAR(500) NOT NULL
);

-- Create Table CAR
CREATE TABLE 	CAR (
	CarID 						INT AUTO_INCREMENT PRIMARY KEY,
	Maker						ENUM('HONDA','TOYOTA','NISSAN') NOT NULL ,
	Model 						CHAR(13) NOT NULL,
	`Year` 						SMALLINT UNIQUE NOT NULL,
	Color 						VARCHAR(50) NOT NULL,
    Note						VARCHAR(500) NOT NULL
);

-- Create Table CAR_ORDER
CREATE TABLE 	CAR_ORDER ( 
	OrderID 					INT AUTO_INCREMENT PRIMARY KEY,
	CustomerID					INT NOT NULL ,
	CarID 						INT NOT NULL,
	Amount						SMALLINT DEFAULT 1 NOT NULL,
	SalePrice 					DOUBLE NOT NULL,
	OrderDate 					DATE NOT NULL,
	DeliveryDate 				DATE NOT NULL,
	DeliveryAddress 			VARCHAR(100) NOT NULL,
	Staus 						TINYINT(2) DEFAULT 0 NOT NULL,
    Note						VARCHAR(500) NOT NULL,
    FOREIGN KEY (CarID) REFERENCES  CAR(CarID) ON DELETE CASCADE,
    FOREIGN KEY (CustomerID) REFERENCES  CUSTOMER(CustomerID) ON DELETE CASCADE
);

 -- Insert CUSTOMER
INSERT INTO	CUSTOMER (`Name`,	Phone		,		Email,					Address,						Note	)
VALUES				 ('A',		'123456'	,		'acb@gmail.com' ,		'HN'   ,						'1'		),
					 ('A1',		'1234562'	,		'acb1@gmail.com',		'H1N'  ,						'21'	),
					 ('A2',		'1234564'	,		'acb2@gmail.com',		'HN2'  ,						'12'	);
	
 INSERT INTO	CAR  (  Maker ,			Model    ,		`Year`,			Color,			Note)
VALUES				 ('HONDA' ,			'HONDA1' ,		1990  ,			'YEALLOW',		'1'	),
					 ('TOYOTA',			'TOYOTA1',		1992  ,			'BLUE',			'12'),
					 ('NISSAN',			'NISSAN1',		1994  ,			'RED',			'111');
	
INSERT INTO		CAR_ORDER (CustomerID,	CarID,	Amount,		SalePrice, 		OrderDate, 	  DeliveryDate, DeliveryAddress, Staus 	,Note)
VALUES					  (  1 ,		 2  ,	  2,		5.000000,		'2000-03-01', '2000-03-21',		'HN' , 1	,		'123'	),
						  (  2 ,		 2  ,	  2,		6.000000,		'2000-03-04', '2000-03-10',		'HN1', 2	,		'1234'	),
						  ( 3  ,		 2  ,	  2,		8.000000,		'2000-03-08', '2000-03-15',		'HN2', 2	,		'1235'	),
						  ( 3  ,		 1  ,	  7,		8.000000,		'2000-03-08', '2000-03-15',		'HN2', 0 	,		'1235'	);
                 
                 
# Queston :
# 2. Viết lệnh lấy ra thông tin của khách hàng: tên, số lượng oto khách hàng đã mua 
-- và sắp sếp tăng dần theo số lượng oto đã mua.
SELECT 		C.`Name` , COUNT(Ca.CarID) AS 'So_luong_oto_da_mua'
FROM		Customer 	C 
INNER JOIN	Car_Order	Ca ON C.CustomerID = Ca.CustomerID
GROUP BY	C.CustomerID
ORDER BY	'So_luong_oto_da_mua' ASC
; 
# 3. Viết hàm (không có parameter) trả về tên hãng sản xuất đã bán được nhiều oto nhất trong năm nay.
DROP PROCEDURE IF EXISTS sp_SellOtoMaxInYear;
DELIMITER $$
	CREATE PROCEDURE sp_SellOtoMaxInYear()
		BEGIN
			SELECT 		C.Maker 
            FROM		Car 	C 
            INNER JOIN	Car_Order Ca ON C.CarID = Ca.CarID
            GROUP BY	Ca.CarID
            HAVING		COUNT(C.CarID) = (SELECT MAX(CountMaker) AS CountMaxMaker
										   FROM		(SELECT	 COUNT(Ca.CarID) AS CountMaker
													 FROM	 Car_Order Ca
                                                     GROUP BY Ca.CarID ) AS CountTableMaker)
            ;
        END$$
DELIMITER ;

CALL sp_SellOtoMaxInYear();
# 4. Viết 1 thủ tục (không có parameter) để xóa các đơn hàng đã bị hủy của những năm trước. 
-- In ra số lượng bản ghi đã bị xóa.
DROP PROCEDURE IF EXISTS sp_DelOrderCanCelYearOld;
DELIMITER $$
	CREATE PROCEDURE sp_DelOrderCanCelYearOld()
		BEGIN
			DELETE
            FROM		Car_Order
            WHERE		Staus = '2' AND YEAR(OrderDate) < (YEAR(NOW()));
        END$$
DELIMITER ;

# 5. Viết 1 thủ tục (có CustomerID parameter) để in ra thông tin của các 
-- đơn hàng đã đặt hàng bao gồm: tên của khách hàng, mã đơn hàng, số lượng oto
-- và tên hãng sản xuất.
DROP PROCEDURE IF EXISTS sp_InforOrder;
DELIMITER $$
	CREATE PROCEDURE sp_InforOrder(IN CustomerID INT SIGNED)
		BEGIN
    SELECT CUSTOMER.`Name`, CAR_ORDER.OrderID, CAR_ORDER.Amount, CAR.Maker
    FROM CUSTOMER
    INNER JOIN CAR_ORDER ON CUSTOMER.CustomerID = CAR_ORDER.CustomerID
    INNER JOIN CAR ON CAR_ORDER.CarID = CAR.CarID
    WHERE CUSTOMER.CustomerID = CustomerID;
        END$$
DELIMITER ;

CALL sp_InforOrder('1');
# 6. Viết trigger để tránh trường hợp người dụng nhập thông tin không hợp lệ
-- vào database (DeliveryDate < OrderDate + 15).
                          
DROP TRIGGER IF EXISTS Trigger_ImportInforError;
DELIMITER $$
	CREATE TRIGGER Trigger_ImportInforError
	BEFORE INSERT ON Car_Order
    FOR EACH ROW
		BEGIN
IF NEW.DeliveryDate < DATE_SUB(NEW.OrderDate, INTERVAL 15 DAY) THEN
	SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'DeliveryDate must be at least 15 days after OrderDate';
    END IF;
        END$$
DELIMITER ;        

INSERT INTO		CAR_ORDER (CustomerID,	CarID,	Amount,		SalePrice, 		OrderDate, 	  DeliveryDate, DeliveryAddress, Staus 	,Note)
VALUES					  (  1 ,		 2  ,	  2,		5.000000,		'2000-04-22', '2000-03-21',		'HN' , 1	,		'123'	);               