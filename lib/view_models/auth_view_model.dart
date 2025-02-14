import 'package:flutter/cupertino.dart';
import 'package:happy_budget_flutter/models/auth/auth_request.dart';
import 'package:happy_budget_flutter/models/auth/register_request.dart';
import 'package:happy_budget_flutter/repositories/auth_service.dart';
import 'package:happy_budget_flutter/utils/data_state.dart';

enum AuthState { initial, loading, authenticated, error }

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService;

  AuthViewModel(this._authService);

  bool _loading = false;
  AuthState _authState = AuthState.initial;
  String _errorMessage = '';

  bool get loading => _loading;
  AuthState get authState => _authState;
  String get errorMessage => _errorMessage;

  void setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  Future<void> register(RegisterRequest user) async {
    setLoading(true);
    final response = await _authService.register(user);
    if (response is Failure) {
      _authState = AuthState.error;
    } else if (response is Success) {
      _authState = AuthState.authenticated;
    }
    setLoading(false);
  }

  Future<void> login(AuthRequest user) async {
    setLoading(true);
    final response = await _authService.login(user);
     if (response is Failure) {
       _authState = AuthState.error;
       _errorMessage = response.exception.toString();
        } else if (response is Success) {
       _authState = AuthState.authenticated;
     }
     setLoading(false);
  }

  Future<bool> isTokenExpired() async{
    DataState response = await _authService.isTokenExpired();
    if(response is Success && response.code == 200){
      return false;
    }else{
      return true;
    }
  }
}
