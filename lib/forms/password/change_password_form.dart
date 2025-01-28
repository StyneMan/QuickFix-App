import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickfix_app/helper/constants/constants.dart';
import 'package:quickfix_app/helper/state/state_manager.dart';
import 'package:quickfix_app/screens/auth/login/login_screen.dart';
import 'package:quickfix_app/screens/getstarted/getstarted.dart';
import 'package:quickfix_app/service/api_service.dart';
import 'package:quickfix_app/widgets/button/custombutton.dart';
import 'package:quickfix_app/widgets/inputs/password_field.dart';
import 'package:quickfix_app/widgets/text/text_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({super.key});

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _controller = Get.find<StateController>();
  final _currPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  _changePassword() async {
    try {
      _controller.setLoading(true);
      final prefs = await SharedPreferences.getInstance();
      String _token = prefs.getString("accessToken") ?? "";

      Map body = {
        "current_password": _currPasswordController.text,
        "new_password": _newPasswordController.text,
      };

      final resp = await APIService().changePassword(
        body: body,
        accessToken: _token,
      );
      debugPrint("CHANGE PASSWORD RESPONSE ::: ${resp.body}");
      _controller.setLoading(false);
      if (resp.statusCode >= 200 && resp.statusCode <= 299) {
        Map<String, dynamic> map = jsonDecode(resp.body);
        Constants.toast(map['message']);

        // now log this person out
        Future.delayed(const Duration(seconds: 1), () {
          prefs.clear();
          Get.offAll(
            const LoginScreen(
              hideBackBtn: true,
            ),
            transition: Transition.cupertino,
          );
        });
      } else {
        Map<String, dynamic> err = jsonDecode(resp.body);
        Constants.toast(err['message']);
      }
    } catch (e) {
      _controller.setLoading(false);
      debugPrint("HJEW KJSD SJDK");
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
                  return 'enter current password';
                }
              },
              placeholder: "Current Password",
              controller: _currPasswordController,
              onChanged: (e) => {},
            ),
            const SizedBox(
              height: 16.0,
            ),
            PasswordField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter new password';
                }
              },
              placeholder: "New Password",
              controller: _newPasswordController,
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
                  _changePassword();
                }
              },
              variant: "filled",
              child: TextInter(
                text: "Change Password",
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
