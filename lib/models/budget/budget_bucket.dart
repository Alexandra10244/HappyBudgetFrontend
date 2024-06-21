import 'package:happy_budget_flutter/models/budget/budget_model.dart';
import 'package:happy_budget_flutter/models/enums/budget_category_enum.dart';

class BudgetBucket {
  final BudgetCategory budgetCategory;
  final List<BudgetModel> budgets;

  const BudgetBucket({required this.budgetCategory, required this.budgets});
  BudgetBucket.forCategory(
      List<BudgetModel> allBudgets, this.budgetCategory)
      : budgets = allBudgets
      .where((budget) => budget.budgetCategory == budgetCategory)
      .toList();

  double get totalBudgets {
    double sum = 0;
    for (final BudgetModel budgetEntity in budgets) {
      sum += budgetEntity.budgetSum;
    }
    return sum;
  }
}