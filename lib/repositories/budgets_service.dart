import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:happy_budget_flutter/models/budget/budget_model.dart';
import 'package:happy_budget_flutter/models/enums/budget_category_enum.dart';
import 'package:happy_budget_flutter/models/enums/filter_budget_category_enum.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';
import '../utils/data_state.dart';

class BudgetService {

  Future<DataState> createBudget(BudgetModel budget) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(kBaseUrl, '/api/budgets');
    final String? token = prefs.getString('token');
    try {
      http.Response response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: json.encode({
            'budgetCategory': budget.budgetCategory.name,
            'budgetSum': budget.budgetSum,
            'budgetDate': budget.budgetDate.toIso8601String()
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

  Future<DataState> getBudgets() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(kBaseUrl, '/api/budgets');
    final String? token = prefs.getString('token');
    List<BudgetModel> budgets = [];
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
          BudgetModel budgetModel = BudgetModel(
            id: int.parse(map['id'].toString()),
            budgetCategory: parseBudgetCategory(map['budgetCategory'] as String),
            budgetSum: (map['budgetSum'] as num).toDouble(),
            budgetDate: DateTime.parse(map['budgetDate'] as String),
          );
          budgets.add(budgetModel);
        }
        return Success<List<BudgetModel>>(code: HttpStatus.ok, data: budgets);
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

  Future<DataState> deleteBudget(int budgetId) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(kBaseUrl, '/api/budgets/$budgetId');
    final String? token = prefs.getString('token');
    http.Response response;
    try {
      response = await http.delete(url,
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

  Future<DataState> editBudget(BudgetModel budget) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(kBaseUrl, '/api/budgets/${budget.id}');
    final String? token = prefs.getString('token');
    try {
      http.Response response = await http.patch(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: json.encode({
            'budgetCategory': budget.budgetCategory.name,
            'budgetSum': budget.budgetSum,
            'budgetDate': budget.budgetDate.toIso8601String()
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


  Future<DataState> getBudgetsFilteredByCategory(FilterBudgetCategory category) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    late final Uri url;
    if(category == FilterBudgetCategory.ALL){
      url = Uri.http(kBaseUrl, '/api/budgets');
    }else{
      url = Uri.http(kBaseUrl, '/api/budgets/${category.name}');
    }
    final String? token = prefs.getString('token');
    List<BudgetModel> budgets = [];
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
          BudgetModel budgetModel = BudgetModel(
            id: int.parse(map['id'].toString()),
            budgetCategory: parseBudgetCategory(map['budgetCategory'] as String),
            budgetSum: (map['budgetSum'] as num).toDouble(),
            budgetDate: DateTime.parse(map['budgetDate'] as String),
          );
          budgets.add(budgetModel);
        }
        return Success<List<BudgetModel>>(code: HttpStatus.ok, data: budgets);
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