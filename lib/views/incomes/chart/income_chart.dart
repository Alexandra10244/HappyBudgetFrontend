import 'package:flutter/material.dart';
import 'package:happy_budget_flutter/models/enums/income_category_enum.dart';
import 'package:happy_budget_flutter/models/incomes/income_bucket.dart';
import 'package:happy_budget_flutter/models/incomes/income_model.dart';
import 'package:happy_budget_flutter/views/incomes/chart/income_chart_bar.dart';

class IncomeChart extends StatelessWidget {
  const IncomeChart({super.key, required this.incomes});

  final List<IncomeModel> incomes;

  List<IncomeBucket> get buckets {
    return [
      IncomeBucket.forCategory(incomes, IncomeCategory.SALARY),
      IncomeBucket.forCategory(incomes, IncomeCategory.BONUS),
      IncomeBucket.forCategory(incomes, IncomeCategory.COMMISSION),
      IncomeBucket.forCategory(incomes, IncomeCategory.FREELANCE),
      IncomeBucket.forCategory(incomes, IncomeCategory.INVESTMENTS),
      IncomeBucket.forCategory(incomes, IncomeCategory.RENTAL_INCOME ),
      IncomeBucket.forCategory(incomes, IncomeCategory.SIDE_HUSTLE),
      IncomeBucket.forCategory(incomes, IncomeCategory.GIFTS),
      IncomeBucket.forCategory(incomes, IncomeCategory.OTHER),
    ];
  }

  double get maxTotalIncome {
    double maxTotalIncome = 0;

    for (final bucket in buckets) {
      if (bucket.totalIncomes > maxTotalIncome) {
        maxTotalIncome = bucket.totalIncomes;
      }
    }

    return maxTotalIncome;
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
          // Row(
          //   children: buckets
          //       .map(
          //         (bucket) => Expanded(
          //       child: Padding(
          //         padding: const EdgeInsets.symmetric(horizontal: 4),
          //         child: Text(
          //           bucket.incomeCategory.name,
          //           color: isDarkMode
          //               ? Theme.of(context).colorScheme.secondary
          //               : Theme.of(context)
          //               .colorScheme
          //               .primary
          //               .withOpacity(0.7),
          //         ),
          //       ),
          //     ),
          //   )
          //       .toList(),
          // ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final bucket in buckets) // alternative to map()
                  IncomeChartBar(
                    fill: bucket.totalIncomes == 0
                        ? 0
                        : bucket.totalIncomes / maxTotalIncome,
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
                    incomeCategoryIcons[bucket.incomeCategory],
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
          ),
        ],
      ),
    );
  }
}