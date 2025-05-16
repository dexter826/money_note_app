// ignore_for_file: deprecated_member_use

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/constants.dart';
import '../models/transaction.dart';
import '../services/database_service.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = '';
  final DatabaseService _dbService = DatabaseService.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _selectedCategory =
        _tabController.index == 0
            ? kExpenseCategories.keys.first
            : kIncomeCategories.keys.first;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  ///Chọn ngày tháng năm
  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: kAccentColor,
              surface: kSecondaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  ///Thêm mới giao dịch vào cơ sở dữ liệu
  void _submitTransaction() async {
    if (_amountController.text.isEmpty) return;

    final amount = double.parse(_amountController.text);
    final transaction = Transaction(
      amount: amount,
      note: _noteController.text,
      date: _selectedDate,
      category: _selectedCategory,
      isExpense: _tabController.index == 0,
    );

    await _dbService.create(transaction);

    _amountController.clear();
    _noteController.clear();
    setState(() {});

    if (!mounted) return;
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Thành công!',
        message: 'Đã thêm khoản ${_tabController.index == 0 ? "chi" : "thu"}',
        contentType: ContentType.success,
      ),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text(
    //       'Đã thêm khoản ${_tabController.index == 0 ? "chi" : "thu"} thành công',
    //     ),
    //     backgroundColor: kAccentColor,
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        backgroundColor: kSecondaryColor,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: kAccentColor,
          labelColor: kAccentColor,
          tabs: const [Tab(text: 'Tiền chi'), Tab(text: 'Tiền thu')],
          onTap: (index) {
            setState(() {
              _selectedCategory =
                  index == 0
                      ? kExpenseCategories.keys.first
                      : kIncomeCategories.keys.first;
            });
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Ngày
            InkWell(
              onTap: _selectDate,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: kTextLightColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.calendar_today, color: kTextColor),
                    const SizedBox(width: 8),
                    Text(
                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      style: kBodyTextStyle,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Nhập ghi chú
            TextField(
              controller: _noteController,
              style: kBodyTextStyle,
              decoration: const InputDecoration(
                labelText: 'Ghi chú',
                labelStyle: kCaptionTextStyle,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: kTextLightColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: kAccentColor),
                ),
              ),
              cursorColor: kAccentColor,
            ),
            const SizedBox(height: 16),

            // Nhập số tiền
            TextField(
              controller: _amountController,
              style: kBodyTextStyle,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              decoration: const InputDecoration(
                labelText: 'Số tiền',
                labelStyle: kCaptionTextStyle,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: kTextLightColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: kAccentColor),
                ),
                suffixText: 'đ',
              ),
              cursorColor: kAccentColor,
            ),
            const SizedBox(height: 16),

            // Danh sách danh mục
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 1.2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children:
                    (_tabController.index == 0
                            ? kExpenseCategories
                            : kIncomeCategories)
                        .entries
                        .map(
                          (entry) => InkWell(
                            onTap: () {
                              setState(() {
                                _selectedCategory = entry.key;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    _selectedCategory == entry.key
                                        ? kAccentColor.withOpacity(0.2)
                                        : kSecondaryColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color:
                                      _selectedCategory == entry.key
                                          ? kAccentColor
                                          : Colors.transparent,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    entry.value,
                                    color:
                                        _selectedCategory == entry.key
                                            ? kAccentColor
                                            : kTextColor,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    entry.key,
                                    style: kCaptionTextStyle.copyWith(
                                      color:
                                          _selectedCategory == entry.key
                                              ? kAccentColor
                                              : kTextColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),

            // Nút nhập khoản
            ElevatedButton(
              onPressed: _submitTransaction,
              style: ElevatedButton.styleFrom(
                backgroundColor: kAccentColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Nhập khoản ${_tabController.index == 0 ? "chi" : "thu"}',
                style: kBodyTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
