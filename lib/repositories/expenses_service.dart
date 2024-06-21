import 'dart:convert';
import 'dart:io';
import 'package:happy_budget_flutter/models/enums/filter_expense_categoty_enum.dart';
import 'package:happy_budget_flutter/models/expenses/expense_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/enums/expense_category_enum.dart';
import '../utils/constants.dart';
import '../utils/data_state.dart';

class ExpensesService {
  Future<DataState> createExpense(ExpenseModel expense) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(kBaseUrl, '/api/expenses');
    final String? token = prefs.getString('token');
    try {
      http.Response response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: json.encode({
            'title': expense.title,
            'expenseCategory': expense.expenseCategory.name,
            'expenseSum': expense.expenseSum,
            'expenseDate': expense.expenseDate!.toIso8601String()
          }));
      final dynamic dynamicResponse = jsonDecode(response.body);
      final Map<String, dynamic> mapResponse =
          Map<String, dynamic>.from(dynamicResponse);
      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        return const Success<void>(code: HttpStatus.ok);
      } else if (response.statusCode == HttpStatus.notFound) {
        return Failure<String>(
            exception: mapResponse['message'], code: HttpStatus.notFound);
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        return const Failure<String>(
            exception: 'Session expired. Login!',
            code: HttpStatus.unauthorized);
      }
      return const Failure<String>(code: 100, exception: 'Invalid Response');
    } on http.ClientException {
      return const Failure<String>(
          exception: 'Connection with server failed. Try again later.');
    } on HttpException {
      return const Failure<String>(
          code: 101, exception: 'No Internet Connection');
    } on SocketException {
      return const Failure<String>(
          code: 101, exception: 'No Internet Connection');
    } on FormatException {
      return const Failure<String>(code: 102, exception: 'Invalid Format');
    } catch (exception) {
      return const Failure<String>(
          code: 103, exception: 'Unknown Error. Restart App');
    }
  }

  Future<DataState> getExpenses() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(kBaseUrl, '/api/expenses');
    final String? token = prefs.getString('token');
    List<ExpenseModel> expenses = [];
    try {
      http.Response response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });
      final List<dynamic> dynamicList = json.decode(response.body);

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        List<Map<String, dynamic>> listData = dynamicList.map((item) {
          return Map<String, dynamic>.from(item);
        }).toList();

        for (final Map<String, dynamic> map in listData) {
          ExpenseModel expenseModel = ExpenseModel(
            id: int.parse(map['id'].toString()),
            title: map['title'] as String,
            expenseCategory: parseExpenseCategory(map['expenseCategory'] as String),
            expenseSum: (map['expenseSum'] as num).toDouble(),
            expenseDate: DateTime.parse(map['expenseDate'] as String),
          );
          expenses.add(expenseModel);
        }
        return Success<List<ExpenseModel>>(code: HttpStatus.ok, data: expenses);
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        return const Failure<String>(
            exception: 'Session expired. Login!',
            code: HttpStatus.unauthorized);
      } else if (response.statusCode == HttpStatus.notFound) {
        Map<String, dynamic> mapResponse =
            Map<String, dynamic>.from(dynamicList as Map);
        return Failure<String>(
            exception: mapResponse['message'], code: HttpStatus.notFound);
      }
      return const Failure<String>(code: 404, exception: 'Invalid Response');
    } on http.ClientException {
      return const Failure<String>(
          exception: 'Connection with server failed. Try again later.');
    } on FormatException{
      return const Failure<String>(
          exception: 'Session expired. Login!',
          code: HttpStatus.unauthorized);
    }
    catch (e) {
      return const Failure<String>(
          code: 103, exception: 'Unknown Error. Restart App');
    }
  }

  Future<DataState> deleteExpense(int expenseId) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(kBaseUrl, '/api/expenses/$expenseId');
    final String? token = prefs.getString('token');

    try {
       http.Response response = await http.delete(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          });


      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        return const Success<void>(code: HttpStatus.ok);
      } else if (response.statusCode == HttpStatus.notFound) {
        final dynamic dynamicResponse = jsonDecode(response.body);
        final Map<String, dynamic> mapResponse =
        Map<String, dynamic>.from(dynamicResponse);
        return Failure<String>(
            exception: mapResponse['message'], code: HttpStatus.notFound);
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        return const Failure<String>(
            exception: 'Session expired. Login!',
            code: HttpStatus.unauthorized);
      }
      return Failure<String>(code: response.statusCode, exception: 'Invalid Response');
    }catch (e){
      return  const Failure<String>(
          code:  500 , exception: 'Unknown Error. Restart App');
    }
  }

  Future<DataState> editExpense(ExpenseModel expense) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(kBaseUrl, '/api/expenses/${expense.id}');
    final String? token = prefs.getString('token');
    try {
      http.Response response = await http.patch(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: json.encode({
            'title': expense.title,
            'expenseCategory': expense.expenseCategory.name,
            'expenseSum': expense.expenseSum,
            'expenseDate': expense.expenseDate!.toIso8601String()
          }));
      final dynamic dynamicResponse = jsonDecode(response.body);
      final Map<String, dynamic> mapResponse =
      Map<String, dynamic>.from(dynamicResponse);
      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        return const Success<void>(code: HttpStatus.ok);
      } else if (response.statusCode == HttpStatus.notFound) {
        return Failure<String>(
            exception: mapResponse['message'], code: HttpStatus.notFound);
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        return const Failure<String>(
            exception: 'Session expired. Login!',
            code: HttpStatus.unauthorized);
      }
      return const Failure<String>(code: 100, exception: 'Invalid Response');
    } on http.ClientException {
      return const Failure<String>(
          exception: 'Connection with server failed. Try again later.');
    } on HttpException {
      return const Failure<String>(
          code: 101, exception: 'No Internet Connection');
    } on SocketException {
      return const Failure<String>(
          code: 101, exception: 'No Internet Connection');
    } on FormatException {
      return const Failure<String>(code: 102, exception: 'Invalid Format');
    } catch (exception) {
      return const Failure<String>(
          code: 103, exception: 'Unknown Error. Restart App');
    }
  }


  Future<DataState> getExpensesFilteredByCategory(FilterExpenseCategory category) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    late final Uri url;
    if(category == FilterExpenseCategory.ALL){
      url = Uri.http(kBaseUrl, '/api/expenses');
    }else{
      url = Uri.http(kBaseUrl, '/api/expenses/${category.name}');
    }
    final String? token = prefs.getString('token');
    List<ExpenseModel> expenses = [];
    try {
      http.Response response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });

      final List<dynamic> dynamicList = json.decode(response.body);

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        List<Map<String, dynamic>> listData = dynamicList.map((item) {
          return Map<String, dynamic>.from(item);
        }).toList();

        for (final Map<String, dynamic> map in listData) {
          ExpenseModel expenseModel = ExpenseModel(
            id: int.parse(map['id'].toString()),
            title: map['title'] as String,
            expenseCategory: parseExpenseCategory(map['expenseCategory'] as String),
            expenseSum: (map['expenseSum'] as num).toDouble(),
            expenseDate: DateTime.parse(map['expenseDate'] as String),
          );
          expenses.add(expenseModel);
        }
        return Success<List<ExpenseModel>>(code: HttpStatus.ok, data: expenses);
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        return const Failure<String>(
            exception: 'Session expired. Login!',
            code: HttpStatus.unauthorized);
      } else if (response.statusCode == HttpStatus.notFound) {
        Map<String, dynamic> mapResponse =
        Map<String, dynamic>.from(dynamicList as Map);
        return Failure<String>(
            exception: mapResponse['message'], code: HttpStatus.notFound);
      }
      return const Failure<String>(code: 404, exception: 'Invalid Response');
    } on http.ClientException {
      return const Failure<String>(
          exception: 'Connection with server failed. Try again later.');
    } catch (e) {
      return const Failure<String>(
          code: 103, exception: 'Unknown Error. Restart App');
    }
  }


  Future<DataState> getExpensesFilteredBetweenDates(DateTime start, DateTime end) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String startDate = start.toString().substring(0,10);
    String endDate = end.toString().substring(0,10);

    final Uri url = Uri.http(kBaseUrl, '/api/reports/expenses/$startDate/$endDate');
    final String? token = prefs.getString('token');
    List<ExpenseModel> expenses = [];
    try {
      http.Response response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });

      final List<dynamic> dynamicList = json.decode(response.body);

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        List<Map<String, dynamic>> listData = dynamicList.map((item) {
          return Map<String, dynamic>.from(item);
        }).toList();

        for (final Map<String, dynamic> map in listData) {
          ExpenseModel expenseModel = ExpenseModel(
            id: int.parse(map['id'].toString()),
            title: map['title'] as String,
            expenseCategory: parseExpenseCategory(map['expenseCategory'] as String),
            expenseSum: (map['expenseSum'] as num).toDouble(),
            expenseDate: DateTime.parse(map['expenseDate'] as String),
          );
          expenses.add(expenseModel);
        }
        return Success<List<ExpenseModel>>(code: HttpStatus.ok, data: expenses);
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        return const Failure<String>(
            exception: 'Session expired. Login!',
            code: HttpStatus.unauthorized);
      } else if (response.statusCode == HttpStatus.notFound) {
        Map<String, dynamic> mapResponse =
        Map<String, dynamic>.from(dynamicList as Map);
        return Failure<String>(
            exception: mapResponse['message'], code: HttpStatus.notFound);
      }
      return const Failure<String>(code: 404, exception: 'Invalid Response');
    } on http.ClientException {
      return const Failure<String>(
          exception: 'Connection with server failed. Try again later.');
    } catch (e) {
      return const Failure<String>(
          code: 103, exception: 'Unknown Error. Restart App');
    }
  }
}




