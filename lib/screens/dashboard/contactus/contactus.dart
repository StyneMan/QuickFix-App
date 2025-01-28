import 'package:crisp_chat/crisp_chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickfix_app/helper/constants/constants.dart';
import 'package:quickfix_app/helper/model/contact_item.dart';
import 'package:quickfix_app/helper/state/state_manager.dart';
import 'package:quickfix_app/widgets/contact/contact_item_row.dart';
import 'package:quickfix_app/widgets/text/text_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatefulWidget {
  ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final _controller = Get.find<StateController>();
  final String websiteID = 'YOUR_WEBSITE_KEY';
  late CrispConfig config;

  dynamic launchEmail(String to) async {
    try {
      Uri email = Uri(
        scheme: 'mailto',
        path: to,
        queryParameters: {'subject': "General enquiry"},
      );
      await launchUrl(email);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  dynamic launchBrowser(String url) async {
    try {
      Uri link = Uri(scheme: 'https', path: url);
      await launchUrl(link, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    config = CrispConfig(
      websiteID: websiteID,
    );
  }

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
              width: 2.0,
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
          text: "Contact us",
          fontSize: 22,
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  TextInter(
                    text:
                        "Relax and unwind while we take care of the rest. Our comprehensive home services eliminate the stress of daily chores, ensuring a peaceful and comfortable living.",
                    fontSize: 14,
                    color: const Color(0xFF787878),
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(0.0),
                    shrinkWrap: true,
                    itemBuilder: (context, index) => TextButton(
                      onPressed: () {
                        if (contactItems[index].action == "phone call") {
                          _makePhoneCall(
                              "${_controller.settings.value['phone_number']}");
                        } else if (contactItems[index].action == "email") {
                          launchEmail(
                              "${_controller.settings.value['email_address']}");
                        } else if (contactItems[index] == 2) {
                          launchBrowser(contactItems[index].action);
                        } else if (contactItems[index] == 3) {
                          launchBrowser(contactItems[index].action);
                        } else {
                          launchBrowser(contactItems[index].action);
                        }
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                      ),
                      child: ContactItemRow(
                        item: contactItems[index],
                      ),
                    ),
                    itemCount: contactItems.length,
                    separatorBuilder: (context, index) => const Divider(),
                  ),
                  const SizedBox(
                    height: 48.0,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextEpilogue(
                        text: "Connect with us on social media",
                        fontSize: 13,
                        align: TextAlign.center,
                        color: const Color(0xFF545E74),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          for (var i = 0;
                              i < _controller.socials.value.length;
                              i++)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        launchBrowser(
                                          "${_controller.socials.value[i]['url']}",
                                        );
                                      },
                                      icon: Image.network(
                                        '${_controller.socials.value[i]['logo']}',
                                        width: 48,
                                        height: 48,
                                      ),
                                    ),
                                    // Text(
                                    //     '${_controller.socials.value[i]['name']}')
                                  ],
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                              ],
                            ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: () async {
                    await FlutterCrispChat.openCrispChat(config: config);
                    FlutterCrispChat.setSessionString(
                      key: "a_string",
                      value: "Crisp Chat",
                    );
                    FlutterCrispChat.setSessionInt(
                      key: "a_number",
                      value: 12345,
                    );
                  },
                  backgroundColor: Constants.primaryColor,
                  foregroundColor: Colors.white,
                  child: const Icon(
                    CupertinoIcons.chat_bubble_2_fill,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
