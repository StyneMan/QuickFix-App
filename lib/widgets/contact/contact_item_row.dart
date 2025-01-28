import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickfix_app/helper/constants/constants.dart';
import 'package:quickfix_app/helper/model/contact_item.dart';
import 'package:quickfix_app/widgets/text/text_widget.dart';

class ContactItemRow extends StatelessWidget {
  final ContactItem item;
  const ContactItemRow({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: Container(
                width: 44,
                height: 44,
                color: Constants.primaryColorLight,
                child: Center(
                  child: item.icon,
                ),
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            TextEpilogue(
              text: item.name,
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            )
          ],
        ),
      ],
    );
  }
}
