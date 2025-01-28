import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickfix_app/helper/constants/constants.dart';
import 'package:quickfix_app/helper/state/state_manager.dart';
import 'package:quickfix_app/screens/auth/otp/verifyotp.dart';
import 'package:quickfix_app/screens/auth/password/forgot_password.dart';
import 'package:quickfix_app/service/api_service.dart';
import 'package:quickfix_app/widgets/button/custombutton.dart';
import 'package:quickfix_app/widgets/dashboard/dashboard.dart';
import 'package:quickfix_app/widgets/inputs/custom_text_field.dart';
import 'package:quickfix_app/widgets/inputs/password_field.dart';
import 'package:quickfix_app/widgets/text/text_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _controller = Get.find<StateController>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  _login() async {
    try {
      final _prefs = await SharedPreferences.getInstance();
      _controller.setLoading(true);
      Map payload = {
        "email_address": _emailController.text.trim(),
        "password": _passwordController.text,
      };

      final resp = await APIService().login(payload);
      print("LOGIN RESPONSE ::: ${resp.body}");
      _controller.setLoading(false);
      if (resp.statusCode >= 200 && resp.statusCode <= 299) {
        Map<String, dynamic> map = jsonDecode(resp.body);
        Constants.toast(map['message']);

        if (map['message'].toString().contains("OTP email sent")) {
          Get.to(
            VerifyOTP(
              caller: "Signup",
              emailAddress: _emailController.text.trim(),
            ),
            transition: Transition.cupertino,
          );
        } else {
          _prefs.setString("accessToken", map['accessToken']);
          _controller.setUserData(map['user']);
          Get.to(const Dashboard(), transition: Transition.cupertino);
        }
      } else {
        Map<String, dynamic> error = jsonDecode(resp.body);
        Constants.toast(error['message']);
      }
    } catch (e) {
      _controller.setLoading(false);
      print(e.toString());
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
              height: 16.0,
            ),
            PasswordField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
              },
              controller: _passwordController,
              onChanged: (e) => {},
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
                  _login();
                }
              },
              variant: "filled",
              child: TextInter(
                text: "Log In",
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            TextButton(
              onPressed: () {
                Get.to(
                  ForgotPasswordScreen(),
                  transition: Transition.cupertino,
                );
              },
              child: const Text(
                "Forgot Password?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: "BeVietnamPro",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
