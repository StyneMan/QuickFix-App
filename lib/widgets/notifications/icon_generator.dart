import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quickfix_app/helper/constants/constants.dart';

class IconGenerator extends StatelessWidget {
  final String value;
  const IconGenerator({
    super.key,
    required this.value,
  });

  // Enum => welcome, profile, next-of-kin, appointment, password-change

  @override
  Widget build(BuildContext context) {
    switch (value) {
      case "welcome":
        return ClipOval(
          child: Image.asset(
            "assets/images/logo_round.png",
            width: 48,
            height: 48,
          ),
        );

      case "profile":
        return ClipOval(
          child: SvgPicture.asset(
            "assets/images/personal.svg",
            width: 48,
            height: 48,
          ),
        );

      case "wallet":
        return ClipOval(
          child: SvgPicture.asset(
            "assets/images/security.svg",
            width: 48,
            height: 48,
          ),
        );

      case "order":
        return ClipOval(
          child: Container(
            width: 48,
            height: 48,
            color: Color.fromARGB(179, 145, 201, 227),
            child: const Center(
              child: Icon(
                CupertinoIcons.bookmark,
                color: Constants.golden,
              ),
            ),
          ),
        );

      case "password-change":
        return ClipOval(
          child: Container(
            width: 48,
            height: 48,
            color: Color.fromARGB(179, 248, 217, 217),
            child: const Center(
              child: Icon(
                CupertinoIcons.lock_shield,
                color: Constants.danger,
              ),
            ),
          ),
        );

      default:
        return ClipOval(
          child: Container(
            width: 48,
            height: 48,
            color: Color.fromARGB(179, 254, 250, 183),
            child: const Center(
              child: Icon(
                CupertinoIcons.star_lefthalf_fill,
                color: Constants.golden,
              ),
            ),
          ),
        );
    }
  }
}
