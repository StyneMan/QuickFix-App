import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickfix_app/helper/constants/constants.dart';

typedef void InitCallback(String rawDate, String date);

class CustomDateFieldAdvanced extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final InitCallback onDateSelected;
  final TextEditingController controller;
  final TextCapitalization capitalization;
  final bool? isEnabled;
  var validator;

  CustomDateFieldAdvanced({
    Key? key,
    required this.hintText,
    this.icon = Icons.person,
    this.isEnabled = true,
    required this.onDateSelected,
    this.capitalization = TextCapitalization.none,
    required this.controller,
    required this.validator,
  }) : super(key: key);

  @override
  State<CustomDateFieldAdvanced> createState() =>
      _CustomDateFieldAdvancedState();
}

class _CustomDateFieldAdvancedState extends State<CustomDateFieldAdvanced> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Constants.primaryColor,
      controller: widget.controller,
      enabled: widget.isEnabled,
      validator: widget.validator,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
          borderSide: BorderSide(
            color: Constants.primaryColor,
            strokeAlign: 1.0,
          ),
          gapPadding: 4.0,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
          borderSide: BorderSide(
            color: Constants.primaryColor,
            strokeAlign: 1.0,
          ),
          gapPadding: 4.0,
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
          borderSide: BorderSide(
            color: Constants.primaryColor,
            strokeAlign: 1.0,
          ),
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
        DateTime today = DateTime.now();
        DateTime tomorrow = today.add(Duration(days: 1));
        DateTime maxDate = DateTime(today.year, today.month + 3, today.day);

        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: tomorrow, // Set the initial date to tomorrow
          firstDate: tomorrow, // Allow only future dates starting from tomorrow
          lastDate: maxDate, // Maximum date is 3 months from now
          selectableDayPredicate: (DateTime day) {
            // Return true if the day is not Saturday (6) or Sunday (7)
            if (day.weekday == DateTime.saturday ||
                day.weekday == DateTime.sunday) {
              return false; // Disable Saturdays and Sundays
            }
            return true; // Allow all other days
          },
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
