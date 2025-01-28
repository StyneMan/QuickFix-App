import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:quickfix_app/forms/nextofkin/next_of_kin_form.dart';
import 'package:quickfix_app/helper/state/state_manager.dart';
import 'package:quickfix_app/widgets/text/text_widget.dart';

class NextOfKinScreen extends StatelessWidget {
  NextOfKinScreen({super.key});

  final _controller = Get.find<StateController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LoadingOverlayPro(
        isLoading: _controller.isLoading.value,
        progressIndicator: const CircularProgressIndicator.adaptive(),
        backgroundColor: Colors.black54,
        child: Scaffold(
          backgroundColor: const Color(0xFFFCFBFB),
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
            centerTitle: true,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const SizedBox(
                height: 16.0,
              ),
              TextLarge(text: "Next of Kin"),
              const SizedBox(
                height: 5.0,
              ),
              TextInter(
                text:
                    "The person you choose should be a close relative and someone you trust.",
                fontSize: 14,
                color: const Color(0xFF787878),
              ),
              const SizedBox(
                height: 32.0,
              ),
              const NextOfKinForm()
            ],
          ),
        ),
      ),
    );
  }
}
