import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:quickfix_app/helper/constants/constants.dart';
import 'package:quickfix_app/screens/auth/password/new_password.dart';
import 'package:quickfix_app/screens/success/success_screen.dart';
import 'package:quickfix_app/service/api_service.dart';
import 'package:quickfix_app/widgets/button/custombutton.dart';
import 'package:quickfix_app/widgets/text/text_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helper/preference/preference_manager.dart';
import '../../../helper/state/state_manager.dart';

typedef void InitCallback(params);

class VerifyOTP extends StatefulWidget {
  final String caller;
  // final PreferenceManager manager;
  var credential;
  InitCallback? onEntered;
  final String emailAddress;
  String? name, verificationId;
  VerifyOTP({
    Key? key,
    required this.caller,
    // required this.manager,
    this.verificationId,
    this.onEntered,
    this.credential,
    required this.emailAddress,
    this.name,
  }) : super(key: key);

  @override
  State<VerifyOTP> createState() => _State();
}

class _State extends State<VerifyOTP> {
  final _controller = Get.find<StateController>();
  final _otpController = TextEditingController();
  // final _phoneController = TextEditingController();
  PreferenceManager? _manager;
  String _code = '';
  CountdownTimerController? _timerController;
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60 * 1;

  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _manager = PreferenceManager(context);
  }

  _resendCode() async {
    _controller.setLoading(true);
    try {
      Map _payload = {"email_address": widget.emailAddress};
      final resp = await APIService().resendOTP(body: _payload);
      debugPrint("RESEND OTP RESPONSE:: ${resp.body}");
      _controller.setLoading(false);
      if (resp.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(resp.body);
        Constants.toast(map['message']);
      } else {
        Map<String, dynamic> map = jsonDecode(resp.body);
        Constants.toast(map['message']);
      }
    } catch (e) {
      _controller.setLoading(false);
    }
  }

  _verifyCode() async {
    _controller.setLoading(true);
    Map _payload = {
      "code": _otpController.text,
      "email_address": widget.emailAddress
    };
    try {
      final _prefs = await SharedPreferences.getInstance();
      if (widget.caller == "Password") {
        final resp = await APIService().verifyForgotPassOTP(body: _payload);
        _controller.setLoading(false);
        debugPrint("VERIFICATION RESP =>>>> ${resp.body}");

        if (resp.statusCode == 200) {
          Map<String, dynamic> map = jsonDecode(resp.body);
          Constants.toast(map['message']);
          Get.to(
            NewPasswordScreen(
              emailAddress: widget.emailAddress,
            ),
            transition: Transition.cupertino,
          );
        } else {
          _controller.setLoading(false);
          Map<String, dynamic> map = jsonDecode(resp.body);
          Constants.toast(map['message']);
        }
      } else {
        final resp = await APIService().verifyAccount(body: _payload);
        _controller.setLoading(false);
        debugPrint("VERIFICATION RESP =>>>> ${resp.body}");

        if (resp.statusCode >= 200 && resp.statusCode <= 299) {
          Map<String, dynamic> map = jsonDecode(resp.body);
          // widget.manager.saveAccessToken(map['token']);
          _prefs.setString("accessToken", map['accessToken']);
          // _prefs.setString("user", map['user']['user']);
          debugPrint("USER DATA ::: ${map['user']['user']}");
          _controller.setUserData(map['user']['user']);
          Get.to(
            const SuccessScreen(
              caller: "Signup",
            ),
            transition: Transition.cupertino,
          );
        } else {
          _controller.setLoading(false);
          Map<String, dynamic> map = jsonDecode(resp.body);
          Constants.toast(map['message']);
        }
      }
    } catch (e) {
      _controller.setLoading(false);
      debugPrint(e.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timerController?.dispose();
  }

  _pluralizer(num) {
    return num < 10 ? "0$num" : "$num";
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LoadingOverlayPro(
        isLoading: _controller.isLoading.value,
        progressIndicator: const CircularProgressIndicator.adaptive(),
        backgroundColor: Colors.black54,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0.0,
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            leading: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 16.0,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    CupertinoIcons.arrow_left,
                  ),
                ),
                const SizedBox(
                  width: 4.0,
                ),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 21.0,
              horizontal: 32.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      TextLarge(text: "Verify code"),
                      const SizedBox(
                        height: 5.0,
                      ),
                      TextInter(
                        text: "Please enter the code sent to your email",
                        fontSize: 14,
                        color: const Color(0xFF787878),
                      ),
                      TextInter(
                        text: widget.emailAddress,
                        fontSize: 14,
                        color: const Color(0xFF787878),
                      ),
                      const SizedBox(
                        height: 21.0,
                      ),
                      PinCodeTextField(
                        appContext: context,
                        backgroundColor: Colors.white,
                        pastedTextStyle: const TextStyle(
                          color: Constants.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        length: 4,
                        autoFocus: true,
                        obscureText: false,
                        animationType: AnimationType.fade,
                        validator: (v) {
                          if (v!.length < 3) {
                            return "";
                          } else {
                            return null;
                          }
                        },
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderWidth: 0.5,
                          fieldOuterPadding:
                              const EdgeInsets.symmetric(horizontal: 0.0),
                          borderRadius: BorderRadius.circular(8),
                          fieldHeight: 64,
                          fieldWidth: 64,
                          activeFillColor: Colors.white,
                          activeColor: Constants.primaryColor,
                          inactiveColor: Colors.black45,
                        ),
                        cursorColor: Colors.black,
                        animationDuration: Duration(milliseconds: 300),
                        // enableActiveFill: true,
                        // errorAnimationController: errorController,
                        controller: _otpController,
                        keyboardType: TextInputType.number,
                        boxShadows: null,
                        // const [
                        //   BoxShadow(
                        //     offset: Offset(0, 1),
                        //     color: Colors.black12,
                        //     blurRadius: 10,
                        //   )
                        // ],
                        onCompleted: (v) {
                          debugPrint("Completed");
                          setState(() {
                            _isCompleted = true;
                          });
                        },
                        onChanged: (value) {
                          debugPrint(value);
                          if (value.length < 4) {
                            setState(() {
                              _isCompleted = false;
                            });
                          }
                        },
                        beforeTextPaste: (text) {
                          debugPrint("Allowing to paste $text");
                          //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                          //but you can show anything you want here, like your pop up saying wrong paste format or etc
                          return true;
                        },
                        autoDismissKeyboard: true,
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      CountdownTimer(
                        controller: _timerController,
                        endTime: endTime,
                        widgetBuilder: (_, CurrentRemainingTime? time) {
                          if (time == null) {
                            return Column(
                              children: [
                                TextInter(
                                  text: "Didn’t receive OTP?",
                                  fontSize: 14,
                                  align: TextAlign.center,
                                ),
                                InkWell(
                                  onTap: () {
                                    _timerController?.start();
                                    _controller.setLoading(true);
                                    _resendCode();
                                  },
                                  child: TextInter(
                                    text: "Resend code",
                                    fontSize: 16,
                                    align: TextAlign.center,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            );
                          }
                          return TextInter(
                            text:
                                'Resend code in ${_pluralizer(time.min ?? 0) ?? "0"} : ${_pluralizer(time.sec ?? 0)}',
                            fontSize: 15,
                            align: TextAlign.center,
                            color: Constants.primaryColor,
                          );
                        },
                      ),
                      const SizedBox(
                        height: 32.0,
                      ),
                      CustomButton(
                        bgColor: Constants.primaryColor,
                        borderColor: Colors.transparent,
                        foreColor: Colors.white,
                        onPressed: !_isCompleted
                            ? null
                            : () {
                                _verifyCode();
                              },
                        variant: "filled",
                        child: TextInter(
                          text: "Verify",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
