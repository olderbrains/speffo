part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {

}

class SendOTPEvent extends LoginEvent{
  final String phoneNumber;
  final String sendOTPTemplateID;

  SendOTPEvent({required this.phoneNumber,required this.sendOTPTemplateID});
}
class VerifyPhoneOTPEvent extends LoginEvent{
  final String phoneNumber;
  final String otp;

  VerifyPhoneOTPEvent({required this.phoneNumber,required this.otp});
}
