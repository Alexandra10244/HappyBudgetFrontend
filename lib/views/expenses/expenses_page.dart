import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:happy_budget_flutter/main.dart';
import 'package:happy_budget_flutter/view_models/budget_view_model.dart';
import 'package:happy_budget_flutter/view_models/expense_view_model.dart';
import 'package:happy_budget_flutter/views/auth/login_page.dart';
import 'package:happy_budget_flutter/views/components/bottom_navigation_bar.dart';
import 'package:happy_budget_flutter/views/expenses/expense_filter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/expenses/expense_model.dart';
import 'chart/chart.dart';
import 'expenses_list/expenses_list.dart';
import 'new_expense.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});
  static const String id = 'expenses_screen';
  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(
        onAddExpense: _addExpense,
      ),
    );
  }

  void _openFilterExpenseOverlay() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) => const ExpenseFilter());
  }

  void _addExpense(ExpenseModel expense) async {
    await context.read<ExpenseViewModel>().createExpense(expense, context);
    if (context.read<ExpenseViewModel>().expenseState == ExpenseState.error &&
        context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(context.read<ExpenseViewModel>().errorMessage)));
    }
  }

  void _removeExpense(ExpenseModel expense) {
    context.read<ExpenseViewModel>().deleteExpense(expense, context);
    context.read<BudgetViewModel>().getBudgets();
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo!',
          onPressed: () {
            context.read<ExpenseViewModel>().createExpense(expense, context);
          },
        ),
        content: const Text('Expense Deleted!'),
      ),
    );
  }

  Future<void> backToLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  @override
  void initState() {
    super.initState();
    context.read<ExpenseViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshExpenses();
    });
  }

  Future<void> _refreshExpenses() async {
    await context.read<ExpenseViewModel>().getExpenses();
  }

  @override
  Widget build(BuildContext context) {
    ExpenseViewModel expenseViewModel = context.watch<ExpenseViewModel>();
    Widget mainContent = const Center(
      child: Text('No expenses, add some!'),
    );

    if (expenseViewModel.expenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: expenseViewModel.expenses,
        onRemoveExpense: _removeExpense,
      );
    }
    if(expenseViewModel.expenseState == ExpenseState.loading){
      mainContent = const CupertinoActivityIndicator(radius: 15,);
    }
    if (expenseViewModel.errorMessage == 'Session expired. Login!') {
      mainContent = Center(
        child: Column(
          children: [
            Text(
              expenseViewModel.errorMessage,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            TextButton(
              onPressed: () {
                backToLogin();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => const MyAppWrapper()));
              },
              child: const Text(
                'Back To Login',
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: _openFilterExpenseOverlay,
            icon: const Icon(Icons.filter_alt),
          ),
          IconButton(
            onPressed: () {
              backToLogin().then((_) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (ctx) => const LoginScreen()),
                  (route) => false,
                );
              });
            },
            icon: const Icon(Icons.logout),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Chart(expenses: expenseViewModel.expenses),
          Expanded(
            child: mainContent,
          ),
          const HBottomNavigationBar(
            selectedIndex: 3,
          )
        ],
      ),
    );
  }
}
