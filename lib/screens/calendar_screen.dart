// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../utils/constants.dart';
import '../models/transaction.dart';
import '../services/database_service.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final DatabaseService _dbService = DatabaseService.instance;
  DateTime _selectedMonth = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Map<DateTime, List<Transaction>> _transactionsByDate = {};
  double _totalIncome = 0;
  double _totalExpense = 0;
  final double _initialBalance = 0;
  double _finalBalance = 0;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadTransactions();
  }

  ///Tải giao dịch từ cơ sở dữ liệu và cập nhật trạng thái
  Future<void> _loadTransactions() async {
    final transactions = await _dbService.getAllTransactions();
    setState(() {
      _transactionsByDate.clear();
      _totalIncome = 0;
      _totalExpense = 0;

      for (var transaction in transactions) {
        final date = DateTime(
          transaction.date.year,
          transaction.date.month,
          transaction.date.day,
        );
        if (!_transactionsByDate.containsKey(date)) {
          _transactionsByDate[date] = [];
        }
        _transactionsByDate[date]!.add(transaction);

        if (transaction.isExpense) {
          _totalExpense += transaction.amount;
        } else {
          _totalIncome += transaction.amount;
        }
      }

      _finalBalance = _initialBalance + _totalIncome - _totalExpense;
    });
  }

  ///Lấy danh sách giao dịch cho một ngày cụ thể
  List<Transaction> _getEventsForDay(DateTime day) {
    return _transactionsByDate[DateTime(day.year, day.month, day.day)] ?? [];
  }

  Widget _buildCalendarHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, color: kTextColor),
          onPressed: () {
            setState(() {
              _selectedMonth = DateTime(
                _selectedMonth.year,
                _selectedMonth.month - 1,
                1,
              );
              _focusedDay = _selectedMonth;
            });
          },
        ),
        Text(
          DateFormat('MM/yyyy').format(_selectedMonth),
          style: kSubHeadingTextStyle,
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right, color: kTextColor),
          onPressed: () {
            setState(() {
              _selectedMonth = DateTime(
                _selectedMonth.year,
                _selectedMonth.month + 1,
                1,
              );
              _focusedDay = _selectedMonth;
            });
          },
        ),
      ],
    );
  }

  Widget _buildCalendar() {
    return TableCalendar<Transaction>(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      calendarFormat: CalendarFormat.month,
      startingDayOfWeek: StartingDayOfWeek.monday,
      headerVisible: false,
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
        _selectedMonth = focusedDay;
        setState(() {});
      },
      eventLoader: _getEventsForDay,
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        defaultTextStyle: kBodyTextStyle,
        weekendTextStyle: kBodyTextStyle.copyWith(color: kTextLightColor),
        selectedDecoration: BoxDecoration(
          color: kAccentColor.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: kSecondaryColor.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
      ),
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          if (events.isNotEmpty) {
            double dayTotal = 0;
            for (var transaction in events) {
              if (transaction.isExpense) {
                dayTotal -= transaction.amount;
              } else {
                dayTotal += transaction.amount;
              }
            }
            return Positioned(
              bottom: 1,
              child: Text(
                NumberFormat.compact().format(dayTotal.abs()),
                style: kCaptionTextStyle.copyWith(
                  fontSize: 10,
                  color: dayTotal < 0 ? kExpenseColor : kIncomeColor,
                ),
              ),
            );
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: kSecondaryColor,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem('Thu nhập', _totalIncome, kIncomeColor),
              _buildSummaryItem('Chi tiêu', _totalExpense, kExpenseColor),
              _buildSummaryItem(
                'Tổng',
                _totalIncome - _totalExpense,
                (_totalIncome - _totalExpense) >= 0
                    ? kIncomeColor
                    : kExpenseColor,
              ),
            ],
          ),
          const Divider(color: kTextLightColor),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem(
                'Số dư đầu kì',
                _initialBalance,
                _initialBalance >= 0 ? kIncomeColor : kExpenseColor,
              ),
              _buildSummaryItem(
                'Số dư cuối kì',
                _finalBalance,
                _finalBalance >= 0 ? kIncomeColor : kExpenseColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, double amount, Color color) {
    return Column(
      children: [
        Text(label, style: kCaptionTextStyle),
        const SizedBox(height: 4),
        Text(
          NumberFormat.decimalPattern().format(amount),
          style: kBodyTextStyle.copyWith(color: color),
        ),
      ],
    );
  }

  Widget _buildTransactionList() {
    final sortedDates =
        _transactionsByDate.keys.toList()..sort((a, b) => b.compareTo(a));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          sortedDates.map((date) {
            final transactions = _transactionsByDate[date]!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    DateFormat('dd/MM/yyyy').format(date),
                    style: kCaptionTextStyle,
                  ),
                ),
                ...transactions.map(
                  (transaction) => Dismissible(
                    key: Key(
                      transaction.id.toString(),
                    ), // Khóa duy nhất cho mỗi giao dịch
                    direction:
                        DismissDirection.endToStart, // Vuốt từ phải sang trái
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 16.0),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) async {
                      // Xóa giao dịch khỏi cơ sở dữ liệu
                      await _dbService.delete(transaction.id!);

                      // Xóa giao dịch khỏi danh sách hiển thị
                      setState(() {
                        _transactionsByDate[date]!.remove(transaction);

                        // Nếu danh sách giao dịch cho ngày này trống, xóa nó khỏi map
                        if (_transactionsByDate[date]!.isEmpty) {
                          _transactionsByDate.remove(date);
                        }

                        // Cập nhật tổng thu nhập và chi tiêu
                        if (transaction.isExpense) {
                          _totalExpense -= transaction.amount;
                        } else {
                          _totalIncome -= transaction.amount;
                        }
                        _finalBalance =
                            _initialBalance + _totalIncome - _totalExpense;
                      });

                      // Hiển thị thông báo SnackBar bằng awesome_snackbar_content
                      final snackBar = SnackBar(
                        elevation: 0,
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        content: AwesomeSnackbarContent(
                          title: 'Đã xóa giao dịch',
                          message:
                              'Đã xóa giao dịch ${transaction.category} thành công',
                          contentType: ContentType.success,
                        ),
                        // action: SnackBarAction(
                        //   label: 'Hoàn tác',
                        //   backgroundColor: Colors.transparent,
                        //   textColor: Colors.white,
                        //   onPressed: () async {
                        //     await _dbService.create(transaction);
                        //     await _loadTransactions();
                        //   },
                        // ),
                      );
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(snackBar);
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   SnackBar(
                      //     content: Text(
                      //       'Đã xóa giao dịch: ${transaction.category}',
                      //       style: kCaptionTextStyle.copyWith(
                      //         color: Colors.white,
                      //       ),
                      //     ),
                      //     backgroundColor: kDeleteColor,
                      //     action: SnackBarAction(
                      //       label: 'Hoàn tác',
                      //       textColor: Colors.white,
                      //       onPressed: () async {
                      //         await _dbService.create(transaction);
                      //         await _loadTransactions();
                      //       },
                      //     ),
                      //   ),
                      // );
                    },
                    child: ListTile(
                      leading: Icon(
                        transaction.isExpense
                            ? kExpenseCategories[transaction.category]
                            : kIncomeCategories[transaction.category],
                        color:
                            transaction.isExpense
                                ? kExpenseColor
                                : kIncomeColor,
                      ),
                      title: Text(transaction.category, style: kBodyTextStyle),
                      subtitle: Text(
                        transaction.note,
                        style: kCaptionTextStyle,
                      ),
                      trailing: Text(
                        '${transaction.isExpense ? "-" : "+"}${NumberFormat.decimalPattern().format(transaction.amount)}',
                        style: kBodyTextStyle.copyWith(
                          color:
                              transaction.isExpense
                                  ? kExpenseColor
                                  : kIncomeColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        backgroundColor: kSecondaryColor,
        title: const Text('Lịch', style: kSubHeadingTextStyle),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: kTextColor),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCalendarHeader(),
          _buildCalendar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [_buildSummary(), _buildTransactionList()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
