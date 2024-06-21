import 'package:happy_budget_flutter/models/enums/income_category_enum.dart';
import 'package:happy_budget_flutter/models/incomes/income_model.dart';

class IncomeBucket {
  final IncomeCategory incomeCategory;
  final List<IncomeModel> incomes;

  const IncomeBucket({required this.incomeCategory, required this.incomes});
  IncomeBucket.forCategory(
      List<IncomeModel> allIncomes, this.incomeCategory)
      : incomes = allIncomes
      .where((income) => income.incomeCategory == incomeCategory)
      .toList();

  double get totalIncomes {
    double sum = 0;
    for (final IncomeModel incomeEntity in incomes) {
      sum += incomeEntity.incomeSum;
    }
    return sum;
  }
}