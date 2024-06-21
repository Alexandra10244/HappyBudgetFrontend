import 'dart:convert';
import 'dart:io';
import 'package:happy_budget_flutter/models/auth/auth_request.dart';
import 'package:happy_budget_flutter/models/auth/auth_response.dart';
import 'package:happy_budget_flutter/models/auth/register_request.dart';
import 'package:happy_budget_flutter/utils/data_state.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class AuthService {
  Future<DataState> register(RegisterRequest user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(kBaseUrl, '/api/auth/register');
    try {
      http.Response response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'username': user.username,
            'email': user.email,
            'password': user.password,
            'birthday': user.birthday,
            'phoneNumber': user.phoneNumber
          }));
      final dynamic dynamicResponse = jsonDecode(response.body);
      final Map<String, dynamic> mapResponse =
          Map<String, dynamic>.from(dynamicResponse);
      if (response.statusCode == HttpStatus.ok) {
        AuthResponse authResponse = AuthResponse.fromJson(mapResponse);
        await prefs.remove('token');
        await prefs.setString('token', authResponse.accessToken);

        return const Success<void>(code: HttpStatus.ok);
      } else if (response.statusCode == HttpStatus.conflict) {
        return Failure<String>(
            exception: mapResponse['message'], code: HttpStatus.conflict);
      } else if (response.statusCode == HttpStatus.badRequest) {
        return Failure<String>(
            exception: mapResponse['message'], code: HttpStatus.conflict);
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

  Future<DataState> login(AuthRequest user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(kBaseUrl, '/api/auth/authenticate');
    try {
      http.Response response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'email': user.email, 'password': user.password}));
      final dynamic dynamicResponse = jsonDecode(response.body);
      final Map<String, dynamic> mapResponse =
          Map<String, dynamic>.from(dynamicResponse);
      if (response.statusCode == HttpStatus.ok) {
        AuthResponse authResponse = AuthResponse.fromJson(mapResponse);
        await prefs.remove('token');
        await prefs.setString('token', authResponse.accessToken);
        return const Success<void>(code: HttpStatus.ok);
      } else if (response.statusCode == HttpStatus.conflict) {
        return Failure<String>(
            exception: mapResponse['message'], code: HttpStatus.conflict);
      } else if (response.statusCode == HttpStatus.badRequest) {
        return Failure<String>(
            exception: mapResponse['message'], code: HttpStatus.badRequest);
      }
      return const Failure<String>(code: 100, exception: 'Invalid Response');
    } on http.ClientException catch (e) {
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

  Future<DataState> isTokenExpired() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    final url = Uri.http(kBaseUrl, '/api/auth/token');
    try {
      http.Response response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
       final dynamic dynamicResponse = jsonDecode(response.body);
      if (response.statusCode == HttpStatus.ok) {
        final bool val = bool.parse(dynamicResponse.toString());
        return  Success<bool>(data: val, code: HttpStatus.ok);
      } else  {
        await prefs.remove('token');
        return const Failure<String>(
            exception: 'Invalid token', code: HttpStatus.notFound);
      }
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
}
