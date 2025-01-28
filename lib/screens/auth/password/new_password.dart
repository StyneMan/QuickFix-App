import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:quickfix_app/forms/password/new_password_form.dart';
import 'package:quickfix_app/helper/state/state_manager.dart';
import 'package:quickfix_app/widgets/text/text_widget.dart';

class NewPasswordScreen extends StatelessWidget {
  final String emailAddress;
  NewPasswordScreen({
    super.key,
    required this.emailAddress,
  });

  final _controller = Get.find<StateController>();

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
                      TextLarge(text: "Create new password"),
                      const SizedBox(
                        height: 5.0,
                      ),
                      TextInter(
                        text: "Set your new password so you can login",
                        fontSize: 14,
                        color: const Color(0xFF787878),
                      ),
                      TextInter(
                        text: "and access your account.",
                        fontSize: 14,
                        color: const Color(0xFF787878),
                      ),
                      const SizedBox(
                        height: 21.0,
                      ),
                      NewPasswordForm(
                        emailAddress: emailAddress,
                      )
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
