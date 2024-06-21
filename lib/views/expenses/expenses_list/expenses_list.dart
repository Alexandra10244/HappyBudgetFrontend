import 'package:flutter/material.dart';

import '../../../models/expenses/expense_model.dart';
import 'expense_item.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList(
      {super.key, required this.onRemoveExpense, required this.expenses});

  final List<ExpenseModel> expenses;


  final void Function(ExpenseModel) onRemoveExpense;

  @override
  Widget build(BuildContext context){

    return ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: ValueKey(expenses[index]),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              onRemoveExpense(expenses[index]);
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
            child: ExpenseItem(expenseEntity: expenses[index]),
          );
        });
  }
}

// class ExpensesList extends StatelessWidget {
//   const ExpensesList({
//     Key? key,
//     required this.onRemoveExpense,
//   }) : super(key: key);
//
//   final void Function(ExpenseModel) onRemoveExpense;
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<ExpenseModel>>(
//       future: Provider.of<ExpenseViewModel>(context).getExpenses(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           // Display a loading indicator while waiting for data
//           return Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           // Display an error message if there's an error
//           return Center(child: Text('Error: ${snapshot.error}'));
//         } else {
//           // Data has been fetched successfully, build the ListView
//           List<ExpenseModel> expenses = snapshot.data ?? [];
//           return ListView.builder(
//             itemCount: expenses.length,
//             itemBuilder: (context, index) {
//               return Dismissible(
//                 key: ValueKey(expenses[index]),
//                 direction: DismissDirection.endToStart,
//                 onDismissed: (direction) {
//                   onRemoveExpense(expenses[index]);
//                 },
//                 background: Container(
//                   color: Theme.of(context).colorScheme.error.withOpacity(0.7),
//                   margin: Theme.of(context).cardTheme.margin,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: Row(
//                       children: [
//                         const Spacer(),
//                         Text(
//                           'Delete',
//                           style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                               color: Colors.white, fontWeight: FontWeight.w400),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 child: ExpenseItem(expenseEntity: expenses[index]),
//               );
//             },
//           );
//         }
//       },
//     );
//   }
// }

