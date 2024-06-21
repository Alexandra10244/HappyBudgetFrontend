import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/auth/register_request.dart';
import '../../view_models/auth_view_model.dart';
import '../components/rounded_button.dart';
import '../expenses/expenses_page.dart';
import 'package:intl/intl.dart';

class RegisterScreen extends StatefulWidget {
  static const String id = 'register_screen';

  const RegisterScreen({super.key});
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String username = '';
  String email = '';
  String password = '';
  DateTime birthday = DateTime(2000,1,1);
  String phoneNumber = '';

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 100, now.month, now.day);
    final lastDate = DateTime(now.year + 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: lastDate);
    setState(() {
      birthday = pickedDate!;
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthViewModel authViewModel = context.watch<AuthViewModel>();
    Widget cpi = const Text('');
    if (authViewModel.loading == true) {
      setState(() {
        cpi = const CupertinoActivityIndicator(
          color: Colors.deepPurpleAccent,
          radius: 20,
        );
      });
    }
    return Scaffold(
      backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark? Theme.of(context).colorScheme.background :
      Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Text(
                'HappyBudget',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary, fontSize: 35),
              ),
            ),
            const SizedBox(
              height: 28.0,
            ),
            cpi,
            const SizedBox(
              height: 28.0,
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'username'),
              onChanged: (value) {
                username = value;
              },
              //decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your Email')
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'you@mail.com'),
              onChanged: (value) {
                email = value;
              },
              //decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your Email')
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'password'),
              onChanged: (value) {
                password = value;
              },
              obscureText: true,
              //decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your Password')
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'phone number'),
              onChanged: (value) {
                phoneNumber = value;
              },
              //decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your Email')
            ),
            const SizedBox(
              height: 8.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                    'Birthday: ',
                  style: TextStyle(
                    fontSize: 18
                  ),
                ),
                Text(DateFormat.yMMMd()
                    .format(birthday),
                  style: const TextStyle(
                      fontSize: 18
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: _presentDatePicker,
                  icon: const Icon(Icons.calendar_month),
                ),
              ],
            ),
            const SizedBox(
              height: 24.0,
            ),
            RoundedButton(
                color: MediaQuery.of(context).platformBrightness == Brightness.dark?
                Theme.of(context).colorScheme.primary :
                Theme.of(context).colorScheme.onPrimaryContainer,
                title: 'Register',
                onPressed: () async {
                  RegisterRequest req = RegisterRequest(
                      username: username,
                      email: email,
                      password: password,
                      birthday: birthday.toIso8601String(),
                      phoneNumber: phoneNumber);
                  await authViewModel.register(req);
                  if (authViewModel.authState == AuthState.error &&
                      context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(authViewModel.errorMessage)));
                  } else if (authViewModel.authState ==
                          AuthState.authenticated &&
                      context.mounted) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => const ExpensesPage()));
                  }
                }),
            RoundedButton(
                color: MediaQuery.of(context).platformBrightness == Brightness.dark?
                Theme.of(context).colorScheme.inversePrimary :
                Theme.of(context).colorScheme.primary,
                title: 'Already hava an account? Login',
                onPressed: () async {
                  Navigator.of(context).pop();
                }),
          ],
        ),
      ),
    );
  }
}
