class AuthResponse{
  final String accessToken;

  AuthResponse({required this.accessToken});
  factory AuthResponse.fromJson(Map<String,dynamic> map){
    return AuthResponse(
        accessToken: map['access_token'],
    );
  }
}