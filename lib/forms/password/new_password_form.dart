import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickfix_app/helper/constants/constants.dart';
import 'package:quickfix_app/helper/state/state_manager.dart';
import 'package:quickfix_app/screens/success/success_screen.dart';
import 'package:quickfix_app/service/api_service.dart';
import 'package:quickfix_app/widgets/button/custombutton.dart';
import 'package:quickfix_app/widgets/inputs/password_field.dart';
import 'package:quickfix_app/widgets/text/text_widget.dart';

class NewPasswordForm extends StatefulWidget {
  final String emailAddress;
  const NewPasswordForm({
    super.key,
    required this.emailAddress,
  });

  @override
  State<NewPasswordForm> createState() => _NewPasswordFormState();
}

class _NewPasswordFormState extends State<NewPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _controller = Get.find<StateController>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  _resetPassword() async {
    try {
      _controller.setLoading(true);
      Map _payload = {
        "new_password": _passwordController.text,
        "confirm_password": _confirmPasswordController.text,
        "email_address": widget.emailAddress,
      };

      final _response = await APIService().resetPass(body: _payload);
      print("RESET PASS RESPONSE :: ::: ${_response.body}");
      _controller.setLoading(false);

      if (_response.statusCode >= 200 && _response.statusCode <= 299) {
        Map<String, dynamic> data = jsonDecode(_response.body);
        Constants.toast('${data['message']}');
        Get.to(
          const SuccessScreen(
            caller: "Password",
          ),
          transition: Transition.cupertino,
        );
      }
    } catch (e) {
      debugPrint("HJEW KJSD SJDK");
      _controller.setLoading(false);
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
              height: 16.0,
            ),
            PasswordField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (_passwordController.text != value) {
                  return 'Password does not match';
                }
              },
              placeholder: "Confirm password",
              controller: _confirmPasswordController,
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
                  _resetPassword();
                }
              },
              variant: "filled",
              child: TextInter(
                text: "Reset Password",
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}
