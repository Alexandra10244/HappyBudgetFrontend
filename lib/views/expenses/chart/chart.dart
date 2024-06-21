import 'package:flutter/material.dart';

import '../../../models/enums/expense_category_enum.dart';
import '../../../models/expenses/expense_bucket.dart';
import '../../../models/expenses/expense_model.dart';
import 'chart_bar.dart';

class Chart extends StatelessWidget {
  const Chart({super.key, required this.expenses});

  final List<ExpenseModel> expenses;

  List<ExpenseBucket> get buckets {
    return [
      ExpenseBucket.forCategory(expenses, ExpenseCategory.HOLIDAYS),
      ExpenseBucket.forCategory(expenses, ExpenseCategory.EMERGENCIES),
      ExpenseBucket.forCategory(expenses, ExpenseCategory.FOOD),
      ExpenseBucket.forCategory(expenses, ExpenseCategory.PERSONAL),
      ExpenseBucket.forCategory(expenses, ExpenseCategory.UTILITY),
      ExpenseBucket.forCategory(expenses, ExpenseCategory.RENT),
      ExpenseBucket.forCategory(expenses, ExpenseCategory.PHONE),
      ExpenseBucket.forCategory(expenses, ExpenseCategory.ENTERTAINMENT),
      ExpenseBucket.forCategory(expenses, ExpenseCategory.SAVINGS),
      ExpenseBucket.forCategory(expenses, ExpenseCategory.WISHES),
    ];
  }

  double get maxTotalExpense {
    double maxTotalExpense = 0;

    for (final bucket in buckets) {
      if (bucket.totalExpenses > maxTotalExpense) {
        maxTotalExpense = bucket.totalExpenses;
      }
    }

    return maxTotalExpense;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.3),
            Theme.of(context).colorScheme.primary.withOpacity(0.0)
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final bucket in buckets) // alternative to map()
                  ChartBar(
                    fill: bucket.totalExpenses == 0
                        ? 0
                        : bucket.totalExpenses / maxTotalExpense,
                  )
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: buckets
                .map(
                  (bucket) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    categoryIcons[bucket.expenseCategory],
                    color: isDarkMode
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(0.7),
                  ),
                ),
              ),
            )
                .toList(),
          )
        ],
      ),
    );
  }
}