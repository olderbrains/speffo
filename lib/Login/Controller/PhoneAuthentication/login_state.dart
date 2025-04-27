part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class UnauthorizedState extends LoginState {
  final String? error;

  UnauthorizedState({required this.error});
}

final class OTPSentSuccess extends LoginState {}

final class OTPSentFailed extends LoginState {
  final String? error;

  OTPSentFailed({required this.error});
}

final class VerifyOTPSuccess extends LoginState {}

final class VerifyOTPFailed extends LoginState {
  final String? error;

  VerifyOTPFailed({required this.error});
}

final class LoginSuccess extends LoginState {}

final class LoginReject extends LoginState {}
