import 'package:flutter/material.dart';
import 'package:happy_budget_flutter/models/budget/budget_model.dart';
import 'package:happy_budget_flutter/views/budgets/budgets_list/budgets_item.dart';

class BudgetsList extends StatelessWidget {
  const BudgetsList(
      {super.key, required this.onRemoveBudget, required this.budgets});

  final List<BudgetModel> budgets;


  final void Function(BudgetModel) onRemoveBudget;

  @override
  Widget build(BuildContext context){

    return ListView.builder(
        itemCount: budgets.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: ValueKey(budgets[index]),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              onRemoveBudget(budgets[index]);
            },
            background: Container(
              color: Theme.of(context).colorScheme.error.withOpacity(0.7),
              margin: Theme.of(context).cardTheme.margin,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Spacer(),
                    Text(
                      'Delete',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ),
            child: BudgetItem(budgetEntity: budgets[index]),
          );
        });
  }
}