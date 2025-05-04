import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speffo/Helper/api_url.dart';
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
  final countryPicker = FlCountryCodePicker(favorites: ['+91', 'IN']);

  var countryListener = ValueNotifier("India (+91)");

  CountryCode? countryCode;

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
    countryListener.dispose();
    phoneNumberFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: 50.h,
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
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Row(
                    children: [
                      Text(
                        'Welcome to ',
                        style: TextStyle(
                          fontSize: 18.sp,
                        ),
                      ), Text(
                        Constants.appName,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
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
                      GestureDetector(
                        onTap: () async {
                          countryCode = await countryPicker.showPicker(
                            context: context,
                            pickerMaxHeight:
                                MediaQuery.of(context).size.height / 1.2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15.r),
                                topLeft: Radius.circular(15.r),
                              ),
                            ),
                          );
                          if (countryCode != null) {
                            countryListener.value =
                                '${countryCode!.name} (${countryCode!.dialCode})';
                          }
                        },
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ValueListenableBuilder(
                                  valueListenable: countryListener,
                                  builder:
                                      (context, value, child) => Text(
                                        value,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                ),
                                Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(thickness: 1, color: Colors.black45),
                      Form(
                        key: phoneValidateKey,
                        child: TextFormField(
                          controller: phoneController,
                          textInputAction: TextInputAction.done,
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
                                          countryCode:
                                              countryCode?.code ?? '+91',
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
                            countryCode: '+91',
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
                SizedBox(height: 12.h),
                _buildSocialButton('Continue with Apple', Icons.apple),
                SizedBox(height: 12.h),
                _buildSocialButton('Continue with Google', Icons.gpp_maybe),
                SizedBox(height: 12.h),
                _buildSocialButton('Continue with Facebook', Icons.facebook),
                SizedBox(height: 25.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(String text, IconData icon) {
    return OutlinedButton(
      onPressed: () {
        phoneNumberFocus.unfocus();
      },
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
