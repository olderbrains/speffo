import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:speffo/Login/Model/PhoneAuthentication/otp_success_model.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<SendOTPEvent>((event, emit) async {
      try {
        Response response = await http.get(
          Uri.parse(
            'https://control.msg91.com/api/v5/otp?otp_expiry=5&template_id=${event.sendOTPTemplateID}&mobile=+91${event.phoneNumber}&authkey=${dotenv.env['msg91AuthKey']}&realTimeResponse=1',
          ),
        );
        if (response.statusCode == 200) {
          OTPResponseModel ref = OTPResponseModel.fromJson(
            jsonDecode(response.body),
          );
          if (ref.requestID != null && ref.type == OTPResponseType.success) {
            emit(OTPSentSuccess());
          } else {
            emit(OTPSentFailed(error: ref.message));
          }
        } else {
          emit(
            OTPSentFailed(
              error: "Failed to send OTP. Status code: ${response.statusCode}",
            ),
          );
        }
      } catch (e) {
        emit(UnauthorizedState(error: "Unknown Error : ${e.toString()}"));
      }
    });
    on<VerifyPhoneOTPEvent>((event, emit) async {
      try {
        Response response = await http.get(
          Uri.parse(
            'https://control.msg91.com/api/v5/otp/verify?otp=${event.otp}&mobile=+91${event.phoneNumber}',
          ),
        );
        if (response.statusCode == 200) {
          OTPResponseModel ref = OTPResponseModel.fromJson(
            jsonDecode(response.body),
          );
          if (ref.message != null &&
              ref.message == 'OTP verified success' &&
              ref.type == OTPResponseType.success) {

            emit(LoginSuccess());
          } else if (ref.message != null && ref.message == 'OTP expired') {
            emit(VerifyOTPFailed(error: 'OTP Expired'));
          } else {
            emit(VerifyOTPFailed(error: ref.message));
          }
        } else {
          emit(
            VerifyOTPFailed(
              error:
                  "Failed to Verify OTP. Status code: ${response.statusCode}",
            ),
          );
        }
      } catch (e) {
        emit(UnauthorizedState(error: "Unknown Error : ${e.toString()}"));
      }
    });
  }
}
