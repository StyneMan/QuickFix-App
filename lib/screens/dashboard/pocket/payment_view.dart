import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickfix_app/helper/state/payment_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentView extends GetView<PaymentController> {
  const PaymentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebViewWidget(controller: controller.webviewController),
      ),
    );
  }
}
