import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickfix_app/helper/constants/constants.dart';

import '../country_picker.dart';

typedef OnSelect(Map<String, dynamic> item);

class CustomPhoneField extends StatefulWidget {
  final String? labelText;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  final TextInputType inputType;
  final TextCapitalization capitalization;
  final bool? isEnabled;
  var validator;
  final double borderRadius;
  final String? placeholder;
  final FocusNode? focusNode;
  final OnSelect onSelected;

  CustomPhoneField({
    Key? key,
    this.labelText,
    this.isEnabled = true,
    this.capitalization = TextCapitalization.none,
    required this.onChanged,
    required this.controller,
    required this.validator,
    required this.inputType,
    required this.onSelected,
    this.borderRadius = 8.0,
    this.placeholder = "",
    this.focusNode,
  }) : super(key: key);

  @override
  State<CustomPhoneField> createState() => _CustomPhoneFieldState();
}

class _CustomPhoneFieldState extends State<CustomPhoneField> {
  String _countryCode = "+234";
  Map<String, dynamic> _selectedCountry = {
    "name": "Nigeria",
    "flag": "🇳🇬",
    "code": "NG",
    "dial_code": "+234"
  };

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: widget.onChanged,
      cursorColor: Constants.primaryColor,
      controller: widget.controller,
      validator: widget.validator,
      maxLength: 11,
      enabled: widget.isEnabled,
      focusNode: widget.focusNode,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 0.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(widget.borderRadius),
          ),
          borderSide: const BorderSide(color: Colors.grey, strokeAlign: 1.0),
          gapPadding: 4.0,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(widget.borderRadius),
          ),
          borderSide: const BorderSide(color: Colors.grey, strokeAlign: 0.5),
          gapPadding: 4.0,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(widget.borderRadius),
          ),
          borderSide: const BorderSide(color: Colors.grey, strokeAlign: 1.0),
          gapPadding: 4.0,
        ),
        filled: false,
        hintText: " 8012345678",
        focusColor: Constants.accentColor,
        hintStyle: const TextStyle(
          fontFamily: "Inter",
          color: Colors.black38,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        counterText: null,
        counter: const SizedBox(),
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisSize:
                MainAxisSize.min, // Make sure it doesn't take up too much space
            children: [
              IconButton(
                onPressed: () {
                  Constants.showBottomSheet(
                    context: context,
                    child: CountryPicker(
                      onSelected: (item) {
                        print("SELECTED COUNTRY INFO ::: $item");
                        setState(() {
                          _selectedCountry = item;
                        });
                      },
                    ),
                    title: "Countries",
                  );
                },
                icon: ClipOval(
                  child: Text(
                    '${_selectedCountry['flag']}',
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 16,
                color: Colors.grey,
              ),
              Container(
                height: 22,
                padding: const EdgeInsets.all(6.0),
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      keyboardType: widget.inputType,
      textCapitalization: widget.capitalization,
    );
  }
}
