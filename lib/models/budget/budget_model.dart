import 'package:happy_budget_flutter/models/enums/budget_category_enum.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMMMd();
class BudgetModel {
  final int? id;
  final double budgetSum;
  final DateTime budgetDate;
  final BudgetCategory budgetCategory;

  BudgetModel(
      {this.id,
      required this.budgetSum,
      required this.budgetDate,
      required this.budgetCategory});

  String get formattedDate{
    return formatter.format(budgetDate);
  }
}
