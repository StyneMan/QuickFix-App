import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickfix_app/helper/constants/constants.dart';

typedef void InitCallback(String rawDate, String date);

class CustomDateField extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final InitCallback onDateSelected;
  final TextEditingController controller;
  final TextCapitalization capitalization;
  final bool? isEnabled;

  CustomDateField({
    Key? key,
    required this.hintText,
    this.icon = Icons.person,
    this.isEnabled = true,
    required this.onDateSelected,
    this.capitalization = TextCapitalization.none,
    required this.controller,
  }) : super(key: key);

  @override
  State<CustomDateField> createState() => _CustomDateFieldState();
}

class _CustomDateFieldState extends State<CustomDateField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Constants.primaryColor,
      controller: widget.controller,
      enabled: widget.isEnabled,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
          borderSide: BorderSide(color: Colors.grey, strokeAlign: 1.0),
          gapPadding: 4.0,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
          borderSide: BorderSide(color: Colors.grey, strokeAlign: 1.0),
          gapPadding: 4.0,
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
          borderSide: BorderSide(color: Colors.grey, strokeAlign: 1.0),
          gapPadding: 4.0,
        ),
        filled: false,
        hintText: widget.hintText,
        focusColor: Constants.accentColor,
        hintStyle: TextStyle(
          fontFamily: "Inter",
          color: widget.hintText == "Date of Birth"
              ? Colors.black38
              : Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      readOnly: true, //set it true, so that user will not able to edit text
      onTap: () async {
        // Calculate the date 18 years ago from today
        DateTime today = DateTime.now();
        DateTime eighteenYearsAgo =
            DateTime(today.year - 18, today.month, today.day);

        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: eighteenYearsAgo, // Set initial date to 18 years ago
          firstDate: DateTime(1920), // Earliest selectable date
          lastDate:
              eighteenYearsAgo, // Latest selectable date (18 years ago from today)
        );

        if (pickedDate != null) {
          debugPrint(
              "$pickedDate"); //pickedDate output format => 2021-03-10 00:00:00.000
          String formattedDate = DateFormat('dd/MMM/yyyy').format(pickedDate);
          debugPrint(
            formattedDate,
          ); //formatted date output using intl package =>  2021-03-16
          //you can implement different kind of Date Format here according to your requirement
          widget.onDateSelected(pickedDate.toIso8601String(), formattedDate);
        } else {
          debugPrint("Date is not selected");
        }
      },
      keyboardType: TextInputType.datetime,
      textCapitalization: widget.capitalization,
    );
  }
}
