import 'package:flutter/material.dart';
import 'package:happy_budget_flutter/models/enums/income_category_enum.dart';
import 'package:happy_budget_flutter/view_models/income_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/incomes/income_model.dart';

class EditIncome extends StatefulWidget {
  const EditIncome({
    super.key,
    required this.income
  });

  final IncomeModel income;

  @override
  State<EditIncome> createState() => _EditIncomeState();
}

class _EditIncomeState extends State<EditIncome> {
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
  @override
  void initState() {
    setParams();
    super.initState();
  }

  void setParams(){
    _titleController.text = widget.income.title;
    _amountController.text = widget.income.incomeSum.toString();
    _selectedDate = widget.income.incomeDate;
    _selectedCategory = widget.income.incomeCategory;
  }

  Future<bool> patchIncome(IncomeModel income) async{
    await context.read<IncomeViewModel>().editIncome(income, context);
    if(context.read<IncomeViewModel>().incomeState == IncomeState.error){
      return false;
    }
    return true;
  }
  void _submitIncomeData() async{
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
    bool success = await patchIncome(IncomeModel(
        id: widget.income.id,
        title: _titleController.text,
        incomeCategory: _selectedCategory,
        incomeSum: double.parse(_amountController.text),
        incomeDate: _selectedDate
    ),);
    if(success){
      Navigator.of(context).pop();
    }else{
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title:  Text(context.read<IncomeViewModel>().errorMessage),
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
    }

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