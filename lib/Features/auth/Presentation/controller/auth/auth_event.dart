part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

final class SignInEvent extends AuthEvent {
  final LoginInput loginInput;

  const SignInEvent({required this.loginInput});

  @override
  List<Object> get props => [loginInput];
}

final class SignUpEvent extends AuthEvent {
  final RegisterInputs registerInputs;

  const SignUpEvent({required this.registerInputs});

  @override
  List<Object> get props => [registerInputs];
}

final class SignOutEvent extends AuthEvent {
  final String token;
  const SignOutEvent(this.token);
  @override
  List<Object> get props => [token];
}
