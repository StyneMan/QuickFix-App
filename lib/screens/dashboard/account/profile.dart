import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:quickfix_app/forms/profile/profile_form.dart';
import 'package:quickfix_app/helper/state/state_manager.dart';
import 'package:quickfix_app/screens/dashboard/home/home.dart';
import 'package:quickfix_app/widgets/text/text_widget.dart';

class ProfileScreen extends StatelessWidget {
  final bool isDirect;
  ProfileScreen({
    super.key,
    this.isDirect = false,
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
                  width: 2.0,
                ),
                IconButton(
                  onPressed: () {
                    if (isDirect) {
                      Get.off(
                        Home(),
                        transition: Transition.cupertino,
                      );
                    } else {
                      Get.back();
                    }
                  },
                  icon: const Icon(
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
              TextLarge(text: "Profile"),
              const SizedBox(
                height: 5.0,
              ),
              TextInter(
                text: "Personal bio-data and general information",
                fontSize: 14,
                color: const Color(0xFF787878),
              ),
              const SizedBox(
                height: 32.0,
              ),
              const ProfileForm()
            ],
          ),
        ),
      ),
    );
  }
}
