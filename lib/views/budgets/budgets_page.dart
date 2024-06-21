import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:happy_budget_flutter/main.dart';
import 'package:happy_budget_flutter/models/budget/budget_model.dart';
import 'package:happy_budget_flutter/view_models/budget_view_model.dart';
import 'package:happy_budget_flutter/views/budgets/budgets_list/budgets_list.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/login_page.dart';
import '../components/bottom_navigation_bar.dart';
import 'budget_filter.dart';
import 'chart/budget_chart.dart';
import 'new_budget.dart';

class BudgetsPage extends StatefulWidget {
  const BudgetsPage({super.key});
  static const String id = 'budgets_screen';
  @override
  State<BudgetsPage> createState() => _BudgetsPageState();
}

class _BudgetsPageState extends State<BudgetsPage> {
  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewBudget(
        onAddBudget: _addBudget,
      ),
    );
  }

  void _openFilterBudgetOverlay() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) => const BudgetFilter());
  }

  void _addBudget(BudgetModel budget) async {
    await context.read<BudgetViewModel>().createBudget(budget);
      if (context.mounted && context.read<BudgetViewModel>().budgetState == BudgetState.error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(context.read<BudgetViewModel>().errorMessage)));
      }
  }

  void _removeBudget(BudgetModel budget) async {
    await context.read<BudgetViewModel>().deleteBudget(budget);
    if(context.read<BudgetViewModel>().budgetState == BudgetState.error){
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 5),
          content:  Text(context.read<BudgetViewModel>().errorMessage),
        ),
      );
      return;
    }
    context.read<BudgetViewModel>().getBudgets();
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Undo!',
          onPressed: () {
            context.read<BudgetViewModel>().createBudget(budget);
          },
        ),
        content: const Text('Budget Deleted!'),
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
    context.read<BudgetViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshBudgets();
    });
  }

  Future<void> _refreshBudgets() async {
    await context.read<BudgetViewModel>().getBudgets();
  }

  @override
  Widget build(BuildContext context) {
    BudgetViewModel budgetViewModel = context.watch<BudgetViewModel>();
    Widget mainContent = const Center(
      child: Text('No Budgets, add some!'),
    );

    if (budgetViewModel.budgets.isNotEmpty) {
      mainContent = BudgetsList(
        budgets: budgetViewModel.budgets,
        onRemoveBudget: _removeBudget,
      );
    }
    if(budgetViewModel.budgetState == BudgetState.loading){
      mainContent = const CupertinoActivityIndicator(radius: 15,);
    }
    if (budgetViewModel.errorMessage == 'Session expired. Login!') {
      mainContent = Center(
        child: Column(
          children: [
            Text(
              budgetViewModel.errorMessage,
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
        title: const Text('Budgets'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: _openFilterBudgetOverlay,
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
          BudgetChart(budgets: budgetViewModel.budgets),
          Expanded(
            child: mainContent,
          ),
          const HBottomNavigationBar(
            selectedIndex: 2,
          )
        ],
      ),
    );
  }
}
