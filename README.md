# Money Note App

## Ứng dụng ghi chép chi tiêu cá nhân

<p align="center">
  <img src="assets/animations/money_animation.json" alt="Money Note App Logo" height="100">
</p>

## Giới thiệu

Money Note App là một ứng dụng di động được phát triển bằng Flutter, giúp người dùng theo dõi, quản lý và phân tích thu nhập và chi tiêu cá nhân một cách hiệu quả. Ứng dụng sử dụng cơ sở dữ liệu SQLite để lưu trữ dữ liệu giao dịch và cung cấp giao diện người dùng thân thiện, trực quan.

## Tính năng chính

- **Ghi chép thu chi**: Dễ dàng thêm, sửa, xóa các giao dịch thu nhập và chi tiêu
- **Phân loại giao dịch**: Phân chia giao dịch theo nhiều danh mục khác nhau
- **Lịch giao dịch**: Xem lịch sử giao dịch theo ngày tháng
- **Thống kê**: Phân tích xu hướng chi tiêu và thu nhập qua thời gian
- **Giao diện thân thiện**: Giao diện đẹp mắt, dễ sử dụng với chủ đề tối (dark theme)

## Cấu trúc dự án

```
lib/
  ├── main.dart                 # Điểm khởi đầu của ứng dụng
  ├── models/                   # Các lớp mô hình dữ liệu
  │   └── transaction.dart      # Mô hình cho giao dịch
  ├── screens/                  # Các màn hình của ứng dụng
  │   ├── splash_screen.dart    # Màn hình khởi động
  │   ├── home_screen.dart      # Màn hình chính
  │   ├── input_screen.dart     # Màn hình nhập giao dịch
  │   └── calendar_screen.dart  # Màn hình lịch
  ├── services/                 # Các dịch vụ
  │   └── database_service.dart # Dịch vụ quản lý cơ sở dữ liệu
  └── utils/                    # Tiện ích và hằng số
      └── constants.dart        # Các hằng số được sử dụng trong ứng dụng
```

## Công nghệ sử dụng

- **Flutter**: Framework UI đa nền tảng
- **Dart**: Ngôn ngữ lập trình
- **SQLite (sqflite)**: Cơ sở dữ liệu quan hệ nhẹ
- **table_calendar**: Hiển thị lịch và các sự kiện
- **Lottie**: Hiển thị các animation đẹp mắt
- **intl**: Định dạng ngày tháng và tiền tệ

## Cài đặt và chạy ứng dụng

1. Đảm bảo bạn đã cài đặt Flutter SDK
2. Clone repository này
3. Chạy lệnh `flutter pub get` để cài đặt các dependencies
4. Kết nối thiết bị hoặc khởi động máy ảo
5. Chạy lệnh `flutter run` để khởi động ứng dụng

## Yêu cầu hệ thống

- Flutter SDK: ^3.7.2
- Dart SDK: ^3.7.2
- Android/iOS thiết bị hoặc máy ảo

## Tác giả

**Trần Công Minh**  
Sinh viên khoa Công nghệ Thông tin  
Trường Đại học Công Thương TP.HCM (HUIT)

## Giấy phép

Dự án này được phân phối dưới giấy phép MIT. Xem file LICENSE để biết thêm chi tiết.

## Tài liệu tham khảo

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Documentation](https://dart.dev/guides)
- [SQLite Documentation](https://www.sqlite.org/docs.html)
