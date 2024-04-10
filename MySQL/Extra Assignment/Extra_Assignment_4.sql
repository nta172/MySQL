# Question 3 : Viết lệnh lấy ra danh sách nhân viên (name) có skill Java
SELECT			*
FROM			Employee_Table ET
INNER JOIN		Employee_Skill_Table EST
ON 				ET.Employee_Number = EST.Employee_Number
WHERE			EST.Skill_Code = 'Java'
;
#Question 4 : Viết lệnh để lấy ra danh sách các phòng ban có >= 3 nhân viên 
SELECT 			De.Department_Number, De.Department_Name, COUNT(De.Department_Number) 
FROM			Department De
INNER JOIN		Employee_Table ET
ON				De.Department_Number = ET.Department_Number
GROUP BY		De.Department_Number
HAVING			COUNT(De.Department_Number) >= 3
;
# Question 5 : Viết lệnh lấy ra danh sách nhân viên của mỗi văn phòng ban
SELECT 			ET.*
FROM			Department De
INNER JOIN		Employee_Table ET
ON				De.Department_Number = ET.Department_Number
ORDER BY 		De.Department_Number ASC
;

/*----------------------------------------------------------------*/
SELECT 			De.*, GROUP_CONCAT(ET.Employee_Name) AS 'Nhan_vien'
FROM			Department De 
INNER JOIN		Employee_Table ET
ON				De.Department_Number = ET.Department_Number
GROUP BY		De.Department_Number
HAVING			COUNT(De.Department_Number)
;
# Question 6 : Viết lệnh để lấy ra danh sách nhân viên có > 1 skills.
SELECT			ET.*, COUNT(ET.Department_Number) AS 'Nhan_vien > 1 skill'
FROM			Employee_Table ET
INNER JOIN		Employee_Skill_Table EST
ON				ET.Employee_Number = EST.Employee_Number
GROUP BY		EST.Employee_Number
HAVING			COUNT(EST.Employee_Number) > 1
;