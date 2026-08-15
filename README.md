# AutoProvisioner - Nền tảng Tự động hóa Hạ tầng

## Mô tả dự án (Overview)
**AutoProvisioner** là nền tảng tự động hóa toàn bộ quy trình triển khai và cấu hình hạ tầng máy chủ bằng mã lệnh (Infrastructure as Code). Dự án được thiết kế để giải quyết bài toán vận hành nhiều máy chủ Linux cùng lúc một cách nhanh chóng, bảo mật và nhất quán.

Hệ thống có khả năng tự động hóa việc kết nối SSH, thiết lập tường lửa, triển khai ứng dụng (Docker, PostgreSQL) và tích hợp hệ thống giám sát (Prometheus, Grafana) trên cụm máy ảo.

## Công nghệ sử dụng (Tech Stack)
* **OS:** Ubuntu 24.04 LTS
* **Automation:** Ansible
* **Containerization:** Docker
* **Database:** PostgreSQL
* **Monitoring:** Prometheus, Node Exporter, Grafana
* **Security:** UFW (Uncomplicated Firewall), SSH Keys
* **Automation & ChatOps:** Telegram Bot API

## Kiến trúc hệ thống (Architecture)
Hệ thống được chia thành 5 máy chủ riêng biệt đảm nhận các vai trò khác nhau:

1. **`ansible-controller`**: Máy trung tâm điều khiển cấu hình toàn hệ thống, đồng thời đóng vai trò là **Nginx Load Balancer** cân bằng tải giao thông web.
2. **`web01`, `web02`**: Cụm máy chủ Web chạy Docker, sẵn sàng phục vụ và đảm bảo tính **High Availability (HA)**.
3. **`db01`**: Máy chủ CSDL chạy PostgreSQL.
4. **`monitor01`**: Máy chủ Giám sát chạy Prometheus và Grafana.

## Các tính năng đã triển khai (Features)
- **Bảo mật mạng (Security):** Tự động cấu hình kết nối SSH Key và thiết lập tường lửa UFW (chỉ mở cổng 22, 80, 443, 3000, 9090, 9100).
- **Quản lý người dùng (User Management):** Tự động tạo và cấp quyền `sudo` cho tài khoản quản trị trên toàn bộ Cluster.
- **Web Server Automation:** Tự động cài đặt Docker và Docker Compose cho cụm Web.
- **Database Automation:** Tự động cài đặt, khởi động PostgreSQL và đặt lịch Cronjob.
- **High Availability & Load Balancing:** Tự động cấu hình Nginx Load Balancer phân tải Round-robin xuống 2 máy chủ Web, đảm bảo hệ thống không bao giờ bị gián đoạn (Zero downtime) khi 1 máy bị sập.
- **Monitoring & Alerting:** Thu thập chỉ số (CPU, RAM) bằng Node Exporter, trực quan hóa qua Grafana và tự động gửi cảnh báo qua Telegram khi CPU quá tải.
- **ChatOps (Remote Control Center):** Tích hợp **Bot Telegram** đa năng cho phép quản trị viên ra lệnh từ xa bằng điện thoại:
  - `/status`, `/db_size`, `/logs`: Giám sát và trích xuất nhật ký lỗi từ xa.
  - `/block_ip`: Ngăn chặn tấn công DDoS bằng cách khóa IP toàn hệ thống (UFW).
  - `/deploy`, `/clear_cache`, `/restart_web`: Triển khai mã nguồn và xử lý sự cố.
  - `/backup`: Tự động đóng gói và sao lưu Database PostgreSQL.

---

## Hình ảnh thực tế dự án (Proof of Work)

**1. Khởi tạo cụm 4 máy chủ (VM Provisioning):**
![Architecture 1](img/img01/5243047a9fd91e8747c8.jpg)
![Architecture 2](img/img01/70196c1cf7bf76e12fae1.jpg)
![Architecture 3](img/img01/b90c9a0901aa80f4d9bb2.jpg)

**2. Chạy kịch bản tự động hóa bằng Ansible:**
![Automation 1](img/img02/My%20Documents%20[14-08-2026%2019_31]/203ac1ca4569c4379d788.jpg)
![Automation 2](img/img02/My%20Documents%20[14-08-2026%2019_31]/279c3ff1bb523a0c63434.jpg)
![Automation 3](img/img02/My%20Documents%20[14-08-2026%2019_31]/a6b247eec34d42131b5c3.jpg)
![Automation 4](img/img02/My%20Documents%20[14-08-2026%2019_31]/ca137d4ff9ec78b221fd6.jpg)
![Automation 5](img/img02/My%20Documents%20[14-08-2026%2019_31]/f823ed7e69dde883b1cc7.jpg)
![Automation 6](img/img02/My%20Documents%20[14-08-2026%2019_31]/fe0bc4ca4069c13798785.jpg)

**3. Tự động cấu hình Database PostgreSQL:**
![Database](img/img03/722d1d889b2b1a75433a.jpg)

**4. Hệ thống giám sát tài nguyên Grafana (Real-time):**
![Monitoring 1](img/img04/My%20Documents%20[14-08-2026%2019_32]/10ecf8d87f7bfe25a76a9.jpg)
![Monitoring 2](img/img04/My%20Documents%20[14-08-2026%2019_32]/71d21fe79844191a405511.jpg)
![Monitoring 3](img/img04/My%20Documents%20[14-08-2026%2019_32]/cdb29d871a249b7ac23510.jpg)

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
[🎥 Bấm vào đây để xem Video Demo Test ChatOps](img/chatbot/chatops/video01/89503423752091132741.mp4)
- **Video 2 (ChatOps & CI/CD):** Quay màn hình điện thoại thao tác gõ lệnh `/deploy` và `/restart_web` cực mượt mà.
[🎥 Bấm vào đây để xem Video Demo ChatOps Operations](img/chatbot/chatops/video2/5855831333754878758.mp4)
