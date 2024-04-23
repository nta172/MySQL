#Question 1 : Tạo trigger KHÔNG cho phép người dùng nhập vào Group có ngày tạo trước 1 năm trước
#Question 2 : Tạo trigger KHÔNG cho phép người dùng thêm bất kì User nào vào department 'Sale' nữa, 
-- khi thêm thì hiện ra thông báo "Department "Sale" cannot add more user"
# Question 3 : Cấu hình 1 group có nhiều nhất là 5 user
# Question 4 : Cấu hình 1 bài thi có nhiều nhất là 10 question
# Question 5 : Tạo trigger không cho phép người dùng xóa tài khoản có email là admin@gmail.com
-- (đây là tài khoản admin, không cho phép user xóa), còn lại các tài khoản khác thì sẽ xóa tất cả 
-- các thông tin liên quan tới user đó
# Question 6: Không sử dụng cấu hình default cho field DepartmentID của table Account
-- hãy tạo trigger cho phép người dùng khi tạo account không điền vào departmentID 
-- thì sẽ được phân vào phòng ban "waiting Department"
# Question 7: Cấu hình 1 bài thi chỉ cho phép user tạo tối đa 4 answers cho mỗi question, 
-- trong đó có tối đa 2 đáp án đúng.
# Question 8: Viết trigger sửa lại dữ liệu cho đúng:
-- Nếu người dùng nhập vào gender của account là nam, nữ, chưa xác định
-- Thì sẽ đổi lại thành M, F, U cho giống với cấu hình ở database
#Question 9: Viết trigger không cho phép người dùng xóa bài thi mới tạo được 2 ngày
# Question 10: Viết trigger chỉ cho phép người dùng chỉ được update, 
-- delete các question khi question đó chưa nằm trong exam nào
#Question 12 : Lấy ra thông tin exam trong đó:
-- Duration <= 30 thì sẽ đổi thành giá trị "Short time"
-- 30 < Duration <= 60 thì sẽ đổi thành giá trị "Medium time"
-- Duration > 60 thì sẽ đổi thành giá trị "Long time"
# Question 13: Thống kê số account trong mỗi group và in ra thêm 1 column nữa có tên
-- là the_number_user_amount và mang giá trị được quy định như sau:
-- Nếu số lượng user trong group =< 5 thì sẽ có giá trị là few
-- Nếu số lượng user trong group <= 20 và > 5 thì sẽ có giá trị là normal
-- Nếu số lượng user trong group > 20 thì sẽ có giá trị là higher