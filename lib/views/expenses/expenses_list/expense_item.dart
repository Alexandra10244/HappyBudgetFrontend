import 'package:flutter/material.dart';

import '../../../models/enums/expense_category_enum.dart';
import '../../../models/expenses/expense_model.dart';
import '../edit_expense.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem({super.key, required this.expenseEntity});

  final ExpenseModel expenseEntity;

  void _openEditExpenseOverlay(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => EditExpense(
        expense: expenseEntity,
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
                  expenseEntity.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                TextButton(onPressed: (){
                  _openEditExpenseOverlay(context);
                }, child: const Text('Edit'))
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 5),
              child: Row(
                children: [
                  Text('${expenseEntity.expenseSum.toStringAsFixed(2)} RON'),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(categoryIcons[expenseEntity.expenseCategory]),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(expenseEntity.formattedDate),
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