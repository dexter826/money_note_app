import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import '../models/transaction.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static sqflite.Database? _database;

  DatabaseService._init();

  /// Hàm trả về một đối tượng `sqflite.Database` đã được khởi tạo.
  Future<sqflite.Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('transactions.db');
    return _database!;
  }

  /// Hàm khởi tạo cơ sở dữ liệu SQLite với tên file `transactions.db`.
  Future<sqflite.Database> _initDB(String filePath) async {
    final dbPath = await sqflite.getDatabasesPath();
    final path = join(dbPath, filePath);

    return await sqflite.openDatabase(path, version: 1, onCreate: _createDB);
  }

  /// Hàm tạo bảng `transactions` trong cơ sở dữ liệu.
  Future<void> _createDB(sqflite.Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL NOT NULL,
        note TEXT NOT NULL,
        date TEXT NOT NULL,
        category TEXT NOT NULL,
        isExpense INTEGER NOT NULL
      )
    ''');
  }

  /// Hàm tạo một giao dịch mới trong cơ sở dữ liệu.
  Future<Transaction> create(Transaction transaction) async {
    final db = await instance.database;
    final id = await db.insert('transactions', transaction.toMap());
    return transaction.copyWith(id: id);
  }

  /// Hàm lấy tất cả các giao dịch từ cơ sở dữ liệu.
  Future<List<Transaction>> getAllTransactions() async {
    final db = await instance.database;
    final result = await db.query('transactions', orderBy: 'date DESC');
    return result.map((json) => Transaction.fromMap(json)).toList();
  }

  /// Hàm lấy các giao dịch theo ngày
  Future<List<Transaction>> getTransactionsByDate(DateTime date) async {
    final db = await instance.database;
    final result = await db.query(
      'transactions',
      where: 'date LIKE ?',
      whereArgs: ['${date.toString().split(' ')[0]}%'],
    );
    return result.map((json) => Transaction.fromMap(json)).toList();
  }

  /// Hàm xóa một giao dịch theo ID
  Future<void> delete(int id) async {
    final db = await instance.database;
    await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  /// Hàm cập nhật một giao dịch
  Future<void> update(Transaction transaction) async {
    final db = await instance.database;
    await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  ///Hàm đóng cơ sở dữ liệu
  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
