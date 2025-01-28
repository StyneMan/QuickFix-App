import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickfix_app/helper/constants/constants.dart';

typedef void InitCallback(var value);

class CustomDropdownExpress extends StatefulWidget {
  final InitCallback onSelected;
  final double borderRadius;
  final String placeholder;
  final List<dynamic> items;
  var validator;
  bool isEnabled;
  CustomDropdownExpress({
    Key? key,
    required this.items,
    required this.placeholder,
    this.borderRadius = 8.0,
    required this.onSelected,
    this.validator,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  State<CustomDropdownExpress> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdownExpress> {
  String _hint = "";
  var value;

  @override
  void initState() {
    super.initState();
    setState(() {
      _hint = widget.placeholder;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      hint: Text(
        _hint.capitalize!,
        style: const TextStyle(fontSize: 16, color: Colors.black54),
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 12.0,
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
        hintText: _hint,
        focusColor: Constants.accentColor,
        hintStyle: TextStyle(
          fontFamily: "Inter",
          color: Theme.of(context).colorScheme.tertiary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        // suffixIcon: endIcon,
      ),
      validator: widget.validator,
      items: widget.items.map((e) {
        return DropdownMenuItem(
          value: e,
          child: Text(
            "${e['name']} @ ${e['fee']}% of cost".capitalize!,
            style: const TextStyle(
              fontFamily: "Inter",
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        );
      }).toList(),
      // value: value,
      onChanged: !widget.isEnabled
          ? null
          : (newValue) async {
              widget.onSelected(
                newValue,
              );
              setState(
                () {
                  value = newValue;
                },
              );
            },
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      iconSize: 24,
      isExpanded: true,
    );
  }
}
