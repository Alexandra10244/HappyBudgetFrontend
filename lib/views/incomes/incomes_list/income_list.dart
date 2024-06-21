import 'package:flutter/material.dart';
import 'package:happy_budget_flutter/models/incomes/income_model.dart';
import 'package:happy_budget_flutter/views/incomes/incomes_list/income_item.dart';

class IncomesList extends StatelessWidget {
  const IncomesList(
      {super.key, required this.onRemoveIncome, required this.incomes});

  final List<IncomeModel> incomes;


  final void Function(IncomeModel) onRemoveIncome;

  @override
  Widget build(BuildContext context){
    return ListView.builder(
        itemCount: incomes.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: ValueKey(incomes[index]),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              onRemoveIncome(incomes[index]);
            },
            background: Container(
              color: Theme.of(context).colorScheme.error.withOpacity(0.7),
              margin: Theme.of(context).cardTheme.margin,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    // Text(
                    //   'Delete',
                    //   style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    //       color: Colors.white, fontWeight: FontWeight.w400),
                    // ),
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
            child: IncomeItem(incomeEntity: incomes[index]),
          );
        });
  }
}