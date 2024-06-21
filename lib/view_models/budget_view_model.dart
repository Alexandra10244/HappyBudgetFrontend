import 'package:flutter/cupertino.dart';
import 'package:happy_budget_flutter/models/budget/budget_model.dart';
import 'package:happy_budget_flutter/models/enums/filter_budget_category_enum.dart';
import 'package:happy_budget_flutter/repositories/budgets_service.dart';

import '../utils/data_state.dart';

enum BudgetState { initial, loading, success, error }

class BudgetViewModel with ChangeNotifier {
  final BudgetService _budgetService;

  BudgetViewModel(this._budgetService) {
    getBudgets();
  }

  BudgetState _budgetState = BudgetState.initial;
  bool _loading = false;
  String _errorMessage = '';
  List<BudgetModel> _budgets = [];


  //getters
  bool get loading => _loading;
  String get errorMessage => _errorMessage;
  BudgetState get budgetState => _budgetState;
  List<BudgetModel> get budgets => _budgets;


  void setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  Future <void> createBudget(BudgetModel budget) async {
    _budgetState = BudgetState.loading;
    setLoading(true);
    DataState response = await _budgetService.createBudget(budget);
    if (response is Success) {
      _budgetState = BudgetState.success;
      getBudgets();
    } else if (response is Failure) {
      _budgetState = BudgetState.error;
      _errorMessage = response.exception.toString();
    }
    setLoading(false);
  }

  Future <void> getBudgets([FilterBudgetCategory? category]) async {
    if (category == null) {
      setLoading(true);
      _budgetState = BudgetState.loading;
      var response = await _budgetService.getBudgets();
      if (response is Success) {
        _budgetState = BudgetState.success;
        setBudgets(response.data);
      } else if (response is Failure) {
        _budgetState = BudgetState.error;
        _errorMessage = response.exception.toString();
      }
      setLoading(false);
    } else {

      setLoading(true);
      _budgetState = BudgetState.loading;
      var response = await _budgetService.getBudgetsFilteredByCategory(category);
      if (response is Success) {
        _budgetState = BudgetState.success;
        setBudgets(response.data);

      } else if (response is Failure) {
        _budgetState = BudgetState.error;
        _errorMessage = response.exception.toString();
      }
      setLoading(false);
    }
  }

  setBudgets(List<BudgetModel> budgets) {
    _budgets = budgets;
    notifyListeners();
  }

 Future <void> deleteBudget(BudgetModel budget) async {
    setLoading(true);
    _budgetState = BudgetState.loading;
    // deleteExpenseFomExpenses(budget);
    var response = await _budgetService.deleteBudget(budget.id!);

    if (response is Success) {
      deleteExpenseFomExpenses(budget);
      _budgetState = BudgetState.success;
    } else if (response is Failure) {
      _budgetState = BudgetState.error;
      _errorMessage = response.exception.toString();
    }
    setLoading(false);
  }

  deleteExpenseFomExpenses(BudgetModel budget) {
    _budgets.remove(budget);
    notifyListeners();
  }

  Future <void> editBudget(BudgetModel budget) async {
    _budgetState = BudgetState.loading;
    setLoading(true);
    DataState response = await _budgetService.editBudget(budget);
    if (response is Success) {
      _budgetState = BudgetState.success;
      getBudgets();
    } else if (response is Failure) {
      _budgetState = BudgetState.error;
      _errorMessage = response.exception.toString();
    }
    setLoading(false);
  }


}