import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:quickfix_app/app.dart';
import 'package:quickfix_app/helper/constants/constants.dart';
import 'package:quickfix_app/helper/state/state_manager.dart';
import 'package:quickfix_app/screens/network/no_internet.dart';
import 'package:quickfix_app/service/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _controller = Get.put(StateController());

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Quick Fix',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<http.Response>(
        future: APIService().checkInternet(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Splasher();
          } else if (!snapshot.hasData || snapshot.hasError) {
            return const NoInternet();
          }

          final data = snapshot.data;
          if (data != null) {
            final resp = jsonDecode(data.body);
            print("JKD HJS ::: ${resp}");
          }

          return const App();
        },
      ),
    );
  }
}

class Splasher extends StatelessWidget {
  const Splasher({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Constants.primaryColorDark,
      child: Stack(
        children: [
          Center(
            child: SvgPicture.asset(
              "assets/images/splasher_image.svg",
              width: MediaQuery.of(context).size.width * 0.75,
            ),
          ),
        ],
      ),
    );
  }
}
