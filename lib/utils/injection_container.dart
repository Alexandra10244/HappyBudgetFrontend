import 'package:get_it/get_it.dart';
import 'package:happy_budget_flutter/repositories/budgets_service.dart';
import 'package:happy_budget_flutter/repositories/expenses_service.dart';
import 'package:happy_budget_flutter/repositories/income_service.dart';

import '../repositories/auth_service.dart';

final locator = GetIt.instance;

Future<void> initializeDependencies() async{
  locator.registerSingleton<AuthService>(AuthService());
  locator.registerSingleton<ExpensesService>(ExpensesService());
  locator.registerSingleton<IncomeService>(IncomeService());
  locator.registerSingleton<BudgetService>(BudgetService());
}



