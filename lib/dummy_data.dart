import 'models/enums/expense_category_enum.dart';
import 'models/expenses/expense_model.dart';

final List<ExpenseModel> registeredExpenses = [
  ExpenseModel(
      title: 'Flutter Course',
      expenseCategory: ExpenseCategory.PERSONAL,
      expenseSum: 200,
      expenseDate: DateTime.now()
  ),
  ExpenseModel(
      title: 'Java Course',
      expenseCategory: ExpenseCategory.ENTERTAINMENT,
      expenseSum: 250,
      expenseDate: DateTime.now()
  ),
];