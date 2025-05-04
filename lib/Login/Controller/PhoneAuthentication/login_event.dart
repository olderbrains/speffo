part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class SendOTPEvent extends LoginEvent {
  final String phoneNumber;
  final String countryCode;

  SendOTPEvent({required this.phoneNumber, required this.countryCode});
}

class VerifyPhoneOTPEvent extends LoginEvent {
  final String phoneNumber;
  final String countryCode;
  final String otp;

  VerifyPhoneOTPEvent({
    required this.phoneNumber,
    required this.countryCode,
    required this.otp,
  });
}

class ResetLogin extends LoginEvent {}
