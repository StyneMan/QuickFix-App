import 'package:flutter/material.dart';
import 'package:quickfix_app/helper/constants/constants.dart';

class CustomTextField extends StatelessWidget {
  final String? labelText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  final TextInputType inputType;
  final TextCapitalization capitalization;
  final bool? isEnabled;
  var validator;
  final double borderRadius;
  final Widget endIcon;
  final String? placeholder;
  final FocusNode? focusNode;

  CustomTextField({
    Key? key,
    this.labelText,
    this.icon = Icons.person,
    this.isEnabled = true,
    this.capitalization = TextCapitalization.none,
    required this.onChanged,
    required this.controller,
    required this.validator,
    required this.inputType,
    this.borderRadius = 12.0,
    this.endIcon = const SizedBox(),
    this.placeholder = "",
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      cursorColor: Constants.primaryColor,
      controller: controller,
      validator: validator,
      maxLength: labelText == "Phone" ? 11 : null,
      enabled: isEnabled,
      focusNode: focusNode,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 12.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
          borderSide:
              const BorderSide(color: Constants.primaryColor, strokeAlign: 1.0),
          gapPadding: 4.0,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
          borderSide:
              const BorderSide(color: Constants.primaryColor, strokeAlign: 0.5),
          gapPadding: 4.0,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
          borderSide:
              const BorderSide(color: Constants.primaryColor, strokeAlign: 1.0),
          gapPadding: 4.0,
        ),
        filled: false,
        hintText: placeholder,
        focusColor: Constants.accentColor,
        hintStyle: const TextStyle(
          fontFamily: "Inter",
          color: Colors.black38,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        suffixIcon: endIcon,
      ),
      keyboardType: inputType,
      textCapitalization: capitalization,
    );
  }
}
