import 'package:flutter/material.dart';
import 'package:happy_budget_flutter/models/budget/budget_model.dart';
import 'package:happy_budget_flutter/models/enums/budget_category_enum.dart';
import 'package:happy_budget_flutter/view_models/budget_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditBudget extends StatefulWidget {
  const EditBudget({
    super.key,
    required this.budget
  });

  final BudgetModel budget;

  @override
  State<EditBudget> createState() => _EditBudgetState();
}

class _EditBudgetState extends State<EditBudget> {
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  BudgetCategory _selectedCategory = BudgetCategory.UTILITY;
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
    _amountController.text = widget.budget.budgetSum.toString();
    _selectedDate = widget.budget.budgetDate;
    _selectedCategory = widget.budget.budgetCategory;
  }

  Future<bool> patchBudget(BudgetModel budget) async{
    await context.read<BudgetViewModel>().editBudget(budget);
    if(context.read<BudgetViewModel>().budgetState == BudgetState.error){
      return false;
    }
    return true;
  }
  void _submitExpenseData() async{
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
    bool success = await patchBudget(BudgetModel(
        id: widget.budget.id,
        budgetCategory: _selectedCategory,
        budgetSum: double.parse(_amountController.text),
        budgetDate: _selectedDate
    ),);
    if(success){
      Navigator.of(context).pop();
    }else{
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title:  Text(context.read<BudgetViewModel>().errorMessage),
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
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16 ,16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    label: Text('Budget Amount'),
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
                  items: BudgetCategory.values
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