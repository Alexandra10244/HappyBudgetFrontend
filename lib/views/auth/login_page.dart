import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:happy_budget_flutter/models/auth/auth_request.dart';
import 'package:happy_budget_flutter/views/auth/register_screen.dart';
import 'package:happy_budget_flutter/views/expenses/expenses_page.dart';
import 'package:provider/provider.dart';
import '../../view_models/auth_view_model.dart';
import '../components/rounded_button.dart';

class LoginScreen extends StatefulWidget {

  static const String id = 'login_screen';

  const LoginScreen({super.key});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email= '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    AuthViewModel authViewModel = context.watch<AuthViewModel>();
    Widget cpi = const Text('');
    if(authViewModel.loading == true){
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
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Text(
                  'HappyBudget',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 35
                ),
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
              decoration: const InputDecoration(
                  hintText: 'you@email.com'
              ),
                onChanged: (value) {
                  email = value;
                },
                //decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your Email')
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: 'password'
              ),
                onChanged: (value) {
                  password = value;
                },
              obscureText: true,
                //decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your Password')
            ),
            const SizedBox(
              height: 24.0,
            ),
            RoundedButton(
                color: MediaQuery.of(context).platformBrightness == Brightness.dark?
                Theme.of(context).colorScheme.primary :
                Theme.of(context).colorScheme.onPrimaryContainer,
                title: 'Log In',
                onPressed: () async {
                  //_loginRequest();
                  AuthRequest req = AuthRequest(email: email, password: password);
                  await authViewModel.login(req);
                  if(authViewModel.authState == AuthState.error && context.mounted){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(authViewModel.errorMessage)));
                  }else if(authViewModel.authState == AuthState.authenticated && context.mounted){
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => const ExpensesPage())
                    );
                  }
                }
            ),
            RoundedButton(
                color: MediaQuery.of(context).platformBrightness == Brightness.dark?
                Theme.of(context).colorScheme.inversePrimary :
                Theme.of(context).colorScheme.primary,
                title: 'Don\'t have an account? Register',
                onPressed: () async {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => const RegisterScreen())
                    );
                }
            ),
          ],
        ),
      ),
    );
  }

}