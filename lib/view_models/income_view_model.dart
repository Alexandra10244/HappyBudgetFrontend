import 'package:flutter/cupertino.dart';
import 'package:happy_budget_flutter/models/incomes/income_model.dart';
import 'package:happy_budget_flutter/repositories/income_service.dart';
import 'package:provider/provider.dart';

import '../models/enums/filter_incomes_category_enum.dart';
import '../utils/data_state.dart';
import 'budget_view_model.dart';

enum IncomeState { initial, loading, success, error }

class IncomeViewModel with ChangeNotifier {
  final IncomeService _incomeService;

  IncomeViewModel(this._incomeService) {
    getIncomes();
  }

  IncomeState _incomeState = IncomeState.initial;
  bool _loading = false;
  String _errorMessage = '';
  List<IncomeModel> _incomes = [];


  //getters
  bool get loading => _loading;
  String get errorMessage => _errorMessage;
  IncomeState get incomeState => _incomeState;
  List<IncomeModel> get incomes => _incomes;


  void setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  Future<void> createIncome(IncomeModel income, BuildContext context) async {
    _incomeState = IncomeState.loading;
    setLoading(true);
    DataState response = await _incomeService.createIncome(income);
    if (response is Success) {
      _incomeState = IncomeState.success;
      getIncomes();
      if(context.mounted){
        notifyDependentProviders(context);
      }
    } else if (response is Failure) {
      _incomeState = IncomeState.error;
      _errorMessage = response.exception.toString();
    }
    setLoading(false);
  }

  getIncomes([FilterIncomeCategory? category, DateTime? startDate, DateTime? endDate ]) async {
    if (category == null && startDate == null && endDate == null) {
      _incomeState = IncomeState.loading;
      setLoading(true);
      var response = await _incomeService.getIncomes();
      if (response is Success) {
        _incomeState = IncomeState.success;
        setIncomes(response.data);
      } else if (response is Failure) {
        _incomeState = IncomeState.error;
        _errorMessage = response.exception.toString();
      }
      setLoading(false);
    } else if (category != null){
      setLoading(true);
      _incomeState = IncomeState.loading;
      var response = await _incomeService.getIncomesFilteredByCategory(category);
      if (response is Success) {
        _incomeState = IncomeState.success;
        setIncomes(response.data);

      } else if (response is Failure) {
        _incomeState = IncomeState.error;
        _errorMessage = response.exception.toString();
      }
      setLoading(false);
    }else if (startDate != null && endDate != null){
      setLoading(true);
      var response = await _incomeService.getIncomesFilteredBetweenDates(startDate, endDate);
      if (response is Success) {
        _incomeState = IncomeState.success;
        setIncomes(response.data);

      } else if (response is Failure) {
        _incomeState = IncomeState.error;
        _errorMessage = response.exception.toString();
      }
      setLoading(false);
    }
  }

  setIncomes(List<IncomeModel> incomes) {
    _incomes = incomes;
    notifyListeners();
  }

  Future<void> deleteIncome(IncomeModel income, BuildContext context) async {
    setLoading(true);
    _incomeState = IncomeState.loading;
    // deleteIncomeFomExpenses(income);
    var response = await _incomeService.deleteIncome(income.id!);
    if (response is Success) {
      _incomeState = IncomeState.success;
      deleteIncomeFomExpenses(income);
      if(context.mounted){
        notifyDependentProviders(context);
      }
    } else if (response is Failure) {
      _incomeState = IncomeState.error;
      _errorMessage = response.exception;
    }
    setLoading(false);
  }

  deleteIncomeFomExpenses(IncomeModel income) {
    _incomes.remove(income);
    notifyListeners();
  }

  Future <void> editIncome(IncomeModel income, BuildContext context) async {
    _incomeState = IncomeState.loading;
    setLoading(true);
    DataState response = await _incomeService.editIncome(income);
    if (response is Success) {
      _incomeState = IncomeState.success;
      getIncomes();
      if(context.mounted){
        notifyDependentProviders(context);
      }

    } else if (response is Failure) {
      _incomeState = IncomeState.error;
      _errorMessage = response.exception.toString();
    }
    setLoading(false);
  }

  void notifyDependentProviders(BuildContext context){
    context.read<BudgetViewModel>().getBudgets();
  }
}