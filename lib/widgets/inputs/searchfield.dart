import 'package:flutter/material.dart';
import 'package:quickfix_app/helper/constants/constants.dart';

class SearchField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final double borderRadius;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  final TextInputType inputType;
  final TextCapitalization capitalization;
  final bool? isEnabled;
  var validator;

  SearchField({
    Key? key,
    required this.hintText,
    this.icon = Icons.person,
    this.isEnabled = true,
    this.borderRadius = 8.0,
    this.capitalization = TextCapitalization.none,
    required this.onChanged,
    required this.controller,
    required this.validator,
    required this.inputType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      cursorColor: Constants.primaryColor,
      controller: controller,
      validator: validator,
      enabled: isEnabled,
      decoration: InputDecoration(
        // prefixIcon: const Icon(CupertinoIcons.search),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
          borderSide: BorderSide(color: Colors.grey, strokeAlign: 1.0),
          gapPadding: 4.0,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
          borderSide: BorderSide(color: Colors.grey, strokeAlign: 1.0),
          gapPadding: 4.0,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
          borderSide: BorderSide(color: Colors.grey, strokeAlign: 1.0),
          gapPadding: 4.0,
        ),
        filled: false,
        hintText: hintText,
        focusColor: Constants.accentColor,
        hintStyle: const TextStyle(
          fontFamily: "Inter",
          color: Colors.black38,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ), // border: InputBorder.none,
      ),
      keyboardType: inputType,
      textCapitalization: capitalization,
    );
  }
}
