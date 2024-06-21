import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:happy_budget_flutter/main.dart';
import 'package:happy_budget_flutter/view_models/budget_view_model.dart';
import 'package:happy_budget_flutter/view_models/income_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/incomes/income_model.dart';
import '../auth/login_page.dart';
import '../components/bottom_navigation_bar.dart';
import 'chart/income_chart.dart';
import 'income_filter.dart';
import 'incomes_list/income_list.dart';
import 'new_income.dart';

class IncomesPage extends StatefulWidget {
  const IncomesPage({super.key});
  static const String id = 'incomes_screen';
  @override
  State<IncomesPage> createState() => _IncomesPageState();
}

class _IncomesPageState extends State<IncomesPage> {
  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewIncome(
        onAddIncome: _addIncome,
      ),
    );
  }

  void _openFilterExpenseOverlay() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) => const IncomeFilter());
  }

  void _addIncome(IncomeModel income) async{
    await context.read<IncomeViewModel>().createIncome(income, context);
    if (context.read<IncomeViewModel>().incomeState == IncomeState.error &&
        context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(context.read<IncomeViewModel>().errorMessage)));
    }
  }

  void _removeIncome(IncomeModel income) async {
    await context.read<IncomeViewModel>().deleteIncome(income, context);
    if(context.read<IncomeViewModel>().incomeState == IncomeState.error){
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 5),
          content:  Text(context.read<IncomeViewModel>().errorMessage),
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
            context.read<IncomeViewModel>().createIncome(income, context);
          },
        ),
        content: const Text('Income Deleted!'),
      ),
    );
  }

  Future<void> resetSharedPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  @override
  void initState() {
    super.initState();
    context.read<IncomeViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshIncomes();
    });
  }

  Future<void> _refreshIncomes() async {
    await context.read<IncomeViewModel>().getIncomes();
  }

  @override
  Widget build(BuildContext context) {
    IncomeViewModel incomeViewModel = context.watch<IncomeViewModel>();
    Widget mainContent = const Center(
      child: Text('No incomes, add some!'),
    );

    if (incomeViewModel.incomes.isNotEmpty) {
      mainContent = IncomesList(
        incomes: incomeViewModel.incomes,
        onRemoveIncome: _removeIncome,
      );
    }
    if(incomeViewModel.incomeState == IncomeState.loading){
      mainContent = const CupertinoActivityIndicator(radius: 15,);
    }
    if (incomeViewModel.errorMessage == 'Session expired. Login!') {
      mainContent = Center(
        child: Column(
          children: [
            Text(
              incomeViewModel.errorMessage,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            TextButton(
              onPressed: () {
                resetSharedPrefs();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => const MyAppWrapper()));
              },
              child:  const Text(
                'Back To Login',

              ),
            ),
          ],
        ),
      );
    }


    return Scaffold(
      appBar: AppBar(
        title: const Text('Incomes'),
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
              resetSharedPrefs().then((_) {
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
          IncomeChart(incomes: incomeViewModel.incomes),
          Expanded(
            child: mainContent,
          ),
          const HBottomNavigationBar(selectedIndex: 1,)
        ],
      ),

    );
  }
}

