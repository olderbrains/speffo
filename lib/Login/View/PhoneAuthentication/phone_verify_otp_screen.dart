import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:speffo/Helper/api_url.dart';
import 'package:speffo/Helper/indicator.dart';
import 'package:speffo/Helper/page_router.dart';
import 'package:speffo/Home/nav_home.dart';
import 'package:speffo/Login/Controller/PhoneAuthentication/login_bloc.dart';
import 'package:speffo/Widgets/alerts.dart';

class PhoneVerifyOtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String countryCode;

  const PhoneVerifyOtpScreen({
    super.key,
    required this.phoneNumber,
    required this.countryCode,
  });

  @override
  State<PhoneVerifyOtpScreen> createState() => _PhoneVerifyOtpScreenState();
}

class _PhoneVerifyOtpScreenState extends State<PhoneVerifyOtpScreen> {
  var otpController = TextEditingController();
  var otpFocus = FocusNode();

  @override
  void dispose() {
    super.dispose();
    otpController.dispose();
    otpFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 75.h,
        backgroundColor: Colors.white,
        title: Text(
          'Verify Your Number',
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: BlocConsumer<LoginBloc, LoginState>(
        builder:
            (context, state) => Padding(
              padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 15.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Enter the code we\'ve sent by SMS to',
                              style: TextStyle(fontSize: 18.sp),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Row(
                          children: [
                            Text(
                              widget.countryCode + widget.phoneNumber,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        child: Pinput(
                          controller: otpController,
                          autofocus: true,
                          focusNode: otpFocus,
                          keyboardType: TextInputType.number,
                          onCompleted: (value) {
                            context.read<LoginBloc>().add(
                              VerifyPhoneOTPEvent(
                                phoneNumber: widget.phoneNumber,
                                countryCode: widget.countryCode,
                                otp: value,
                              ),
                            );
                          },
                          length: 4,
                          validator: (value) {
                            if (value!.length != 4) {
                              return 'OTP required';
                            }
                            return null;
                          },
                        ),
                      ),
                      Row(
                        children: [
                          Text('Haven\'t received OTP? '),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Resend OTP',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      state is AuthLoading ? Indicators() : SizedBox.shrink(),
                    ],
                  ),
                  Column(
                    children: [
                      Image.asset('assets/logo/logo.png', height: 50.h),
                      Text('© All Rights Reserved By ${Constants.appName}'),
                    ],
                  ),
                ],
              ),
            ),
        listener: (context, state) async {
          if (state is LoginAuthSuccess) {
            PageRouter.pushRemoveUntil(context, NavHome());
          } else if (state is LoginAuthReject) {
            HapticFeedback.lightImpact();

            FlashAlert.show(
              message: "Entered OTP is invalid or may expired",
              type: FlashAlertType.error,
            );
          }
        },
      ),
    );
  }
}
