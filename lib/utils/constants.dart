import 'package:flutter/material.dart';

// Colors
const Color kPrimaryColor = Color(0xFF1F1F1F);
const Color kSecondaryColor = Color(0xFF2C2C2C);
const Color kAccentColor = Color(0xFF4CAF50);
const Color kTextColor = Color(0xFFFFFFFF);
const Color kTextLightColor = Color(0xFFB3B3B3);
const Color kErrorColor = Color(0xFFE57373);
const Color kIncomeColor = Color(0xFF81C784);
const Color kExpenseColor = Color(0xFFE57373);
const Color kDeleteColor = Color.fromARGB(255, 232, 66, 66);

// Text Styles
const TextStyle kHeadingTextStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: kTextColor,
);

const TextStyle kSubHeadingTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w600,
  color: kTextColor,
);

const TextStyle kBodyTextStyle = TextStyle(fontSize: 16, color: kTextColor);

const TextStyle kCaptionTextStyle = TextStyle(
  fontSize: 14,
  color: kTextLightColor,
);

// Categories
const Map<String, IconData> kExpenseCategories = {
  'Ăn uống': Icons.restaurant,
  'Chi tiêu hàng ngày': Icons.shopping_cart,
  'Quần áo': Icons.checkroom,
  'Mỹ phẩm': Icons.face,
  'Phí giao lưu': Icons.local_shipping,
  'Y tế': Icons.medical_services,
  'Giáo dục': Icons.school,
  'Đi lại': Icons.directions_car,
  'Phí liên lạc': Icons.phone,
  'Tiền nhà': Icons.home,
  'Điện chiếu sáng': Icons.lightbulb,
  'Đồ dùng': Icons.computer,
};

const Map<String, IconData> kIncomeCategories = {
  'Tiền lương': Icons.account_balance_wallet,
  'Tiền thưởng': Icons.card_giftcard,
  'Thu nhập phụ': Icons.monetization_on,
  'Đầu tư': Icons.trending_up,
  'Thu nhập tạm thời': Icons.access_time,
};
