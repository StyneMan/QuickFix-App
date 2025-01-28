import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickfix_app/helper/constants/constants.dart';

class ContactItem {
  final String name;
  final Widget icon;
  var action;

  ContactItem({
    required this.name,
    required this.icon,
    required this.action,
  });
}

List<ContactItem> contactItems = [
  ContactItem(
    name: 'Call Us',
    icon: const Icon(
      CupertinoIcons.phone_fill,
      color: Constants.primaryColorDark,
    ),
    action: 'phone call',
  ),
  ContactItem(
    name: 'Chat with us',
    icon: const Icon(
      Icons.mail_rounded,
      color: Constants.primaryColorDark,
    ),
    action: 'email',
  ),
  ContactItem(
    name: 'FAQ’s',
    icon: const Icon(
      CupertinoIcons.question_circle_fill,
      color: Constants.primaryColorDark,
    ),
    action: "https://www.quickpocket.co/faq",
  ),
  ContactItem(
    name: 'Review the App',
    icon: const Icon(
      Icons.message_rounded,
      color: Constants.primaryColorDark,
    ),
    action: "https://www.kewissride.com/faq",
  ),
  ContactItem(
    name: 'Privacy Policy',
    icon: const Icon(
      CupertinoIcons.doc_text_fill,
      color: Constants.primaryColorDark,
    ),
    action: "https://www.quickpocket.co/privacy",
  ),
];
