import 'package:flutter/material.dart';
import 'package:quickfix_app/screens/getstarted/getstarted.dart';
import 'package:quickfix_app/widgets/dashboard/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool _authenticated = false;

  Future<bool> isLoggedIn() async {
    try {
      final _prefs = await SharedPreferences.getInstance();
      String token = _prefs.getString("accessToken") ?? '';
      if (token.isNotEmpty) {
        setState(() {
          _authenticated = true;
        });
        return true;
      }
      return false;
    } catch (e) {
      setState(() {
        _authenticated = false;
      });
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    isLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    if (_authenticated) {
      return Dashboard();
    }
    return GetStarted();
  }
}
