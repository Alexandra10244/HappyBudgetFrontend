import 'package:flutter/material.dart';
import 'package:happy_budget_flutter/models/enums/income_category_enum.dart';
import 'package:happy_budget_flutter/models/incomes/income_model.dart';

import '../edit_income.dart';

class IncomeItem extends StatelessWidget {
  const IncomeItem({super.key, required this.incomeEntity});

  final IncomeModel incomeEntity;

  void _openEditExpenseOverlay(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => EditIncome(
        income: incomeEntity,
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
                  incomeEntity.title,
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
                  Text('${incomeEntity.incomeSum.toStringAsFixed(2)} RON'),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(incomeCategoryIcons[incomeEntity.incomeCategory]),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(incomeEntity.formattedDate),
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