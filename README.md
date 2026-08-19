# AutoProvisioner_AI
Automated Infrastructure Provisioning & High Availability Web Cluster with Ansible, Docker, and Telegram ChatOps.

> 📖 **[Xem Hướng dẫn Bật / Khởi động lại hệ thống sau khi Tắt máy (STARTUP_GUIDE.md)](STARTUP_GUIDE.md)**

## Kiến trúc hệ thống
Hệ thống được chia thành 5 máy chủ riêng biệt đảm nhận các vai trò khác nhau, bao gồm:
- **ansible-controller (Load Balancer & Nginx):** `10.45.10.212` - Làm cổng cân bằng tải.
- **web01:** `10.45.10.84` - Node Web số 1 (Chạy Docker, Node.js/Python).
- **web02:** `10.45.10.254` - Node Web số 2 (Chạy Docker, Node.js/Python).
- **db01:** `10.45.10.150` - Máy chủ Database (PostgreSQL).
- **monitor01:** `10.45.10.48` - Máy chủ Giám sát (Prometheus, Grafana).

## Tính năng nổi bật (Features)
- [x] **Infrastructure as Code (IaC):** Tự động cài đặt 100% môi trường bằng Ansible. Không cần thao tác tay.
- [x] **High Availability (HA):** Nginx Load Balancer tự động chia tải vào `web01` và `web02`. Nếu `web01` sập, hệ thống vẫn chạy bình thường.
- [x] **Security:** Tự động cấu hình UFW (Firewall) chặn toàn bộ truy cập lạ, chỉ mở cổng cần thiết. Cấu hình SSH Key phân quyền nghiêm ngặt.
- [x] **Automated DB Backup:** Playbook Ansible tự động kết nối vào `db01` để sao lưu (dump) CSDL PostgreSQL và nén lại (.gz).
- [x] **Monitoring:** Tích hợp Prometheus và Grafana để thu thập thông số tài nguyên hệ thống (CPU, RAM).
- [x] **Centralized Logging:** Tích hợp ngăn xếp Loki và Promtail để thu thập và giám sát toàn bộ syslog bảo mật của tất cả 5 máy chủ tập trung trên Grafana.
- [x] **ChatOps (Telegram Bot):** Điều khiển toàn bộ hạ tầng qua tin nhắn Telegram. Có thể thực hiện các thao tác:
  - `/deploy`: Kích hoạt CI/CD tự động kéo code mới và cập nhật lên máy chủ.
  - `/backup`: Ra lệnh nén và sao lưu CSDL ngay lập tức.
  - `/status`: Lấy trạng thái CPU/RAM/Uptime của cụm máy chủ.
  - `/restart_web`: Khởi động lại các Docker Container bị treo.
  - `/logs`: Lấy log lỗi mới nhất từ máy chủ.
  - `/db_size`: Kiểm tra dung lượng lưu trữ của Database.
  - `/clear_cache`: Xóa bộ nhớ đệm Nginx.
  - `/block_ip <địa chỉ ip>`: Chặn lập tức IP tấn công trên toàn hệ thống tường lửa.

---
## MINH CHỨNG THỰC TẾ (Proof of Work)

**1. Khởi tạo Infrastructure bằng Multipass:**
![Multipass list](img/multipass-list.png)

**2. Giao diện SSH tự động và Automation qua Ansible:**
![Ansible Ping](img/ansible-ping.png)

**3. Cấu hình Nginx Load Balancer & Tường lửa UFW:**
![Nginx Load Balancer Configuration](img/nginx-lb.png)

**4. Dữ liệu sao lưu (PostgreSQL Backup) thành công:**
![Database Backup Success](img/db-backup.png)

**5. Giao diện Web & Tính năng Cân bằng tải (Load Balancer):**
- **Ảnh 1:** Chụp màn hình trang web hiển thị chữ `web01` và địa chỉ IP `10.45.10.84`.
![Web01 Load Balancer](img/chatbot/anh1/b45ed6db6a79eb27b268.jpg)
- **Ảnh 2:** Chụp màn hình trang web sau khi bấm F5, hiển thị chữ `web02` và IP `10.45.10.254`.
![Web02 Load Balancer](img/chatbot/anh2/4c6be6735ad1db8f82c0.jpg)

**6. ChatOps - Điều khiển hạ tầng qua Telegram:**
- **Ảnh 1:** Chụp màn hình điện thoại khi bạn gõ lệnh `/status` và Bot trả về % CPU, RAM, Uptime.
![ChatOps Status](img/chatbot/chatops/anh1/image.png)
- **Ảnh 2:** Chụp màn hình cảnh bạn gõ `/block_ip 8.8.8.8` và Bot báo chặn Firewall thành công.
![ChatOps Block IP](img/chatbot/chatops/anh2/image.png)
- **Ảnh 3:** Chụp màn hình lệnh `/backup` thành công hiển thị dung lượng file nén.
![ChatOps Backup](img/chatbot/chatops/anh3/image.png)
- **Video 1 (test toàn bộ lệnh của chatbot)**: 
[🎥 Bấm vào đây để xem Video Demo Test ChatOps](https://youtube.com/shorts/OJx1HamoE5Q)
- **Video 2 (ChatOps & CI/CD):** Quay màn hình điện thoại thao tác gõ lệnh `/deploy` và `/restart_web` cực mượt mà.
[🎥 Bấm vào đây để xem Video Demo ChatOps Operations](https://youtube.com/shorts/bH1r4yzjVTc)

---
## ĐỊNH HƯỚNG TƯƠNG LAI (Future Works - System Administration Focus)
Để đáp ứng các tiêu chuẩn khắt khe nhất của một hệ thống Enterprise cấp cao, các hướng nâng cấp tiếp theo sẽ tập trung vào sự ổn định (Stability) và bảo mật (Security):

### 1. Database High Availability & Disaster Recovery
- **Replication (Master-Slave):** Cấu hình thêm máy chủ `db02` chạy song song và sao chép dữ liệu liên tục từ `db01` (dùng Patroni/Repmgr). Nếu `db01` hỏng phần cứng, `db02` sẽ lập tức thay thế (Failover).
- **Disaster Recovery (Off-site Backup):** *Lưu ý:* Cơ chế Replication/RAID không bảo vệ dữ liệu khỏi Hacker (nếu Hacker chạy lệnh xóa dữ liệu trên `db01`, lệnh đó sẽ được đồng bộ ngay lập tức sang `db02`). Do đó, hệ thống sẽ được nâng cấp thêm **Chiến lược Backup 3-2-1**, tự động đẩy file nén backup định kỳ ra một Storage Server (NAS) độc lập, hoàn toàn cách ly khỏi mạng chính để chống Ransomware.

### 2. High Availability (HA) Load Balancing
- Sử dụng **Keepalived** và **HAProxy** triển khai trên 2 máy chủ cân bằng tải độc lập. Tạo ra một địa chỉ IP ảo (Virtual IP). Ngay cả khi máy chủ Load Balancer chính bị sập nguồn, lưu lượng mạng sẽ tự động được chuyển hướng sang máy phụ trong chưa tới 1 giây.


### 4. Security Hardening & VPN
- Cấu hình **Fail2Ban** chặn đứng các cuộc tấn công dò mật khẩu (Brute-force). 
- Đưa toàn bộ các máy ảo vào mạng nội bộ cách ly internet hoàn toàn, thiết lập **WireGuard VPN** làm cổng vào duy nhất. Quản trị viên phải kết nối VPN mới có thể SSH vào hệ thống.
