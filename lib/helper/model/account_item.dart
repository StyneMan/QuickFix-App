import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quickfix_app/helper/constants/constants.dart';
import 'package:quickfix_app/screens/dashboard/account/change_password.dart';
import 'package:quickfix_app/screens/dashboard/account/next_of_kin.dart';
import 'package:quickfix_app/screens/dashboard/account/profile.dart';
import 'package:quickfix_app/screens/dashboard/contactus/contactus.dart';

class AccountItem {
  final String name;
  final Widget icon;
  final Widget child;

  AccountItem({
    required this.name,
    required this.icon,
    required this.child,
  });
}

List accountItems = [
  AccountItem(
    name: 'Personal Data',
    icon: SvgPicture.asset(
      "assets/images/ic_account.svg",
    ),
    child: ProfileScreen(),
  ),
  AccountItem(
    name: 'Support',
    icon: SvgPicture.asset(
      "assets/images/support.svg",
    ),
    child: ContactUs(),
  ),
  AccountItem(
    name: 'Security',
    icon: SvgPicture.asset(
      "assets/images/security.svg",
    ),
    child: ChangePasswordScreen(),
  ),
  AccountItem(
    name: 'Log Out',
    icon: SvgPicture.asset(
      "assets/images/logout.svg",
      width: 20,
    ),
    child: const SizedBox(),
  ),
  AccountItem(
    name: 'Delete Account',
    icon: SvgPicture.asset(
      "assets/images/delete_acc.svg",
    ),
    child: const SizedBox(),
  ),
];
