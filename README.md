# AutoProvisioner AI

Automated Infrastructure Provisioning & High Availability Web Cluster powered by Ansible, Docker, and Telegram ChatOps.

[![Ansible](https://img.shields.io/badge/Ansible-Automation-red.svg?logo=ansible)](https://www.ansible.com/)
[![Docker](https://img.shields.io/badge/Docker-Containerization-blue.svg?logo=docker)](https://www.docker.com/)
[![Nginx](https://img.shields.io/badge/Nginx-Load%20Balancer-green.svg?logo=nginx)](https://nginx.org/)
[![Telegram](https://img.shields.io/badge/Telegram-ChatOps-blue.svg?logo=telegram)](https://telegram.org/)

> **[Hướng dẫn khởi động lại hệ thống (STARTUP_GUIDE.md)](STARTUP_GUIDE.md)**

---

## Kiến Trúc Hạ Tầng (System Architecture)

Hệ thống triển khai 5 nút dịch vụ độc lập với quy hoạch mạng chi tiết:

| Server Node | IP Address | Vai trò & Dịch vụ |
| :--- | :--- | :--- |
| **`ansible-controller`** | `10.45.10.212` | Nginx Reverse Proxy / Load Balancer & Ansible Master |
| **`web01`** | `10.45.10.84` | Web Application Node 1 (Docker Engine, App Runtime) |
| **`web02`** | `10.45.10.254` | Web Application Node 2 (Docker Engine, App Runtime) |
| **`db01`** | `10.45.10.150` | Database Node (PostgreSQL Engine) |
| **`monitor01`** | `10.45.10.48` | Monitoring & Logging Node (Prometheus, Grafana, Loki) |

---

## Tính Năng Trọng Tâm

- **Infrastructure as Code (IaC):** Tự động hóa 100% việc khởi tạo và cấu hình môi trường bằng Ansible Playbooks.
- **High Availability & Cân Bằng Tải:** Nginx phân phối lưu lượng truy cập giữa `web01` và `web02`, đảm bảo hệ thống duy trì hoạt động ngay cả khi 1 node gặp sự cố.
- **Bảo Mật & Tường Lửa:** Tự động thiết lập UFW Firewall, chỉ mở các cổng giao tiếp bắt buộc và phân quyền nghiêm ngặt qua SSH Keypair.
- **Sao Lưu Dữ Liệu Tự Động:** Ansible Playbook tự động dump và nén sao lưu CSDL PostgreSQL theo định kỳ.
- **Giám Sát & Thu Thập Log Tập Trung:** Ngăn xếp Prometheus + Grafana + Loki + Promtail thu thập chỉ số tài nguyên và syslog thời gian thực.
- **Telegram ChatOps:** Điều khiển và giám sát hạ tầng trực tiếp qua tin nhắn Telegram:
  - `/deploy` - Kích hoạt CI/CD cập nhật mã nguồn mới.
  - `/status` - Kiểm tra thông số CPU, RAM, Uptime toàn cụm server.
  - `/backup` - Ra lệnh sao lưu CSDL tức thì.
  - `/restart_web` - Khởi động lại các container ứng dụng.
  - `/block_ip <IP>` - Chặn địa chỉ IP nghi vấn trên hệ thống tường lửa.
  - `/logs` & `/db_size` - Tra cứu log lỗi và dung lượng CSDL.

---

## Minh Chứng Triển Khai (Proof of Concept)

### 1. Hạ Tầng & Tự Động Hóa Ansible
- **Khởi tạo Nodes (Multipass):**
  ![Multipass list](img/multipass-list.png)

- **Ansible Automation Ping Test:**
  ![Ansible Ping](img/ansible-ping.png)

- **Cấu hình Nginx Load Balancer & UFW Firewall:**
  ![Nginx Load Balancer Configuration](img/nginx-lb.png)

- **Sao Lưu CSDL PostgreSQL:**
  ![Database Backup Success](img/db-backup.png)

---

### 2. Cân Bằng Tải & Giao Diện Web
- **Điều hướng lưu lượng tới `web01` (`10.45.10.84`):**
  ![Web01 Load Balancer](img/chatbot/anh1/b45ed6db6a79eb27b268.jpg)

- **Điều hướng lưu lượng tới `web02` (`10.45.10.254`):**
  ![Web02 Load Balancer](img/chatbot/anh2/4c6be6735ad1db8f82c0.jpg)

---

### 3. Telegram ChatOps
- **Kiểm tra trạng thái hệ thống (`/status`):**
  ![ChatOps Status](img/chatbot/chatops/anh1/image.png)

- **Chặn IP tấn công (`/block_ip`):**
  ![ChatOps Block IP](img/chatbot/chatops/anh2/image.png)

- **Thực thi sao lưu CSDL (`/backup`):**
  ![ChatOps Backup](img/chatbot/chatops/anh3/image.png)

---

### Video Demo Thực Tế
- **[Video Demo Lệnh ChatOps](https://youtube.com/shorts/OJx1HamoE5Q)**
- **[Video Demo ChatOps & CI/CD Deployment](https://youtube.com/shorts/bH1r4yzjVTc)**

---

## Lộ Trình Phát Triển (Future Roadmap)

- **PostgreSQL High Availability:** Triển khai mô hình Replication (Master-Slave) với Patroni/Repmgr để tự động chuyển vùng sự cố (Failover).
- **Chiến Lược Backup 3-2-1:** Tự động đồng bộ bản sao lưu ra Storage Server (NAS) độc lập, cách ly để bảo vệ dữ liệu khỏi Ransomware.
- **Cân Bằng Tải Dự Phòng (Keepalived & HAProxy):** Thiết lập IP ảo (Virtual IP) cho cụm Load Balancer chống đơn điểm sự cố (Single Point of Failure).
- **Bảo Mật Nâng Cao:** Triển khai Fail2Ban chống Brute-force và kết nối quản trị qua WireGuard VPN.
