import 'package:intl/intl.dart';
import '../enums/expense_category_enum.dart';

final formatter = DateFormat.yMMMd();

class ExpenseModel{
  final int? id;
  final String title;
  final ExpenseCategory expenseCategory;
  final double expenseSum;
  final DateTime? expenseDate;



  ExpenseModel({
    this.id,
    required this.title,
    required this.expenseCategory,
    required this.expenseSum,
     this.expenseDate
  });

  String get formattedDate{
    return formatter.format(expenseDate!);
  }
}