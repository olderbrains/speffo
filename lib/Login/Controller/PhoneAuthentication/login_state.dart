part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class OTPSentSuccess extends LoginState {}

final class OTPSentFailed extends LoginState {
  final String? error;

  OTPSentFailed({required this.error});
}

final class LoginAuthInitial extends LoginState {}

final class AuthLoading extends LoginState {}

final class LoginAuthSuccess extends LoginState {}

final class LoginAuthReject extends LoginState {}
