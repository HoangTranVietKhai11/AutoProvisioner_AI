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

## Kiến trúc hệ thống (Architecture)
Hệ thống được chia thành 4 máy chủ riêng biệt đảm nhận các vai trò khác nhau:

1. **`ansible-controller`**: Máy trung tâm điều khiển cấu hình toàn hệ thống.
2. **`web01`**: Máy chủ Web chạy Docker và Nginx.
3. **`db01`**: Máy chủ CSDL chạy PostgreSQL.
4. **`monitor01`**: Máy chủ Giám sát chạy Prometheus và Grafana.

## Các tính năng đã triển khai (Features)
- **Bảo mật mạng (Security):** Tự động cấu hình kết nối SSH Key và thiết lập tường lửa UFW (chỉ mở cổng 22, 80, 443, 3000, 9090, 9100).
- **Quản lý người dùng (User Management):** Tự động tạo và cấp quyền `sudo` cho tài khoản quản trị trên toàn bộ Cluster.
- **Web Server Automation:** Tự động cài đặt Docker và Docker Compose.
- **Database Automation:** Tự động cài đặt và khởi động PostgreSQL.
- **Monitoring Integration:** Thu thập cấu hình phần cứng (CPU, RAM) bằng Node Exporter, gộp dữ liệu bằng Prometheus và hiển thị trực quan qua Dashboard của Grafana.

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

---

## Hướng dẫn sử dụng (How to use)
Toàn bộ kịch bản tự động hóa nằm trong thư mục `ansible_playbooks`. Để chạy kịch bản trên máy `ansible-controller`, sử dụng cú pháp:

```bash
ansible-playbook -i inventory <ten-file-kich-ban>.yml
```
