import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:speffo/Helper/api_url.dart';
import 'package:speffo/Login/Model/PhoneAuthentication/otp_success_model.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginAuthInitial()) {
    on<SendOTPEvent>((event, emit) async {
      try {
        emit(AuthLoading());
        Response response = await http.get(
          Uri.parse(
            '${ApiURl.sentOTPUrl}otp_expiry=5&template_id=${dotenv.env['SEND_OTP_TEMPLATE_ID']}&mobile=+91${event.phoneNumber}&authkey=${dotenv.env['MSG91_KEY']}&realTimeResponse=1',
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
        emit(LoginAuthReject());
      }
    });

    on<VerifyPhoneOTPEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        Response response = await http.get(
          headers: {'authkey': '${dotenv.env['MSG91_KEY']}'},
          Uri.parse(
            '${ApiURl.verifyOTPUrl}otp=${event.otp}&mobile=+91${event.phoneNumber}',
          ),
        );

        if (response.statusCode == 200) {
          OTPResponseModel ref = OTPResponseModel.fromJson(
            jsonDecode(response.body),
          );
          if (ref.message != null && ref.message == 'OTP verified success') {
            emit(LoginAuthSuccess());
          } else {
            emit(LoginAuthReject());
          }
        } else {
          emit(LoginAuthReject());
        }
      } catch (e) {
        emit(LoginAuthReject());
      }
    });
    on<ResetLogin>((event, emit) async {
      emit(LoginAuthInitial());
    });
  }
}
