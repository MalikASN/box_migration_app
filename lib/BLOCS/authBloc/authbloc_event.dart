import 'package:equatable/equatable.dart';

class AuthEvents extends Equatable {
  const AuthEvents();

  @override
  List<Object> get props => [];
}

class AuthLogin extends AuthEvents {
  final String email;
  final String password;

  AuthLogin({
    required this.email,
    required this.password,
  });
}
