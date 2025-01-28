import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickfix_app/helper/constants/constants.dart';
import 'package:quickfix_app/helper/state/state_manager.dart';
import 'package:quickfix_app/screens/auth/login/login_screen.dart';
import 'package:quickfix_app/screens/auth/otp/verifyotp.dart';
import 'package:quickfix_app/service/api_service.dart';
import 'package:quickfix_app/widgets/button/custombutton.dart';
import 'package:quickfix_app/widgets/inputs/custom_text_field.dart';
import 'package:quickfix_app/widgets/text/text_widget.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _controller = Get.find<StateController>();
  final _emailController = TextEditingController();

  _sendCode() async {
    try {
      _controller.setLoading(true);
      Map _body = {"email_address": _emailController.text.trim()};

      final _response = await APIService().forgotPass(_body);
      _controller.setLoading(false);
      debugPrint("FORGOT PASSWORD RESPONSE :::  ${_response.body}");
      if (_response.statusCode >= 200 || _response.statusCode <= 299) {
        Map<String, dynamic> data = jsonDecode(_response.body);
        Constants.toast(data['message']);
        Get.to(
          VerifyOTP(
            emailAddress: _emailController.text,
            caller: "Password",
          ),
          transition: Transition.cupertino,
        );
      } else {
        Map<String, dynamic> error = jsonDecode(_response.body);
        Constants.toast(error['message'] ?? "Operation failed");
      }
    } catch (e) {
      _controller.setLoading(false);
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextField(
              placeholder: "Enter email",
              onChanged: (val) {},
              controller: _emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email or phone';
                }
                if (!RegExp('^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]')
                    .hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
              inputType: TextInputType.emailAddress,
            ),
            const SizedBox(
              height: 21.0,
            ),
            CustomButton(
              bgColor: Constants.primaryColor,
              borderColor: Colors.transparent,
              foreColor: Colors.white,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _sendCode();
                }
              },
              variant: "filled",
              child: TextInter(
                text: "Request Password Reset",
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextInter(
                  text: "You remember your password?",
                  fontSize: 15,
                  color: Colors.black,
                ),
                TextButton(
                  onPressed: () {
                    Get.to(
                      const LoginScreen(),
                      transition: Transition.cupertino,
                    );
                  },
                  child: const Text(
                    "Log In",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Constants.primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Inter",
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
