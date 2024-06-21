import 'package:flutter/material.dart';
import 'package:happy_budget_flutter/models/budget/budget_bucket.dart';
import 'package:happy_budget_flutter/models/budget/budget_model.dart';
import 'package:happy_budget_flutter/models/enums/budget_category_enum.dart';

import 'budget_chart_bar.dart';

class BudgetChart extends StatelessWidget {
  const BudgetChart({super.key, required this.budgets});

  final List<BudgetModel> budgets;

  List<BudgetBucket> get buckets {
    return [
      BudgetBucket.forCategory(budgets, BudgetCategory.HOLIDAYS),
      BudgetBucket.forCategory(budgets, BudgetCategory.EMERGENCIES),
      BudgetBucket.forCategory(budgets, BudgetCategory.FOOD),
      BudgetBucket.forCategory(budgets, BudgetCategory.PERSONAL),
      BudgetBucket.forCategory(budgets, BudgetCategory.UTILITY),
      BudgetBucket.forCategory(budgets, BudgetCategory.RENT),
      BudgetBucket.forCategory(budgets, BudgetCategory.PHONE),
      BudgetBucket.forCategory(budgets, BudgetCategory.ENTERTAINMENT),
      BudgetBucket.forCategory(budgets, BudgetCategory.SAVINGS),
      BudgetBucket.forCategory(budgets, BudgetCategory.WISHES),
      BudgetBucket.forCategory(budgets, BudgetCategory.UNUSED),
    ];
  }

  double get maxTotalBudget {
    double maxTotalBudget = 0;

    for (final bucket in buckets) {
      if (bucket.totalBudgets > maxTotalBudget) {
        maxTotalBudget = bucket.totalBudgets;
      }
    }
    return maxTotalBudget;
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
                  BudgetChartBar(
                    fill: bucket.totalBudgets == 0
                        ? 0
                        : bucket.totalBudgets / maxTotalBudget,
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
                        budgetCategoryIcons[bucket.budgetCategory],
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
