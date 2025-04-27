import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:speffo/Helper/indicator.dart';
import 'package:speffo/Helper/page_router.dart';
import 'package:speffo/Home/nav_home.dart';
import 'package:speffo/Login/Controller/PhoneAuthentication/login_bloc.dart';

class LoginMainView extends StatefulWidget {
  const LoginMainView({super.key});

  @override
  State<LoginMainView> createState() => _LoginMainViewState();
}

class _LoginMainViewState extends State<LoginMainView> {
  var phoneController = TextEditingController();
  var otpController = TextEditingController();
  var otpFocus = FocusNode();
  var phoneNumberFocus = FocusNode();
  GlobalKey<FormState> phoneValidateKey = GlobalKey<FormState>();
  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
    otpController.dispose();
    phoneNumberFocus.dispose();
    otpFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
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
                  child: BlocListener<LoginBloc, LoginState>(
                    listener: (context, loginListenerRef) {
                      if (loginListenerRef is OTPSentSuccess) {
                        showModalBottomSheet(
                          isDismissible: false,
                          enableDrag: false,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15.r),
                              topRight: Radius.circular(15.r),
                            ),
                          ),
                          context: context,
                          builder: (context) {
                            return BlocProvider(
                              create: (context) => LoginBloc(),
                              child: BlocListener<LoginBloc, LoginState>(
                                listener: (context, state) {
                                  if (state is LoginSuccess) {
                                    PageRouter.pushRemoveUntil(
                                      context,
                                      NavHome(),
                                    );
                                  }
                                },
                                child: BlocBuilder<LoginBloc, LoginState>(
                                  builder: (context, otpRef) {
                                    return SingleChildScrollView(
                                      // Wrap with this
                                      padding: EdgeInsets.only(
                                        bottom:
                                            MediaQuery.of(
                                              context,
                                            ).viewInsets.bottom,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 15.h,
                                          horizontal: 15.w,
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      'Verify Your Number',
                                                      style: TextStyle(
                                                        fontSize: 18.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    if (otpFocus.hasFocus) {
                                                      otpFocus.unfocus();
                                                    }
                                                    Navigator.pop(context);
                                                    otpController.clear();
                                                    phoneController.clear();
                                                    context
                                                        .read<LoginBloc>()
                                                        .add(ResetLogin());
                                                  },
                                                  icon: Icon(Icons.close),
                                                ),
                                              ],
                                            ),
                                            Divider(),
                                            Row(
                                              children: [
                                                Text(
                                                  'Enter the code we\'ve sent by SMS to',
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 8.h,
                                              ),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    phoneController.value.text,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 15.h,
                                              ),
                                              child: Pinput(
                                                controller: otpController,
                                                autofocus: true,
                                                focusNode: otpFocus,
                                                keyboardType:
                                                    TextInputType.number,
                                                onCompleted: (value) {
                                                  context.read<LoginBloc>().add(
                                                    VerifyPhoneOTPEvent(
                                                      phoneNumber:
                                                          phoneController
                                                              .value
                                                              .text
                                                              .toString(),
                                                      otp:
                                                          otpController
                                                              .value
                                                              .text
                                                              .toString(),
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
                                            otpRef is OTPVerificationLoading
                                                ? Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 15.h,
                                                  ),
                                                  child: Indicators(),
                                                )
                                                : Row(
                                                  children: [
                                                    Text(
                                                      'Haven\'t received OTP? ',
                                                    ),
                                                    TextButton(
                                                      onPressed: () {},
                                                      child: Text(
                                                        'Resend OTP',
                                                        style: TextStyle(
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      } else if (loginListenerRef is VerifyOTPFailed ||
                          loginListenerRef is LoginReject) {
                        print('failed');
                      }
                    },
                    child: BlocBuilder<LoginBloc, LoginState>(
                      builder: (context, loginRef) {
                        return loginRef is LoginLoading
                            ? Indicators()
                            : ElevatedButton(
                              onPressed: () {
                                if (phoneValidateKey.currentState!.validate()) {
                                  if (phoneNumberFocus.hasFocus) {
                                    phoneNumberFocus.unfocus();
                                  }

                                  context.read<LoginBloc>().add(
                                    SendOTPEvent(
                                      phoneNumber:
                                          phoneController.value.text.toString(),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                              ),
                              child: const Text('Continue'),
                            );
                      },
                    ),
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
