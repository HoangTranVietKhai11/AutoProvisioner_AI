# AutoProvisioner_AI
Hệ thống cung cấp hạ tầng tự động & Cụm máy chủ Web độ sẵn sàng cao (High Availability) với Ansible, Docker và Telegram ChatOps.


## Kiến trúc hệ thống
Hệ thống được chia thành 5 máy chủ riêng biệt đảm nhận các vai trò khác nhau, bao gồm:
- **ansible-controller (Máy chủ điều khiển & Cân bằng tải):** `10.45.10.212` - Cài đặt Nginx làm cổng cân bằng tải.
- **web01:** `10.45.10.84` - Máy chủ Web số 1 (Chạy Docker, Node.js/Python).
- **web02:** `10.45.10.254` - Máy chủ Web số 2 (Chạy Docker, Node.js/Python).
- **db01:** `10.45.10.150` - Máy chủ Cơ sở dữ liệu (PostgreSQL).
- **monitor01:** `10.45.10.48` - Máy chủ Giám sát (Prometheus, Grafana).

## Tính năng nổi bật
- [x] **Hạ tầng dưới dạng mã (Infrastructure as Code - IaC):** Tự động cài đặt 100% môi trường bằng Ansible. Hoàn toàn không cần thao tác thủ công.
- [x] **Độ sẵn sàng cao (High Availability - HA):** Cổng cân bằng tải Nginx tự động chia đều lưu lượng truy cập vào hai máy chủ `web01` và `web02`. Nếu một máy chủ gặp sự cố, hệ thống vẫn duy trì hoạt động bình thường qua máy chủ còn lại.
- [x] **Bảo mật (Security):** Tự động cấu hình tường lửa (UFW) chặn toàn bộ truy cập lạ, chỉ mở các cổng mạng thật sự cần thiết. Thiết lập khóa bảo mật SSH với cơ chế phân quyền nghiêm ngặt.
- [x] **Tự động sao lưu dữ liệu (Automated DB Backup):** Kịch bản Ansible (Playbook) tự động kết nối vào máy chủ `db01` để sao lưu dữ liệu PostgreSQL và nén lại thành định dạng `.gz`.
- [x] **Giám sát tài nguyên (Monitoring):** Tích hợp Prometheus và Grafana để theo dõi trực quan các thông số tài nguyên hệ thống (CPU, RAM).
- [x] **Quản lý nhật ký hệ thống tập trung (Centralized Logging):** Ứng dụng bộ công cụ Loki và Promtail để thu thập và giám sát toàn bộ nhật ký (log) bảo mật của 5 máy chủ tại một bảng điều khiển duy nhất.
- [x] **Điều hành qua tin nhắn (ChatOps với Telegram Bot):** Điều khiển toàn bộ hạ tầng thông qua tin nhắn Telegram. Hỗ trợ các thao tác tự động:
  - `/deploy`: Kích hoạt tiến trình CI/CD, tự động tải mã nguồn mới và cập nhật lên máy chủ.
  - `/backup`: Ra lệnh sao lưu và nén cơ sở dữ liệu ngay lập tức.
  - `/status`: Kiểm tra trạng thái mức tiêu thụ CPU, RAM và thời gian hoạt động của cụm máy chủ.
  - `/restart_web`: Khởi động lại các dịch vụ (Docker Container) đang bị treo.
  - `/logs`: Trích xuất nhật ký lỗi mới nhất từ máy chủ.
  - `/db_size`: Kiểm tra dung lượng lưu trữ hiện tại của cơ sở dữ liệu.
  - `/clear_cache`: Xóa bộ nhớ đệm (cache) của hệ thống cân bằng tải Nginx.
  - `/block_ip <địa chỉ ip>`: Ngăn chặn ngay lập tức IP tấn công thông qua tường lửa trên toàn hệ thống.

---
## MINH CHỨNG THỰC TẾ

**1. Khởi tạo hạ tầng máy chủ ảo (Multipass):**
![Multipass list](img/multipass-list.png)

**2. Giao diện SSH tự động và cấu hình tự động bằng Ansible:**
![Ansible Ping](img/ansible-ping.png)

**3. Cấu hình máy chủ Cân bằng tải Nginx & Tường lửa UFW:**
![Nginx Load Balancer Configuration](img/nginx-lb.png)

**4. Dữ liệu sao lưu cơ sở dữ liệu thành công:**
![Database Backup Success](img/db-backup.png)

**5. Giao diện Web & Tính năng Cân bằng tải (Load Balancer):**
- **Ảnh 1:** Giao diện trang web hiển thị máy chủ `web01` và địa chỉ IP `10.45.10.84`.
![Web01 Load Balancer](img/chatbot/anh1/b45ed6db6a79eb27b268.jpg)
- **Ảnh 2:** Giao diện trang web sau khi tải lại (F5), tự động chuyển luồng sang máy chủ `web02` và địa chỉ IP `10.45.10.254`.
![Web02 Load Balancer](img/chatbot/anh2/4c6be6735ad1db8f82c0.jpg)

**6. ChatOps - Điều hành hạ tầng qua tin nhắn Telegram:**
- **Ảnh 1:** Giao diện trên điện thoại khi gõ lệnh `/status`, Bot phản hồi chi tiết mức tiêu thụ CPU, RAM và thời gian hoạt động.
![ChatOps Status](img/chatbot/chatops/anh1/image.png)
- **Ảnh 2:** Giao diện khi gõ lệnh `/block_ip 8.8.8.8`, Bot thông báo tường lửa đã chặn thành công IP tấn công.
![ChatOps Block IP](img/chatbot/chatops/anh2/image.png)
- **Ảnh 3:** Giao diện lệnh `/backup` thành công và hiển thị dung lượng file sao lưu.
![ChatOps Backup](img/chatbot/chatops/anh3/image.png)
- **Video 1 (Thử nghiệm toàn bộ tính năng của Chatbot)**: 
[🎥 Bấm vào đây để xem Video Demo ChatOps](https://youtube.com/shorts/OJx1HamoE5Q)
- **Video 2 (Vận hành ChatOps & CI/CD):** Quay màn hình điện thoại thao tác triển khai mã nguồn (`/deploy`) và khởi động lại web (`/restart_web`) mượt mà.
[🎥 Bấm vào đây để xem Video Demo Vận hành ChatOps](https://youtube.com/shorts/bH1r4yzjVTc)

**7. Giám sát hệ thống (Monitoring & Centralized Logging):**
- **Ảnh 1:** Giao diện bảng điều khiển Grafana giám sát tổng quan trạng thái hệ thống.
![Monitoring 1](img/img04/My%20Documents%20%5B14-08-2026%2019_32%5D/10ecf8d87f7bfe25a76a9.jpg)
- **Ảnh 2:** Theo dõi chi tiết mức tiêu thụ tài nguyên của từng máy chủ.
![Monitoring 2](img/img04/My%20Documents%20%5B14-08-2026%2019_32%5D/71d21fe79844191a405511.jpg)
- **Ảnh 3:** Giao diện quản lý và phân tích nhật ký (log) tập trung với Grafana Loki.
![Monitoring 3](img/img04/My%20Documents%20%5B14-08-2026%2019_32%5D/cdb29d871a249b7ac23510.jpg)


