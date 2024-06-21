class RegisterRequest{

  final String username;
  final String email;
  final String password;
  final String birthday;
  final String phoneNumber;

  RegisterRequest({
      required this.username,
      required this.email,
      required this.password,
      required this.birthday,
      required this.phoneNumber});
}