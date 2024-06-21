import 'package:flutter/material.dart';
import 'package:happy_budget_flutter/views/budgets/budgets_page.dart';
import 'package:happy_budget_flutter/views/expenses/expenses_page.dart';
import 'package:happy_budget_flutter/views/incomes/incomes_page.dart';

class HBottomNavigationBar extends StatefulWidget {
  const HBottomNavigationBar({super.key, required this.selectedIndex});
  final int selectedIndex;
  @override
  State<HBottomNavigationBar> createState() => _HBottomNavigationBarState();
}

class _HBottomNavigationBarState extends State<HBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (ctx) => const IncomesPage()));
                  },
                  icon: Icon(Icons.money_outlined,
                      color: widget.selectedIndex == 1
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).colorScheme.secondary),
                ),
                Text(
                  'Incomes',
                  style: TextStyle(
                      color: widget.selectedIndex == 1
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).colorScheme.secondary),
                ),
              ],
            ),
            Column(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (ctx) => const BudgetsPage()));
                    },
                    icon: Icon(Icons.savings,
                        color: widget.selectedIndex == 2
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).colorScheme.secondary)),
                Text(
                  'Budgets',
                  style: TextStyle(
                      color: widget.selectedIndex == 2
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).colorScheme.secondary),
                ),
              ],
            ),
            Column(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (ctx) => const ExpensesPage()));
                    },
                    icon: Icon(Icons.local_grocery_store,
                        color: widget.selectedIndex == 3
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).colorScheme.secondary)),
                Text(
                  'Expenses',
                  style: TextStyle(
                      color: widget.selectedIndex == 3
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).colorScheme.secondary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
