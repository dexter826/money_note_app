///Khai báo đối tượng Transaction được sử dụng để lưu trữ thông tin về giao dịch
class Transaction {
  final int? id;
  final double amount;
  final String note;
  final DateTime date;
  final String category;
  final bool isExpense; // true dành cho chi tiêu, false dành cho thu nhập

  ///Constructor của Transaction
  Transaction({
    this.id,
    required this.amount,
    required this.note,
    required this.date,
    required this.category,
    required this.isExpense,
  });

  ///Hàm sao chép đối tượng Transaction với các thuộc tính mới
  Transaction copyWith({
    int? id,
    double? amount,
    String? note,
    DateTime? date,
    String? category,
    bool? isExpense,
  }) {
    return Transaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      date: date ?? this.date,
      category: category ?? this.category,
      isExpense: isExpense ?? this.isExpense,
    );
  }

  ///Hàm chuyển đổi đối tượng Transaction thành Map để lưu trữ vào cơ sở dữ liệu
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'note': note,
      'date': date.toIso8601String(),
      'category': category,
      'isExpense': isExpense ? 1 : 0,
    };
  }

  ///Hàm khôi phục đối tượng Transaction từ Map
  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      amount: map['amount'],
      note: map['note'],
      date: DateTime.parse(map['date']),
      category: map['category'],
      isExpense: map['isExpense'] == 1,
    );
  }
}
