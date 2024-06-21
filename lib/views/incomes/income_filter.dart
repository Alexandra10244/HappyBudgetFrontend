import 'package:flutter/material.dart';
import 'package:happy_budget_flutter/models/enums/filter_incomes_category_enum.dart';
import 'package:happy_budget_flutter/view_models/income_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class IncomeFilter extends StatefulWidget {
  const IncomeFilter({
    super.key,
  });

  @override
  State<IncomeFilter> createState() => _IncomeFilterState();
}

class _IncomeFilterState extends State<IncomeFilter> {
  FilterIncomeCategory _selectedCategory = FilterIncomeCategory.ALL;

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  void _presentDatePickerOne() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final lastDate = DateTime(now.year + 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: lastDate);
    setState(() {
      _startDate = pickedDate ?? DateTime.now();
    });
  }

  void _presentDatePickerTwo() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final lastDate = DateTime(now.year + 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: lastDate);
    setState(() {
      _endDate = pickedDate ?? DateTime.now();
    });
  }

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
                  items: FilterIncomeCategory.values
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
                  context.read<IncomeViewModel>().getIncomes(_selectedCategory);
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
          ),
          const SizedBox(
            height: 16,
          ),
          SizedBox(
            height: 2,
            width: double.infinity,
            child: Container(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          Column(
            children: [
              const SizedBox(
                height: 16,
              ),
              const Text('Start Date:'),
              const SizedBox(
                width: 6,
              ),
              Text(DateFormat.yMMMd().format(_startDate)),
              const SizedBox(
                width: 6,
              ),
              IconButton(
                onPressed: _presentDatePickerOne,
                icon: const Icon(Icons.calendar_month),
              ),

              const Text('End Date:'),
              const SizedBox(
                width: 6,
              ),
              Text(DateFormat.yMMMd().format(_endDate)),
              const SizedBox(
                width: 6,
              ),
              IconButton(
                onPressed: _presentDatePickerTwo,
                icon: const Icon(Icons.calendar_month),
              ),
              const SizedBox(
                width: 6,
              ),
              ElevatedButton(
                onPressed: () {
                  context
                      .read<IncomeViewModel>()
                      .getIncomes(null, _startDate, _endDate);
                  Navigator.of(context).pop();
                },
                child: const Text('Submit Filter Date Filter'),
              ),
              const SizedBox(
                width: 6,
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel Date Filter'),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          SizedBox(
            height: 2,
            width: double.infinity,
            child: Container(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  context.read<IncomeViewModel>().getIncomes();
                  Navigator.of(context).pop();
                },
                child: const Text('Reset Filters'),
              )
            ],
          )
        ],
      ),
    );
  }
}
