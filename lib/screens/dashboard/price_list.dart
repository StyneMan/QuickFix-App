import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickfix_app/helper/constants/constants.dart';
import 'package:quickfix_app/widgets/text/text_widget.dart';

class PriceList extends StatelessWidget {
  var list;
  PriceList({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFBFB),
      appBar: AppBar(
        elevation: 0.0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: 4.0,
            ),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                CupertinoIcons.arrow_left,
              ),
            ),
            const SizedBox(
              width: 4.0,
            ),
          ],
        ),
        centerTitle: true,
        title: TextEpilogue(
          text: 'Price List',
          fontSize: 21,
          fontWeight: FontWeight.w500,
          color: Constants.textBold,
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, index) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextOnest(
              text: "${list[index]['name']}",
              fontSize: 16,
            ),
            const SizedBox(
              width: 16.0,
            ),
            Text(
              "₦${list[index]['price']}",
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
        itemCount: list.length ?? 0,
        separatorBuilder: (context, index) => const Column(
          children: [
            SizedBox(
              height: 10.0,
            ),
            Divider(),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}
