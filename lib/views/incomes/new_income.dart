import 'package:flutter/material.dart';
import 'package:happy_budget_flutter/models/enums/income_category_enum.dart';
import 'package:happy_budget_flutter/models/incomes/income_model.dart';
import 'package:intl/intl.dart';

class NewIncome extends StatefulWidget {
  const NewIncome({super.key, required this.onAddIncome});

  final void Function(IncomeModel incomeEntity) onAddIncome;

  @override
  State<NewIncome> createState() => _NewIncomeState();
}

class _NewIncomeState extends State<NewIncome> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  IncomeCategory _selectedCategory = IncomeCategory.SALARY;
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

  void _submitIncomeData(){
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
    widget.onAddIncome(IncomeModel(
        title: _titleController.text,
        incomeCategory: _selectedCategory,
        incomeSum: double.parse(_amountController.text),
        incomeDate: _selectedDate
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
              label: Text('Income name'),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    label: Text('Income Amount'),
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
                  items: IncomeCategory.values
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
                onPressed: _submitIncomeData,
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