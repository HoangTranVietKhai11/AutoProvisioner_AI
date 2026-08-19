# 🚀 HƯỚNG DẪN BẬT / KHỞI ĐỘNG LẠI HỆ THỐNG DỰ ÁN (STARTUP & RESTART GUIDE)

Tài liệu này hướng dẫn chi tiết các bước khởi động lại toàn bộ cụm máy chủ 5 Virtual Machines (Multipass) và kiểm tra các dịch vụ sau khi bạn **Tắt máy tính (Shutdown)** hoặc **Khởi động lại máy (Reboot)**.

---

## 📋 TỔNG QUAN HỆ THỐNG MÁY ẢO MULTIPASS

Hệ thống bao gồm 5 máy ảo Multipass chạy trên môi trường Host Linux:
1. `ansible-controller`: Nginx Load Balancer, Telegram ChatOps Bot, CI/CD Ansible Control Node.
2. `web01`: Node Web 1 (Chạy Docker Container `vnetwork_web` & K3s Cluster Node).
3. `web02`: Node Web 2 (Chạy Docker Container `vnetwork_web` & K3s Cluster Node).
4. `db01`: Máy chủ CSDL PostgreSQL & Tự động Backup định kỳ.
5. `monitor01`: Máy chủ Giám sát & Quản lý Log tập trung (Prometheus, Grafana, Loki).

---

## ⚡ BƯỚC 1: KHỞI ĐỘNG CÁC MÁY ẢO MULTIPASS

Sau khi bật máy tính, mở **Terminal** trên máy tính Host và thực hiện các lệnh sau:

### 1.1. Kiểm tra trạng thái máy ảo
```bash
multipass list
```
*(Nếu trạng thái là `Stopped`, thực hiện tiếp bước 1.2)*

### 1.2. Khởi động tất cả các máy ảo cùng lúc
```bash
multipass start --all
```
*(Hoặc bật từng máy: `multipass start ansible-controller web01 web02 db01 monitor01`)*

### 1.3. Xác nhận tất cả máy ảo đã sang trạng thái `Running`
```bash
multipass list
```

---

## 🔍 BƯỚC 2: KIỂM TRA & CẬP NHẬT ĐỊA CHỈ IP (NẾU IP THAY ĐỔI)

Multipass có thể cấp lại IP mới nếu card mạng Wifi/Ethernet của máy tính Host bị thay đổi. 

Chạy lệnh `multipass list` để kiểm tra IP hiện tại của các máy ảo:
- `ansible-controller`: `10.45.10.212`
- `web01`: `10.45.10.84`
- `web02`: `10.45.10.254`
- `db01`: `10.45.10.222`
- `monitor01`: `10.45.10.144`

> ⚠️ **NẾU IP BỊ THAY ĐỔI**:
> Nếu IP của các máy ảo thay đổi so với file inventory, hãy truy cập vào `ansible-controller` để cập nhật:
> ```bash
> multipass shell ansible-controller
> nano ~/inventory
> # Cập nhật IP mới của web01, web02, db01, monitor01
> ansible-playbook -i ~/inventory install-lb.yml
> ```

---

## 🌐 BƯỚC 3: KIỂM TRA CÁC DỊCH VỤ SAU KHI BẬT MÁY

Toàn bộ các dịch vụ cốt lõi đã được cấu hình dưới dạng **Systemd Service** hoặc **Docker Auto-Restart**, sẽ **tự động khởi chạy** ngay khi máy ảo được bật lên (`multipass start`).

### 3.1. Web Cluster & Load Balancer
- Mở trình duyệt web truy cập vào IP máy `ansible-controller`: `http://10.45.10.212`
- Bấm **F5** để thấy ứng dụng nhảy luân phiên giữa `web01` và `web02`.

### 3.2. Giám sát & Centralized Logging (Grafana / Prometheus / Loki)
- **Grafana Dashboard:** `http://10.45.10.144:3000` (hoặc IP hiện tại của `monitor01`)
  - Đăng nhập (Mặc định: `admin` / `admin` hoặc `admin` / `123456`).
  - Chọn **Explore** -> Data Source **Loki** -> Filter `job=syslog` để xem log tập trung 5 máy ảo.
- **Prometheus UI:** `http://10.45.10.144:9090`

### 3.3. Telegram ChatOps Bot
- Mở Telegram trên điện thoại hoặc máy tính.
- Gõ lệnh `/status`, `/logs` hoặc `/backup` để kiểm tra Bot đã phản hồi lại chưa.
- *Nếu Bot chưa phản hồi*, khởi động lại service ChatOps trên `ansible-controller`:
  ```bash
  multipass exec ansible-controller -- sudo systemctl restart chatops
  ```

---

## 🛠️ BƯỚC 4: THAO TÁC XỬ LÝ SỰ CỐ THƯỜNG GẶP (TROUBLESHOOTING)

| Sự cố | Lệnh kiểm tra / Khắc phục |
|---|---|
| **Máy ảo bị treo / Not responding** | `multipass restart <tên_máy_ảo>` |
| **Web bị lỗi không truy cập được** | `multipass exec web01 -- sudo docker restart vnetwork_web`<br>`multipass exec web02 -- sudo docker restart vnetwork_web` |
| **Nginx Load Balancer gặp lỗi** | `multipass exec ansible-controller -- sudo systemctl restart nginx` |
| **Bot Telegram ngừng phản hồi** | `multipass exec ansible-controller -- sudo systemctl status chatops`<br>`multipass exec ansible-controller -- sudo systemctl restart chatops` |
| **Log không đẩy về Grafana** | `multipass exec monitor01 -- sudo systemctl restart loki`<br>`multipass exec web01 -- sudo systemctl restart promtail` |
| **K3s / Kubernetes Cluster lỗi** | `multipass exec web01 -- sudo systemctl restart k3s` |

---

## 🔄 BƯỚC 5: TÁI TRIỂN KHAI HOÀN TOÀN TỰ ĐỘNG (RE-PROVISIONING)

Trong trường hợp muốn dựng lại toàn bộ môi trường bằng Ansible từ máy `ansible-controller`:

```bash
multipass shell ansible-controller
ansible-playbook -i ~/inventory install-lb.yml
ansible-playbook -i ~/inventory deploy-web.yml
ansible-playbook -i ~/inventory install-monitoring.yml
ansible-playbook -i ~/inventory install-loki.yml

# Chạy playbook ChatOps bằng biến môi trường hoặc extra-vars (Bảo mật):
TELEGRAM_BOT_TOKEN="YOUR_BOT_TOKEN" TELEGRAM_CHAT_ID="YOUR_CHAT_ID" ansible-playbook -i ~/inventory setup-chatops.yml
# Hoặc:
# ansible-playbook -i ~/inventory setup-chatops.yml --extra-vars "telegram_bot_token=YOUR_TOKEN telegram_chat_id=YOUR_CHAT_ID"
```
