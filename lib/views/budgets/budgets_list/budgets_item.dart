import 'package:flutter/material.dart';
import 'package:happy_budget_flutter/models/budget/budget_model.dart';
import 'package:happy_budget_flutter/models/enums/budget_category_enum.dart';

import '../edit_budget.dart';

class BudgetItem extends StatelessWidget {
  const BudgetItem({super.key, required this.budgetEntity});

  final BudgetModel budgetEntity;

  void _openEditExpenseOverlay(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => EditBudget(
        budget: budgetEntity,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(top: 8, left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  budgetEntity.budgetCategory.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                budgetEntity.budgetCategory.name == 'UNUSED'
                    ? const Text('')
                    : TextButton(
                        onPressed: () {
                          _openEditExpenseOverlay(context);
                        },
                        child: const Text('Edit'))
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 5),
              child: Row(
                children: [
                  Text('${budgetEntity.budgetSum.toStringAsFixed(2)} RON'),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(budgetCategoryIcons[budgetEntity.budgetCategory]),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(budgetEntity.formattedDate),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
