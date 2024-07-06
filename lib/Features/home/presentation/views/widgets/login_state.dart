// login_state.dart

part of 'login_cubit.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final LoginResponse loginResponse;

  LoginSuccess(this.loginResponse);
}

class LoginFailure extends LoginState {
  final Failure failure;

  LoginFailure(this.failure);
}
