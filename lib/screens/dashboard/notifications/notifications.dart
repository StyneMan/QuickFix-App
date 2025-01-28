import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quickfix_app/helper/constants/constants.dart';
import 'package:quickfix_app/helper/state/state_manager.dart';
import 'package:quickfix_app/widgets/notifications/icon_generator.dart';
import 'package:quickfix_app/widgets/text/text_widget.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  final _controller = Get.find<StateController>();

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
                Get.back();
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
        title: TextRegular(
          text: "Notifications",
          fontSize: 22,
        ),
        centerTitle: true,
      ),
      body: _controller.notifications.value.length < 1
          ? Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/empty.png"),
                    TextInter(
                      text: "No record found",
                      fontSize: 14,
                      align: TextAlign.center,
                    )
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(10.0),
              itemBuilder: (context, index) {
                final item = _controller.notifications.value[index];
                return TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconGenerator(
                        value: item['category'],
                      ),
                      const SizedBox(
                        width: 16.0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: TextEpilogue(
                              text: item['title'],
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextEpilogue(
                            text:
                                "${DateFormat('MMM dd, yyyy • hh:mm a').format(DateTime.parse("${item['createdAt']}"))}  (${Constants.timeUntil(
                              DateTime.parse("${item['createdAt']}"),
                            )})",
                            fontSize: 11,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
              itemCount: _controller.notifications.value.length,
            ),
    );
  }
}
