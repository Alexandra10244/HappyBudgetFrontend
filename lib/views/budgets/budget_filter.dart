import 'package:flutter/material.dart';
import 'package:happy_budget_flutter/models/enums/filter_budget_category_enum.dart';
import 'package:happy_budget_flutter/view_models/budget_view_model.dart';
import 'package:provider/provider.dart';

class BudgetFilter extends StatefulWidget {
  const BudgetFilter({
    super.key,
  });

  @override
  State<BudgetFilter> createState() => _ExpenseFilterState();
}

class _ExpenseFilterState extends State<BudgetFilter> {
  FilterBudgetCategory _selectedCategory = FilterBudgetCategory.ALL;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Category'),
              const SizedBox(width: 10,),
              DropdownButton(
                  value: _selectedCategory,
                  items: FilterBudgetCategory.values
                      .map(
                        (category) => DropdownMenuItem(
                      value: category,
                      child: Text(
                        category.name,
                      ),
                    ),
                  )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      value != null
                          ? _selectedCategory = value
                          : _selectedCategory = _selectedCategory;
                    });
                  }),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  context.read<BudgetViewModel>().getBudgets(_selectedCategory);
                  Navigator.of(context).pop();
                },
                child: const Text('Submit Filter'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          )
        ],
      ),
    );
  }
}