SELECT * FROM Answer;
DELETE FROM Answer WHERE AnswerID = 1;

TRUNCATE Answer;
#Truncate không dùng đc where
#Truncate xong khi tạo bản ghi mới sẽ đếm lại từ đầu
#Delete xong thì bản ghi sẽ ghi tiếp theo vị trí tiếp theo
#Truncate không thể ROLLBACK lại được trong Transaction;
#Truncate dùng để xóa nhanh một bảng (Tốc độ xóa nhanh)
#Truncate xóa tất cả carc record nhưng không xóa structure table