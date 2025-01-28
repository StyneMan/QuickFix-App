import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:quickfix_app/service/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'state_manager.dart';

class PaymentController extends GetxController {
  var isLoading = false.obs;
  final _controller = Get.find<StateController>();
  var data = Get.arguments['data'];

  final DateTime pageStartTime = DateTime.now();

  late WebViewController webviewController;

  _initWebview() {
    print("ENCODED DATA PAYCONTROLLER ==>> $data");

    webviewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(NavigationDelegate(
          onPageStarted: (String url) {
            // Set loading here
            _controller.setLoading(true);
            // Initiatw Transaction Here
            // if (Get.arguments['usecase'] == "buy-voucher") {
            //   _initiateVoucher(
            //     payload: Get.arguments['payload'],
            //     accessToken: Get.arguments['accessToken'],
            //     manager: Get.arguments['manager'],
            //     customerRef: Get.arguments['customerRef'],
            //   );
            // }
          },
          onPageFinished: (String url) {
            // Get.back();
            _controller.setLoading(false);
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) async {
            final DateTime pageStartTime = DateTime.now();

            print("REQUEST URL NOW ==>>> ${request.url}");

            if (request.url.startsWith(
                'https://quick-fix-api.vercel.app/paystack/callback_success')) {
              // Update User profile here and Exit
              _controller.setLoading(true);
              final prefs = await SharedPreferences.getInstance();
              String _token = prefs.getString("accessToken") ?? "";

              final usrResp =
                  await APIService().getProfile(accessToken: _token);
              debugPrint(" USER PROFILE STATECONTO ${usrResp.body}");
              if (usrResp.statusCode >= 200 && usrResp.statusCode <= 299) {
                Map<String, dynamic> usrMap = jsonDecode(usrResp.body);
                debugPrint("USER MAP KELO :: $usrMap");
                _controller.userData.value = usrMap['user:'];
                Get.back();
              } else {
                Get.back();
              }
            }

            return NavigationDecision.navigate;
          }))
      ..loadRequest(
        Uri.parse(
          Get.arguments['auth_url'],
        ),
      );
  }

  @override
  void onInit() {
    _initWebview();
    Duration durationOnPage = DateTime.now().difference(pageStartTime);
    super.onInit();
  }

  @override
  void onClose() {
    Duration durationOnPage = DateTime.now().difference(pageStartTime);
    super.onClose();
  }
}
