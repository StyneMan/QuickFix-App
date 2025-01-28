import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:quickfix_app/helper/constants/constants.dart';
import 'package:quickfix_app/screens/auth/login/login_screen.dart';
import 'package:quickfix_app/widgets/button/custombutton.dart';
import 'package:quickfix_app/widgets/dashboard/dashboard.dart';
import 'package:quickfix_app/widgets/text/text_widget.dart';

class SuccessScreen extends StatelessWidget {
  final String caller;
  const SuccessScreen({
    super.key,
    required this.caller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 64,
            ),
            Stack(
              children: [
                Center(
                  child: SvgPicture.asset("assets/images/oval_circ.svg"),
                ),
                Positioned(
                  top: 10,
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: Center(
                    child: Image.asset("assets/images/check_done.png"),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 16.0,
            ),
            TextLarge(
              text: "Successful",
              align: TextAlign.center,
              color: Colors.black,
            ),
            const SizedBox(
              height: 16.0,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              child: TextInter(
                text: caller == "Signup"
                    ? "Congratulations! Your account has successfully been created. Click to continue to dashboard."
                    : "Congratulations! Your password has been changed. Click to continue to login.",
                fontSize: 14,
                align: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 24.0,
            ),
            CustomButton(
              bgColor: Constants.primaryColor,
              borderColor: Colors.transparent,
              foreColor: Colors.white,
              onPressed: () {
                if (caller == "Signup") {
                  // Go to dashboard from here
                  Get.off(
                    const Dashboard(),
                    transition: Transition.cupertino,
                  );
                } else {
                  Get.off(
                    const LoginScreen(),
                    transition: Transition.cupertino,
                  );
                }
              },
              variant: "filled",
              child: TextInter(
                text: "Continue",
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
