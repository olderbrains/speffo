import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class _LoginMainViewState extends State<LoginMainView>
    with TickerProviderStateMixin {
  var phoneController = TextEditingController();

  var phoneNumberFocus = FocusNode();
  GlobalKey<FormState> phoneValidateKey = GlobalKey<FormState>();
  final countryPicker = FlCountryCodePicker(favorites: ['+91', 'IN']);

  var countryListener = ValueNotifier("India (+91)");
  ValueNotifier<bool> isFocused = ValueNotifier<bool>(false);

  CountryCode? countryCode;

  @override
  void initState() {
    super.initState();
    phoneNumberFocus.addListener(_updateFocusState);
  }

  void _updateFocusState() {
    isFocused.value = phoneNumberFocus.hasFocus;
  }

  @override
  void dispose() {
    super.dispose();
    phoneNumberFocus.removeListener(_updateFocusState);
    isFocused.dispose();
    phoneController.dispose();
    countryListener.dispose();
    phoneNumberFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(elevation: 0, backgroundColor: Colors.white),
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
                        'Continue with number',
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'May your need, Wherever You Go',
                      style: TextTheme.of(context).bodyMedium!.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Center(
                  child: ValueListenableBuilder<bool>(
                    valueListenable: isFocused,
                    builder: (context, value, child) {
                      return AnimatedSize(
                        clipBehavior: Clip.none,
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeInOut,
                        child:
                            value
                                ? Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12.h),
                                  child: Image.asset(
                                    'assets/logo/logo.png',
                                    fit: BoxFit.contain,
                                    height: 70.h,
                                  ),
                                )
                                : Image.asset(
                                  'assets/media/loginHead.png',
                                  fit: BoxFit.contain,
                                  height: 250.h,
                                ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
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
                              mainAxisAlignment: MainAxisAlignment.start,
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
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: false,
                            signed: false,
                          ),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.black54),
                            hintText: 'Phone Number',
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
                                    if (phoneController.value.text.isEmpty) {
                                      phoneNumberFocus.unfocus();
                                      HapticFeedback.lightImpact();

                                      FlashAlert.show(
                                        message: "Phone number is required!",
                                        type: FlashAlertType.error,
                                      );
                                    } else if (phoneController
                                            .value
                                            .text
                                            .length !=
                                        10) {
                                      phoneNumberFocus.unfocus();
                                      HapticFeedback.lightImpact();


                                      FlashAlert.show(
                                        message:
                                            "Phone number not looking right!",
                                        type: FlashAlertType.error,
                                      );
                                    } else {
                                      phoneNumberFocus.unfocus();

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
                          message: "OTP sent failed please try again",
                          type: FlashAlertType.warning,
                        );
                      }
                    },
                  ),
                ),
                SizedBox(height: 25.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
