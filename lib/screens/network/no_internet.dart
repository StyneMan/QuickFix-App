import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:quickfix_app/app.dart';
import 'package:quickfix_app/helper/constants/constants.dart';
import 'package:quickfix_app/helper/state/state_manager.dart';
import 'package:quickfix_app/main.dart';

class NoInternet extends StatefulWidget {
  const NoInternet({Key? key}) : super(key: key);

  @override
  State<NoInternet> createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  final _controller = Get.find<StateController>();

  Future<void> _tryConnection() async {
    _controller.setLoading(true);

    try {
      await InternetAddress.lookup('www.google.com');

      _controller.setLoading(false);
      _controller.hasInternetAccess.value = true;
      //Now go to where necessary from here...
      Future.delayed(const Duration(milliseconds: 50), () {
        Get.off(const App(), transition: Transition.cupertino);
      });
    } on SocketException catch (e) {
      _controller.setLoading(false);

      Constants.toast("Check your internet connection.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlayPro(
      isLoading: false,
      progressIndicator: Platform.isAndroid
          ? const CircularProgressIndicator(
              color: Colors.white,
            )
          : const CupertinoActivityIndicator(
              animating: true,
            ),
      backgroundColor: Colors.black54,
      child: Scaffold(
        body: Container(
          color: Colors.white,
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.not_accessible_outlined,
                    color: Constants.primaryColor, size: 48),
                const Text("No internet connection."),
                TextButton.icon(
                  onPressed: () {
                    _tryConnection();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text("Retry"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
