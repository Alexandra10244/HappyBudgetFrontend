import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:happy_budget_flutter/repositories/auth_service.dart';
import 'package:happy_budget_flutter/repositories/budgets_service.dart';
import 'package:happy_budget_flutter/repositories/expenses_service.dart';
import 'package:happy_budget_flutter/repositories/income_service.dart';
import 'package:happy_budget_flutter/utils/injection_container.dart';
import 'package:happy_budget_flutter/view_models/auth_view_model.dart';
import 'package:happy_budget_flutter/view_models/budget_view_model.dart';
import 'package:happy_budget_flutter/view_models/expense_view_model.dart';
import 'package:happy_budget_flutter/view_models/income_view_model.dart';
import 'package:happy_budget_flutter/views/auth/login_page.dart';

import 'package:happy_budget_flutter/views/incomes/incomes_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

var kColorScheme =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 96, 59, 181));

var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 5, 99, 125),
);

void main() async {
  await initializeDependencies();
  runApp( const MyAppWrapper()
  );
}


class MyAppWrapper extends StatefulWidget {
  const MyAppWrapper({super.key});

  @override
  _MyAppWrapperState createState() => _MyAppWrapperState();
}

class _MyAppWrapperState extends State<MyAppWrapper> {
  @override
  Widget build(BuildContext context) {
    return _buildApp();
  }

  Widget _buildApp() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewModel>(create: (_) => AuthViewModel(locator.get<AuthService>())),
        ChangeNotifierProvider<ExpenseViewModel>(create: (_) => ExpenseViewModel(locator.get<ExpensesService>())),
        ChangeNotifierProvider<IncomeViewModel>(create: (_) => IncomeViewModel(locator.get<IncomeService>())),
        ChangeNotifierProvider<BudgetViewModel>(create: (_) => BudgetViewModel(locator.get<BudgetService>())),

      ],
      child: const MyApp(),
    );
  }

   void _resetProviders() {
    setState(() {});
  }

   void logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    _resetProviders();
  }
}



class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  late Future<String> _tokenFuture;

  @override
  void initState() {
    super.initState();
    _tokenFuture = getToken();
  }

  Future<String> getToken() async {
    //bool tokenExpired = true;
    //tokenExpired = await context.read<AuthViewModel>().isTokenExpired();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString('token') != null){ //&& !tokenExpired) {
      return prefs.getString('token')!;
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: _tokenFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CupertinoActivityIndicator(
              radius: 30,
            );
          }
          final token = snapshot.data;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Happy Budget',
            darkTheme: ThemeData.dark().copyWith(
              colorScheme: kDarkColorScheme,
              cardTheme: const CardTheme()
                  .copyWith(color: kDarkColorScheme.secondaryContainer),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                    backgroundColor: kDarkColorScheme.primaryContainer),
              ),
            ),
            theme: ThemeData().copyWith(
              colorScheme: kColorScheme,
              appBarTheme: const AppBarTheme().copyWith(
                  backgroundColor: kColorScheme.onPrimaryContainer,
                  foregroundColor: kColorScheme.primaryContainer),
              cardTheme: const CardTheme()
                  .copyWith(color: kColorScheme.secondaryContainer),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                    backgroundColor: kColorScheme.primaryContainer),
              ),
              textTheme: ThemeData().textTheme.copyWith(
                    titleLarge: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: kColorScheme.onSecondaryContainer,
                      fontSize: 16,
                    ),
                  ),
            ),
            themeMode: ThemeMode.system, //default
            home: token != null && token.isNotEmpty ? const IncomesPage() : const LoginScreen(),
          );
        });
  }
}
