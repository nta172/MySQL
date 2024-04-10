/*================TRUY VẤN DỮ LIỆU===========================*/
/*===========================================================*/

#Question 2: Viết lệnh để lấy ra tất cả các thực tập sinh đã vượt qua bài test đầu vào, nhóm chúng thành các tháng sinh khác nhau
SELECT		GROUP_CONCAT(Full_Name) ,GROUP_CONCAT(YEAR(Birth_Date), '-', MONTH(Birth_Date))
FROM		Trainee
GROUP BY	MONTH(Birth_Date), YEAR(Birth_Date)
;

SELECT		*
FROM		Trainee
;
#Question 3: Viết lệnh để lấy ra thực tập sinh có tên dài nhất, lấy ra các thông tin sau: tên, tuổi, các thông tin cơ bản (như đã được định nghĩa trong table)
SELECT		*	
FROM		Trainee
WHERE		LENGTH(Full_Name) = (SELECT MAX(LENGTH(Full_Name)) FROM Trainee)
;
#Question 4: Viết lệnh để lấy ra tất cả các thực tập sinh là ET, 1 ET thực tập sinh là những người đã vượt qua bài test đầu vào và thỏa mãn số điểm như sau:
# ET_IQ + ET_Gmath>=20
# ET_IQ>=8
# ET_Gmath>=8
# ET_English>=18
SELECT		*
FROM		Trainee
WHERE		ET_IQ + ET_Gmath >= 20
		AND ET_IQ >= 8
        AND ET_Gmath >= 8
        AND ET_English >= 18
;        
#Question 5: xóa thực tập sinh có TraineeID = 3
DELETE
FROM		Trainee
WHERE		TraineeID = 3
;

SELECT		*
FROM		Trainee
;
#Question 6: Thực tập sinh có TraineeID = 5 được chuyển sang lớp "2". Hãy cập nhật thông tin vào database
UPDATE		Trainee
SET			Trainning_Class = 'VTI002'
WHERE		TraineeID = 5
;