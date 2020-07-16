class LoginRequest {

  final String email;
  final String password;

  LoginRequest({this.email, this.password});

  factory LoginRequest.fromJson(Map<String, dynamic> json) {
    return LoginRequest(
        email: json["email"],
        password: json["password"]
    );
  }

}