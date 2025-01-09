part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];

}

final class AuthInitial extends AuthState {}

final class AuthLoadingState extends AuthState {}

final class AuthSuccessfulState extends AuthState {
  final UserModel userModel;

  const AuthSuccessfulState({required this.userModel});

  @override
  List<Object> get props => [userModel];
}

final class AuthFailureState extends AuthState {
  final String message;

  const AuthFailureState({required this.message});

  @override
  List<Object> get props => [message];
}

final class ChangeCountryCodeState extends AuthState {}
