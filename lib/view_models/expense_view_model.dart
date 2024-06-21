import 'package:flutter/cupertino.dart';
import 'package:happy_budget_flutter/models/enums/filter_expense_categoty_enum.dart';
import 'package:happy_budget_flutter/models/expenses/expense_model.dart';
import 'package:happy_budget_flutter/repositories/expenses_service.dart';
import 'package:happy_budget_flutter/utils/data_state.dart';
import 'package:happy_budget_flutter/view_models/budget_view_model.dart';
import 'package:provider/provider.dart';

enum ExpenseState { initial, loading, success, error }

class ExpenseViewModel with ChangeNotifier {
  final ExpensesService _expensesService;

  ExpenseViewModel(this._expensesService) {
    getExpenses();
  }

  ExpenseState _expenseState = ExpenseState.initial;
  bool _loading = false;
  String _errorMessage = '';
  List<ExpenseModel> _expenses = [];


  //getters
  bool get loading => _loading;
  String get errorMessage => _errorMessage;
  ExpenseState get expenseState => _expenseState;
  List<ExpenseModel> get expenses => _expenses;


  void setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  Future<void> createExpense(ExpenseModel expense, BuildContext context) async {
    _expenseState = ExpenseState.loading;
    setLoading(true);
    DataState response = await _expensesService.createExpense(expense);
    if (response is Success) {
      _expenseState = ExpenseState.success;
      getExpenses();
      if(context.mounted){
        notifyDependentProviders(context);
      }

    } else if (response is Failure) {
      _expenseState = ExpenseState.error;
      _errorMessage = response.exception.toString();
    }
    setLoading(false);
  }

  getExpenses([FilterExpenseCategory? category, DateTime? startDate, DateTime? endDate]) async {
    if (category == null && startDate == null && endDate == null) {
      _expenseState = ExpenseState.loading;
      setLoading(true);
      var response = await _expensesService.getExpenses();
      if (response is Success) {
        _expenseState = ExpenseState.success;
        setExpenses(response.data);
      } else if (response is Failure) {
        _expenseState = ExpenseState.error;
        _errorMessage = response.exception.toString();
      }
      setLoading(false);
    } else if(category != null){
      setLoading(true);
      _expenseState = ExpenseState.loading;
      var response = await _expensesService.getExpensesFilteredByCategory(category);
      if (response is Success) {
        _expenseState = ExpenseState.success;
        setExpenses(response.data);

      } else if (response is Failure) {
        _expenseState = ExpenseState.error;
        _errorMessage = response.exception.toString();
      }
      setLoading(false);
    }else if(startDate != null && endDate != null){
      setLoading(true);
      var response = await _expensesService.getExpensesFilteredBetweenDates(startDate,endDate);
      if (response is Success) {
        _expenseState = ExpenseState.success;
        setExpenses(response.data);

      } else if (response is Failure) {
        _expenseState = ExpenseState.error;
        _errorMessage = response.exception.toString();
      }
      setLoading(false);
    }
  }

  setExpenses(List<ExpenseModel> expenses) {
    _expenses = expenses;
    notifyListeners();
  }

  deleteExpense(ExpenseModel expense, BuildContext context) async {
    setLoading(true);
    deleteExpenseFomExpenses(expense);
    var response = await _expensesService.deleteExpense(expense.id!);
    if (response is Success) {
      _expenseState = ExpenseState.success;
      if(context.mounted){

        notifyDependentProviders(context);
      }
    } else if (response is Failure) {
      _expenseState = ExpenseState.error;
      _errorMessage = response.exception.toString();
    }
    setLoading(false);
  }

  deleteExpenseFomExpenses(ExpenseModel expense) {
    _expenses.remove(expense);
    notifyListeners();
  }

  Future <void> editExpense(ExpenseModel expense, BuildContext context) async {
    _expenseState = ExpenseState.loading;
    setLoading(true);
    DataState response = await _expensesService.editExpense(expense);
    if (response is Success) {
      _expenseState = ExpenseState.success;
      getExpenses();
      if(context.mounted){
        notifyDependentProviders(context);
      }
    } else if (response is Failure) {
      _expenseState = ExpenseState.error;
      _errorMessage = response.exception.toString();
    }
    setLoading(false);
  }

  void notifyDependentProviders(BuildContext context){
    context.read<BudgetViewModel>().getBudgets();
  }
}
