import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:quickfix_app/helper/state/state_manager.dart';
import 'package:quickfix_app/screens/auth/login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import '../../util/preference_manager.dart';

class MyApiInterceptor implements InterceptorContract {
  // late PreferenceManager manager;

  final _controller = Get.find<StateController>();

  @override
  Future<BaseRequest> interceptRequest({
    required BaseRequest request,
  }) async {
    print('----- Request -----');
    print(request.toString());
    print(request.headers.toString());

    try {
      final cache = await SharedPreferences.getInstance();

      request.headers[HttpHeaders.contentTypeHeader] = "application/json";
      request.headers[HttpHeaders.authorizationHeader] =
          "Bearer " + cache.getString("accessToken")!;
    } on SocketException catch (_) {
      _controller.isLoading.value = false;
      Fluttertoast.showToast(
        msg: "Check your internet connection!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.grey[800],
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      _controller.setLoading(false);
      print(e);
    }
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
  }) async {
    print("INTERCEPTOR PART ${response.statusCode}");
    final _pref = await SharedPreferences.getInstance();
    int reloadCounter = _pref.getInt("authCounts") ?? 0;

    if (response.statusCode == 401 && reloadCounter < 2) {
      debugPrint("LOG THIS USER OUT. SESSION EXPIRED!!!");
      //Clear prefeence

      _pref.clear();
      _pref.setInt("authCounts", (reloadCounter + 1));
      Get.offAll(const LoginScreen());
    }

    return response;
  }

  @override
  FutureOr<bool> shouldInterceptRequest() {
    return false;
  }

  @override
  FutureOr<bool> shouldInterceptResponse() {
    return true;
  }
}
