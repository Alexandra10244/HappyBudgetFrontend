import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/enums/expense_category_enum.dart';
import '../../models/expenses/expense_model.dart';
import '../../view_models/expense_view_model.dart';

class EditExpense extends StatefulWidget {
  const EditExpense({
    super.key,
    required this.expense
  });

  final ExpenseModel expense;

  @override
  State<EditExpense> createState() => _EditExpenseState();
}

class _EditExpenseState extends State<EditExpense> {
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
  @override
  void initState() {
    setParams();
    super.initState();
  }

  void setParams(){
    _titleController.text = widget.expense.title;
    _amountController.text = widget.expense.expenseSum.toString();
    _selectedDate = widget.expense.expenseDate!;
    _selectedCategory = widget.expense.expenseCategory;
  }

  Future<bool> patchExpense(ExpenseModel expense) async{
    await context.read<ExpenseViewModel>().editExpense(expense, context);
    if(context.read<ExpenseViewModel>().expenseState == ExpenseState.error){

      return false;
    }
    return true;
  }
  void _submitExpenseData() async{
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
    bool result = await patchExpense(ExpenseModel(
        id: widget.expense.id,
        title: _titleController.text,
        expenseCategory: _selectedCategory,
        expenseSum: double.parse(_amountController.text),
        expenseDate: _selectedDate
    ),);
    if(result){
      Navigator.of(context).pop();
    }else{
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title:  Text(context.read<ExpenseViewModel>().errorMessage),
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