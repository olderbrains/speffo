part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {

}

class SendOTPEvent extends LoginEvent{
  final String phoneNumber;

  SendOTPEvent({required this.phoneNumber});
}
class VerifyPhoneOTPEvent extends LoginEvent{
  final String phoneNumber;
  final String otp;

  VerifyPhoneOTPEvent({required this.phoneNumber,required this.otp});
}
class ResetLogin extends LoginEvent{

}
