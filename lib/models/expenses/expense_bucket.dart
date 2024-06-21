import '../enums/expense_category_enum.dart';
import 'expense_model.dart';

class ExpenseBucket {
  final ExpenseCategory expenseCategory;
  final List<ExpenseModel> expenses;

  const ExpenseBucket({required this.expenseCategory, required this.expenses});
  ExpenseBucket.forCategory(
      List<ExpenseModel> allExpenses, this.expenseCategory)
      : expenses = allExpenses
      .where((expense) => expense.expenseCategory == expenseCategory)
      .toList();

  double get totalExpenses {
    double sum = 0;
    for (final ExpenseModel expenseEntity in expenses) {
      sum += expenseEntity.expenseSum;
    }
    return sum;
  }
}