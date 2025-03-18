import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:get/get.dart';
import 'package:quickfix_app/helper/constants/constants.dart';
import 'package:quickfix_app/helper/state/state_manager.dart';
import 'package:quickfix_app/screens/auth/login/login_screen.dart';
import 'package:quickfix_app/screens/auth/otp/verifyotp.dart';
import 'package:quickfix_app/service/api_service.dart';
import 'package:quickfix_app/widgets/button/custombutton.dart';
import 'package:quickfix_app/widgets/inputs/custom_phone_field.dart';
import 'package:quickfix_app/widgets/inputs/custom_text_field.dart';
import 'package:quickfix_app/widgets/inputs/password_field.dart';
import 'package:quickfix_app/widgets/text/text_widget.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _controller = Get.find<StateController>();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _acceptedTerms = false;
  String _countryCode = "NG";

  bool _isNumberOk = false,
      _isLowercaseOk = false,
      _isCapitalOk = false,
      _isSpecialCharOk = false;

  _signup() async {
    try {
      _controller.setLoading(true);
      final codeResp = await parse(
        _phoneController.text,
        region: _countryCode,
      );
      debugPrint("UEIWD ::: $codeResp");
      Map _payload = {
        "first_name": _firstnameController.text.trim(),
        "last_name": _lastnameController.text.trim(),
        "email_address": _emailController.text.trim(),
        "password": _passwordController.text,
        "phone_number": "${codeResp['national_number']}",
        "dial_code": _countryCode,
        "international_phone_format": "${codeResp['e164']}",
      };
      final response = await APIService().signup(_payload);
      print("SIGNUP RESPONSE HRE ::: ${response.body}");
      Map<String, dynamic> data = jsonDecode(response.body);
      _controller.setLoading(false);
      Constants.toast(data['message']);
      if (response.statusCode >= 200 &&
          response.statusCode <= 299 &&
          !data['message'].toString().contains("exist")) {
        // Now route to verify OTP screen
        Get.to(
          VerifyOTP(caller: "Signup", emailAddress: _emailController.text),
          transition: Transition.cupertino,
        );
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: CustomTextField(
                    placeholder: "John",
                    onChanged: (val) {},
                    controller: _firstnameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your first name';
                      }
                      return null;
                    },
                    inputType: TextInputType.name,
                    capitalization: TextCapitalization.words,
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: CustomTextField(
                    placeholder: "Doe",
                    onChanged: (val) {},
                    controller: _lastnameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'enter your last name';
                      }
                      return null;
                    },
                    inputType: TextInputType.name,
                    capitalization: TextCapitalization.words,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16.0,
            ),
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
            CustomPhoneField(
              placeholder: "Enter phone number",
              onChanged: (val) {},
              controller: _phoneController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email or phone';
                }
                return null;
              },
              onSelected: (item) {
                setState(() {
                  _countryCode = item['code'];
                });
              },
              inputType: TextInputType.number,
            ),
            const SizedBox(
              height: 16.0,
            ),
            PasswordField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please type password';
                }
                if (value.toString().length < 8) {
                  return "Password must be at least 8 characters!";
                }
                if (_passwordController.text != value) {
                  return "Password does not match";
                }
                if (!_isNumberOk ||
                    !_isCapitalOk ||
                    !_isLowercaseOk ||
                    !_isSpecialCharOk) {
                  return 'Weak password. See hint below';
                }
                return null;
              },
              controller: _passwordController,
              onChanged: (value) {
                if (value.contains(RegExp(r'[0-9]'))) {
                  setState(() {
                    _isNumberOk = true;
                  });
                } else {
                  setState(() {
                    _isNumberOk = false;
                  });
                }

                if (value.contains(RegExp(r'[A-Z]'))) {
                  setState(() {
                    _isCapitalOk = true;
                  });
                } else {
                  setState(() {
                    _isCapitalOk = false;
                  });
                }

                if (value.contains(RegExp(r'[a-z]'))) {
                  setState(() {
                    _isLowercaseOk = true;
                  });
                } else {
                  setState(() {
                    _isLowercaseOk = false;
                  });
                }

                if (value.contains(RegExp(r'[!@#$%^&*(),.?"_:;{}|<>/+=-]'))) {
                  setState(() {
                    _isSpecialCharOk = true;
                  });
                } else {
                  setState(() {
                    _isSpecialCharOk = false;
                  });
                }
              },
            ),
            const SizedBox(
              height: 3.0,
            ),
            RichText(
              text: TextSpan(
                text: "Use at least one ",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: 12,
                ),
                children: [
                  const TextSpan(
                    text: "uppercase",
                    style: TextStyle(
                      color: Constants.primaryColor,
                    ),
                  ),
                  TextSpan(
                    text: ", one ",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  const TextSpan(
                    text: "lowercase",
                    style: TextStyle(
                      color: Constants.primaryColor,
                    ),
                  ),
                  TextSpan(
                    text: ", one ",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  const TextSpan(
                    text: "numeric digit",
                    style: TextStyle(
                      color: Constants.primaryColor,
                    ),
                  ),
                  TextSpan(
                    text: " and one ",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  const TextSpan(
                    text: "special character",
                    style: TextStyle(
                      color: Constants.primaryColor,
                    ),
                  ),
                  TextSpan(
                    text: ". ",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Checkbox.adaptive(
                  value: _acceptedTerms,
                  onChanged: (e) {
                    setState(() {
                      _acceptedTerms = !_acceptedTerms;
                    });
                  },
                ),
                RichText(
                  text: const TextSpan(
                    text: "I agree to the ",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: "Terms & Conditions",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 21.0,
            ),
            CustomButton(
              bgColor: Constants.primaryColor,
              borderColor: Colors.transparent,
              foreColor: Colors.white,
              onPressed: !_acceptedTerms
                  ? null
                  : () {
                      if (_formKey.currentState!.validate()) {
                        _signup();
                      }
                    },
              variant: "filled",
              child: TextInter(
                text: "Create Account",
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
                  const LoginScreen(),
                  transition: Transition.cupertino,
                );
              },
              child: RichText(
                text: const TextSpan(
                  text: "Already have an account?",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: " Log In",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Constants.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
