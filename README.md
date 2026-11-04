# MyMeo — Personal Manager v2

Ứng dụng web/PWA quản lý công việc, lịch phân công nhiều nhân sự, nhân sự, vật tư và nhập/xuất kho. Frontend tĩnh; Supabase Auth + PostgreSQL là backend.

## Tính năng v2
- Sidebar có nút thu gọn/mở rộng trên desktop; menu trượt và nút đóng trên mobile, chạm nền tối để đóng.
- Dashboard timeline theo ngày, chia từng giờ từ 00:00–23:00; hiển thị đầu mục, thời gian, trạng thái, ưu tiên và danh sách nhân sự được phân công.
- Một công việc có thể phân công nhiều nhân sự.
- Thông báo trong ứng dụng khi nhân sự mới được thêm vào một công việc; có badge chưa đọc và đánh dấu đã đọc.
- Tự tải lại dữ liệu định kỳ 60 giây; tải dữ liệu song song, giới hạn số bản ghi tải mỗi bảng và debounce tìm kiếm.
- PWA, giao diện responsive, cache phiên bản mới và ưu tiên lấy phiên bản mới nhất của HTML/CSS/JS.
- Giữ các phân hệ nhân sự, vật tư, nhập/xuất kho, báo cáo, sao lưu JSON và xuất CSV.

## Cấu hình Supabase
Trong `app.js`, cấu hình `SUPABASE_URL` bằng Project URL gốc (không thêm `/rest/v1/`) và `SUPABASE_ANON_KEY` bằng Publishable Key (`sb_publishable_...`). Không bao giờ đưa Secret Key (`sb_secret_...`) vào frontend.

## Cập nhật database cho v2
1. Mở Supabase Dashboard → SQL Editor → New query.
2. Mở file `migration_v2.sql`, copy toàn bộ nội dung, paste vào SQL Editor và Run.
3. Migration tạo bảng `shift_assignments`, `notifications`, bổ sung `priority`, `description` cho `shifts`, bật RLS/policies và chuyển các phân công cũ từ `shifts.employee_id` sang bảng liên kết mới.
4. Kiểm tra Table Editor có `shift_assignments` và `notifications`.

Không cần chạy lại `schema.sql` nếu MyMeo v1 đã được cài đặt.

## Đẩy bản v2 lên GitHub Pages
1. Giải nén ZIP.
2. Mở repository GitHub `MyMeo` → Add file → Upload files.
3. Upload các file mới trong thư mục `WorkSpace_Personal_Manager` vào thư mục gốc repository và xác nhận thay thế các file cùng tên: `index.html`, `app.js`, `styles.css`, `sw.js`, `manifest.webmanifest`, `README.md`.
4. Upload thêm `migration_v2.sql` vào root (hoặc chỉ giữ file này để chạy migration; không bắt buộc app phải tải file SQL).
5. Commit changes. GitHub Pages sẽ tự triển khai lại.
6. Mở MyMeo, đăng xuất/đăng nhập lại nếu cần. Nếu trình duyệt giữ giao diện cũ, đóng hẳn tab/app rồi mở lại; service worker v2 sẽ cập nhật cache.

## Kiểm thử
- Desktop: nút ‹ cạnh logo thu gọn sidebar; nút › mở rộng.
- Mobile: nút ☰ mở menu; nút × hoặc chạm vùng nền tối để đóng.
- Dashboard: đổi ngày bằng ô ngày hoặc nút ‹ / ›; công việc hiển thị đúng giờ và nhân sự.
- Công việc & lịch: Tạo công việc, chọn nhiều nhân sự, ngày, giờ, ưu tiên, trạng thái; lưu và kiểm tra trên Dashboard.
- Chuông thông báo: kiểm tra thông báo mới được tạo khi bổ sung nhân sự vào công việc.

## Giới hạn hiện tại của thông báo
Thông báo v2 là thông báo bên trong tài khoản quản lý MyMeo. Hồ sơ nhân sự hiện chưa có tài khoản đăng nhập riêng, vì vậy chưa thể gửi thông báo trực tiếp tới điện thoại/tài khoản cá nhân của từng nhân sự. Muốn có thông báo đẩy/email cho từng người, cần bổ sung định danh tài khoản cho nhân sự và tích hợp dịch vụ gửi thông báo (ví dụ email hoặc Web Push).

## Lưu ý
- Dữ liệu được phân tách theo `user_id` bằng Supabase Row Level Security.
- Bản v2 kiểm tra và tải dữ liệu định kỳ 60 giây; đây chưa phải đồng bộ realtime tức thời.
- Bản MVP chưa phải hệ thống quản trị doanh nghiệp production-ready. Nên sao lưu dữ liệu định kỳ.
