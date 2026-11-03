# WorkSpace — Personal Work Manager

Ứng dụng PWA quản lý cá nhân: ca làm việc, nhân sự, vật tư, nhập/xuất kho, báo cáo và sao lưu.

## 1. Công nghệ & chi phí
- Frontend: HTML/CSS/JavaScript, có thể host tĩnh.
- Backend: Supabase (Auth + PostgreSQL + Row Level Security).
- PWA: có thể cài như ứng dụng trên trình duyệt hỗ trợ.
- Có thể bắt đầu trên các gói miễn phí; hạn mức và điều kiện của nhà cung cấp có thể thay đổi. Không cần mua tên miền riêng nếu dùng URL hosting miễn phí.

## 2. Thiết lập Supabase
1. Tạo project tại https://supabase.com/ (chọn gói Free nếu phù hợp).
2. Mở SQL Editor, chạy toàn bộ nội dung `schema.sql`.
3. Vào Project Settings → API, sao chép Project URL và anon/public key.
4. Mở `app.js`, thay hai giá trị trong `CONFIG`:
   - `SUPABASE_URL`
   - `SUPABASE_ANON_KEY`
   Chỉ dùng anon/public key ở frontend. Tuyệt đối không đưa service_role key vào ứng dụng.
5. Authentication → URL Configuration: sau khi deploy, khai báo Site URL và Redirect URLs phù hợp.
6. Authentication → Providers → Email: cấu hình xác nhận email theo nhu cầu. Với thử nghiệm, có thể tắt xác nhận email trong project riêng; không nên tắt tùy tiện ở môi trường chia sẻ.

## 3. Chạy thử trên máy tính
Cần chạy qua HTTP server (không mở trực tiếp file index.html nếu muốn PWA/service worker).
- Python: `python -m http.server 8080`
- Mở `http://localhost:8080`
Hoặc dùng VS Code Live Server.

## 4. Đưa lên Internet miễn phí
Có thể deploy thư mục này lên GitHub Pages hoặc dịch vụ static hosting tương đương. Sau khi deploy, mở URL trên máy tính/điện thoại và chọn Add to Home Screen / Install App. Cần cấu hình lại Supabase Auth URL theo tên miền được cấp.
GitHub Pages là hosting tĩnh; không chứa database. Dữ liệu vẫn nằm ở Supabase.

## 5. Các chức năng hiện có
- Đăng ký/đăng nhập email + mật khẩu.
- Tách dữ liệu theo user_id với Row Level Security.
- CRUD nhân sự, ca làm, vật tư, giao dịch kho.
- Tìm kiếm bảng; xuất CSV mở được bằng Excel.
- Dashboard và báo cáo tổng quan.
- Sao lưu JSON và nhập lại dữ liệu.
- Giao diện responsive và service worker cơ bản.

## 6. Lưu ý bản MVP
- Bản hiện tại là MVP khởi đầu, chưa phải hệ thống ERP hoàn chỉnh.
- Nhập/xuất kho cập nhật tồn hiện tại ở luồng nhập/xuất mới; chưa có quy trình kiểm kê, duyệt phiếu, khóa sổ hoặc nhật ký điều chỉnh.
- Cần nâng cấp xử lý tồn kho bằng PostgreSQL transaction/RPC để bảo đảm đồng thời và tránh sai lệch khi nhiều thao tác cùng lúc.
- Chưa có phân quyền nhiều vai trò trong cùng một workspace; hiện mỗi tài khoản có vùng dữ liệu riêng.
- Sao lưu JSON là bản sao dữ liệu hiện tại, file cần được giữ an toàn. Không chia sẻ file nếu có thông tin cá nhân.
- Dữ liệu trên thiết bị không được đảm bảo hoạt động ngoại tuyến đầy đủ; đồng bộ cần Internet.
