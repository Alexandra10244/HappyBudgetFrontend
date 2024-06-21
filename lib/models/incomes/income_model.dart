import 'package:intl/intl.dart';

import '../enums/income_category_enum.dart';

final formatter = DateFormat.yMMMd();

class IncomeModel{
  final int? id;
  final String title;
  final double incomeSum;
  final DateTime incomeDate;
  final IncomeCategory incomeCategory;

  IncomeModel({
    this.id,
    required this.title,
    required this.incomeSum,
    required this.incomeDate,
    required this.incomeCategory
  });

  String get formattedDate{
    return formatter.format(incomeDate);
  }
}