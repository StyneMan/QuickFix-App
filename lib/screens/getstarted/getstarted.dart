import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:quickfix_app/helper/state/state_manager.dart';
import 'package:quickfix_app/screens/auth/login/login_screen.dart';
import 'package:quickfix_app/screens/auth/signup/signup_screen.dart';
import 'package:quickfix_app/widgets/button/custombutton.dart';
import 'package:quickfix_app/widgets/text/text_widget.dart';

class GetStarted extends StatelessWidget {
  GetStarted({super.key});

  final _controller = Get.find<StateController>();

  @override
  Widget build(BuildContext context) {
    debugPrint("SETTINGFY ::::${_controller.settings.value}");
    return Scaffold(
      body: Obx(
        () => Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                '${_controller.settings.value['get_started']}',
              ),
              fit: BoxFit.cover,
              onError: (exception, stackTrace) =>
                  const AssetImage("assets/images/getstarted_bg.jpeg"),
              repeat: ImageRepeat.noRepeat,
              alignment: Alignment.center,
            ),
          ),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Color.fromARGB(207, 31, 31, 31),
                ],
                stops: [0.6, 1],
                begin: Alignment.topCenter,
              ),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.50,
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.60,
                          child: TextLarge(
                            text:
                                "${_controller.settings.value['get_started_title'] ?? ""}",
                            color: Colors.white,
                            align: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          height: 18.0,
                        ),
                        CustomButton(
                          bgColor: Colors.white,
                          borderColor: Colors.transparent,
                          foreColor: Colors.black,
                          onPressed: () {
                            Get.to(
                              SignupScreen(),
                              transition: Transition.cupertino,
                            );
                          },
                          variant: "filled",
                          child: const TextMedium(
                            text: "Get Started",
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        TextButton(
                          onPressed: () {
                            Get.to(
                              const LoginScreen(),
                              transition: Transition.cupertino,
                            );
                          },
                          child: const Text(
                            "Log in to your account",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: "BeVietnamPro",
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16.0,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
