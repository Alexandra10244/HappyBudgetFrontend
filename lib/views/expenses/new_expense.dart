import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/enums/expense_category_enum.dart';
import '../../models/expenses/expense_model.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(ExpenseModel expenseEntity) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  ExpenseCategory _selectedCategory = ExpenseCategory.UTILITY;
  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final lastDate = DateTime(now.year + 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: lastDate);
    setState(() {
      _selectedDate = pickedDate ?? DateTime.now();
    });
  }

  void _submitExpenseData(){
    if(_titleController.text.trim().isEmpty){
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid title'),
          content: const Text('Enter at least one alpha-numeric character!'),
          actions: [
            TextButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: const Text('I understand')
            ),
          ],
        ),
      );
      return;
    }
    if(double.tryParse(_amountController.text) == null ||
        double.tryParse(_amountController.text)! < 1){
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid amount'),
          content: const Text('Only enter numbers greater than 0!'),
          actions: [
            TextButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: const Text('I understand')
            ),
          ],
        ),
      );
      return;
    }
    widget.onAddExpense(ExpenseModel(
        title: _titleController.text,
        expenseCategory: _selectedCategory,
        expenseSum: double.parse(_amountController.text),
        expenseDate: _selectedDate
    ),);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16 ,16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            maxLength: 50,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              label: Text('Expense name'),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    label: Text('Expense Amount'),
                    prefixText: 'RON ',
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(DateFormat.yMMMd()
                        .format(_selectedDate )),
                    IconButton(
                      onPressed: _presentDatePicker,
                      icon: const Icon(Icons.calendar_month),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              DropdownButton(
                  value: _selectedCategory,
                  items: ExpenseCategory.values
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
              const Spacer(),
              ElevatedButton(
                onPressed: _submitExpenseData,
                child: const Text('Save'),
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
