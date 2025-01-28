import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:quickfix_app/forms/login/login_form.dart';
import 'package:quickfix_app/helper/constants/constants.dart';
import 'package:quickfix_app/helper/state/state_manager.dart';
import 'package:quickfix_app/screens/auth/signup/signup_screen.dart';
import 'package:quickfix_app/widgets/text/text_widget.dart';

class LoginScreen extends StatefulWidget {
  final bool hideBackBtn;
  const LoginScreen({super.key, this.hideBackBtn = false});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _controller = Get.find<StateController>();

  // final socket = SocketManager().socket;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LoadingOverlayPro(
        isLoading: _controller.isLoading.value,
        progressIndicator: const CircularProgressIndicator.adaptive(),
        backgroundColor: Colors.black54,
        child: Scaffold(
          backgroundColor: Constants.bgColor,
          appBar: AppBar(
            elevation: 0.0,
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            leading: widget.hideBackBtn
                ? const SizedBox()
                : Row(
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
              horizontal: 24.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      TextLarge(text: "Welcome back,"),
                      const SizedBox(
                        height: 5.0,
                      ),
                      TextInter(
                        text: "We’re happy to see you here again, ",
                        fontSize: 14,
                        color: const Color(0xFF787878),
                      ),
                      TextInter(
                        text: "Enter your email and password.",
                        fontSize: 14,
                        color: const Color(0xFF787878),
                      ),
                      const SizedBox(
                        height: 48.0,
                      ),
                      const LoginForm()
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextInter(
                      text: "Don't have an account?",
                      fontSize: 16,
                      align: TextAlign.center,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: InkWell(
                        onTap: () {
                          Get.to(
                            SignupScreen(),
                            transition: Transition.cupertino,
                          );
                        },
                        child: const Text(
                          "Create an account",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Constants.primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: "BeVietnamPro",
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
