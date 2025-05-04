import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:speffo/Helper/api_url.dart';
import 'package:speffo/Login/Model/PhoneAuthentication/otp_success_model.dart';
import 'package:speffo/Login/Model/PhoneAuthentication/user_register_model.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginAuthInitial()) {
    on<SendOTPEvent>((event, emit) async {
      try {
        emit(AuthLoading());
        Response response = await http.get(
          Uri.parse(
            '${ApiURl.sentOTPUrl}otp_expiry=5&template_id=${dotenv.env['SEND_OTP_TEMPLATE_ID']}&mobile=${event.countryCode}${event.phoneNumber}&authkey=${dotenv.env['MSG91_KEY']}&realTimeResponse=1',
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
        emit(LoginAuthReject(message: "Something went wrong"));
      }
    });

    on<VerifyPhoneOTPEvent>((event, emit) async {
      emit(AuthLoading());

      try {
        // Check for API key
        final msg91Key = dotenv.env['MSG91_KEY'];
        if (msg91Key == null || msg91Key.isEmpty) {
          emit(LoginAuthReject(message: "Missing MSG91 API key"));
          return;
        }

        // Verify OTP
        final otpUri = Uri.parse(
          '${ApiURl.verifyOTPUrl}otp=${event.otp}&mobile=+91${event.phoneNumber}',
        );

        final otpResponse = await http.get(
          otpUri,
          headers: {'authkey': msg91Key},
        ).timeout(const Duration(seconds: 10));

        if (otpResponse.statusCode != 200) {
          emit(LoginAuthReject(message: "OTP verification failed with status: ${otpResponse.statusCode}"));
          return;
        }

        final otpData = OTPResponseModel.fromJson(jsonDecode(otpResponse.body));
        if (otpData.message != 'OTP verified success') {
          emit(LoginAuthReject(message: "OTP verification unsuccessful"));
          return;
        }

        // Create Firebase User
        final registerUri = Uri.parse(ApiURl.baseUrl + ApiURl.createFirebaseUser);
        final registerResponse = await http.post(
          registerUri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({"phone": '+91${event.phoneNumber}'}),
        ).timeout(const Duration(seconds: 10));

        if (registerResponse.statusCode != 200) {
          emit(LoginAuthReject(message: "Firebase registration failed"));
          return;
        }

        final userData = UserRegisterModel.fromJson(jsonDecode(registerResponse.body));
        if (userData.token.isEmpty) {
          emit(LoginAuthReject(message: "Received empty token"));
          return;
        }

        // Sign in with Firebase
        final userCredential = await FirebaseAuth.instance.signInWithCustomToken(userData.token);

        if (userCredential.user != null) {
          emit(LoginAuthSuccess());
        } else {
          emit(LoginAuthReject(message: "Firebase sign-in failed"));
        }
      } catch (e) {
        emit(LoginAuthReject(message: "Unexpected error: ${e.toString()}"));
      }
    });

    on<ResetLogin>((event, emit) async {
      emit(LoginAuthInitial());
    });
  }
}
