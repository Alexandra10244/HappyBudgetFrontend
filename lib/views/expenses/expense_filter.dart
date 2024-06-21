import 'package:flutter/material.dart';
import 'package:happy_budget_flutter/models/enums/filter_expense_categoty_enum.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../view_models/expense_view_model.dart';


class ExpenseFilter extends StatefulWidget {
  const ExpenseFilter({
    super.key,
  });

  @override
  State<ExpenseFilter> createState() => _ExpenseFilterState();
}

class _ExpenseFilterState extends State<ExpenseFilter> {

  FilterExpenseCategory _selectedCategory = FilterExpenseCategory.ALL;

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
   //ExpenseViewModel expenseViewModel = context.read()<ExpenseViewModel>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Category:'),
              const SizedBox(width: 10,),
              DropdownButton(
                  value: _selectedCategory,
                  items: FilterExpenseCategory.values
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
                onPressed: (){
                  context.read<ExpenseViewModel>().getExpenses(_selectedCategory);
                  Navigator.of(context).pop();
                },
                child: const Text('Submit'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
          const SizedBox(height: 16,),
           SizedBox(
            height: 2,
            width: double.infinity,
             child: Container(
               color: Theme.of(context).colorScheme.onPrimary,
             ),
          ),
          Column(

               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 const SizedBox(height: 15,),
                 const Text('Start Date:'),
                 Text(DateFormat.yMMMd()
                     .format(_startDate )),
                 const SizedBox(width: 6,),
                 IconButton(
                   onPressed: _presentDatePickerOne,
                   icon: const Icon(Icons.calendar_month),
                 ),
                 const SizedBox(width: 6,),

                 const Text('End Date:'),
                 const SizedBox(width: 6,),
                 Text(DateFormat.yMMMd()
                     .format(_endDate )),
                 const SizedBox(width: 6,),
                 IconButton(
                   onPressed: _presentDatePickerTwo,
                   icon: const Icon(Icons.calendar_month),
                 ),
                 const SizedBox(width: 6,),
                 ElevatedButton(
                   onPressed: (){
                     context.read<ExpenseViewModel>().getExpenses(null,_startDate,_endDate);
                     Navigator.of(context).pop();
                   },
                   child: const Text('Submit Filter Date Filter'),
                 ),
                 TextButton(
                   onPressed: () {
                     Navigator.of(context).pop();
                   },
                   child: const Text('Cancel Date Filter'),
                 ),

           ],
          ),
          const SizedBox(height: 16,),
          SizedBox(
            height: 2,
            width: double.infinity,
            child: Container(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 16,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: (){
                    context.read<ExpenseViewModel>().getExpenses();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Reset Filters'),
              )
            ],
          ),
        ],
      ),
    );
  }
}
