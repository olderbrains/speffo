import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speffo/Helper/indicator.dart';
import 'package:speffo/Helper/page_router.dart';
import 'package:speffo/Login/Controller/PhoneAuthentication/login_bloc.dart';
import 'package:speffo/Login/View/PhoneAuthentication/phone_verify_otp_screen.dart';
import 'package:speffo/Widgets/alerts.dart';

class LoginMainView extends StatefulWidget {
  const LoginMainView({super.key});

  @override
  State<LoginMainView> createState() => _LoginMainViewState();
}

class _LoginMainViewState extends State<LoginMainView> {
  var phoneController = TextEditingController();

  var phoneNumberFocus = FocusNode();
  GlobalKey<FormState> phoneValidateKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
    phoneNumberFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: 75.h,
        title: Text(
          'Login or sign up',
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => LoginBloc(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black45),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Country/Region',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'India (+91)',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Icon(Icons.arrow_drop_down),
                        ],
                      ),
                      Divider(thickness: 1, color: Colors.black45),
                      Form(
                        key: phoneValidateKey,
                        child: TextFormField(
                          controller: phoneController,
                          focusNode: phoneNumberFocus,
                          validator: (value) {
                            if (value!.length != 10) {
                              return 'Phone Number not looking right!';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.black54),
                            hintText: 'Phone Number',
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: false,
                            signed: false,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  child: Text(
                    "We'll call or text you to confirm your number. Standard message and data rates apply.",
                    style: TextStyle(color: Colors.black54, fontSize: 12.sp),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: BlocConsumer<LoginBloc, LoginState>(
                    builder:
                        (context, loginRef) =>
                            loginRef is AuthLoading
                                ? Indicators()
                                : ElevatedButton(
                                  onPressed: () {
                                    if (phoneValidateKey.currentState!
                                        .validate()) {
                                      if (phoneNumberFocus.hasFocus) {
                                        phoneNumberFocus.unfocus();
                                      }

                                      context.read<LoginBloc>().add(
                                        SendOTPEvent(
                                          phoneNumber:
                                              phoneController.value.text
                                                  .toString(),
                                        ),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 14.h,
                                    ),
                                  ),
                                  child: const Text('Continue'),
                                ),
                    listener: (context, loginListenerRef) {
                      if (loginListenerRef is OTPSentSuccess) {
                        PageRouter.push(
                          context,
                          PhoneVerifyOtpScreen(
                            phoneNumber: phoneController.value.text,
                          ),
                        );
                      } else if (loginListenerRef is OTPSentFailed) {
                        FlashAlert.show(
                          context,
                          "OTP sent failed please try again",
                          type: FlashAlertType.warning,
                        );
                      }
                    },
                  ),
                ),
                SizedBox(height: 20.h),
                const Row(
                  children: [
                    Expanded(child: Divider(thickness: 1.5)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'or',
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(thickness: 1.5)),
                  ],
                ),
                SizedBox(height: 20.h),
                _buildSocialButton('Continue with email', Icons.email),
                const SizedBox(height: 12),
                _buildSocialButton('Continue with Apple', Icons.apple),
                const SizedBox(height: 12),
                _buildSocialButton('Continue with Google', Icons.gpp_maybe),
                const SizedBox(height: 12),
                _buildSocialButton('Continue with Facebook', Icons.facebook),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(String text, IconData icon) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 13.h),
        side: const BorderSide(color: Colors.black87),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.black54),
          SizedBox(width: 8.w),
          Text(text, style: TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }
}
