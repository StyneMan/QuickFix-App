import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickfix_app/helper/constants/constants.dart';

typedef InitCallback();

class PasswordField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  final double borderRadius;
  final validator;
  final String? placeholder;

  const PasswordField({
    super.key,
    required this.validator,
    required this.controller,
    required this.onChanged,
    this.placeholder,
    this.borderRadius = 8.0,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  _togglePass() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: _obscureText,
      onChanged: widget.onChanged,
      cursorColor: Constants.primaryColor,
      controller: widget.controller,
      validator: widget.validator,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(widget.borderRadius),
          ),
          borderSide: BorderSide(color: Colors.grey, strokeAlign: 0.5),
          gapPadding: 1.0,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(widget.borderRadius),
          ),
          borderSide: BorderSide(color: Colors.grey, strokeAlign: 0.5),
          gapPadding: 1.0,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(widget.borderRadius),
          ),
          borderSide: BorderSide(color: Colors.grey, strokeAlign: 0.5),
          gapPadding: 1.0,
        ),
        filled: false,
        focusColor: Constants.accentColor,
        hintStyle: const TextStyle(
          fontFamily: "Poppins",
          fontWeight: FontWeight.w400,
          color: Colors.black54,
          fontSize: 14,
        ),
        labelStyle: const TextStyle(
            fontFamily: "Poppins", fontWeight: FontWeight.w400, fontSize: 16),
        isDense: true,
        hintText: widget.placeholder ?? "Password",
        suffixIcon: InkWell(
          onTap: () => _togglePass(),
          child: Icon(
            _obscureText ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
            color: Colors.black54,
          ),
        ),
        suffixStyle: const TextStyle(
          color: Colors.black54,
        ),
      ),
    );
  }
}
