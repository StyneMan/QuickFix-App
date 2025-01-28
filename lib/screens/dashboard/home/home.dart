import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:quickfix_app/helper/constants/constants.dart';
import 'package:quickfix_app/helper/model/home_item.dart';
import 'package:quickfix_app/helper/state/state_manager.dart';
import 'package:quickfix_app/screens/dashboard/account/account.dart';
import 'package:quickfix_app/screens/dashboard/home/widgets/home_slider.dart';
import 'package:quickfix_app/screens/dashboard/notifications/notifications.dart';
import 'package:quickfix_app/widgets/home/home_card.dart';
import 'package:quickfix_app/widgets/text/text_widget.dart';

class Home extends StatelessWidget {
  Home({
    super.key,
  });

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _controller = Get.find<StateController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Constants.bgColor,
      appBar: AppBar(
        elevation: 0.0,
        foregroundColor: Colors.black,
        backgroundColor: Constants.secondaryColor,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                Get.to(
                  AccountScreen(),
                  transition: Transition.cupertino,
                );
              },
              icon: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: SizedBox(
                  width: 40,
                  height: 32,
                  child: Obx(
                    () => Image.network(
                      '${_controller.userData.value['photoUrl']}',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Constants.primaryColorLight,
                        padding: const EdgeInsets.all(4.0),
                        child: const Center(
                          child: Icon(
                            CupertinoIcons.person,
                            color: Constants.primaryColorDark,
                            size: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            TextRegular(
              text: "Hello, ",
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
            Obx(
              () => TextRegular(
                text: "${_controller.userData.value['first_name']} 👋",
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              Get.to(
                NotificationScreen(),
                transition: Transition.cupertino,
              );
            },
            icon: const ClipOval(
              child: SizedBox(
                width: 36,
                height: 36,
                child: Icon(
                  CupertinoIcons.bell_fill,
                  color: Constants.primaryColorDark,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const BannerSlider(),
          const SizedBox(
            height: 16.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextEpilogue(
                text: "Our Services",
                fontSize: 14,
              ),
              const SizedBox(
                width: 4.0,
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: 1.0,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 21.0,
          ),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // number of items in each row
              mainAxisSpacing: 16.0, // spacing between rows
              crossAxisSpacing: 16.0, // spacing between columns
            ),
            itemBuilder: (context, index) => HomeItemCard(
              item: homeItems[index],
            ),
            itemCount: homeItems.length,
            physics: const NeverScrollableScrollPhysics(),
          ),
        ],
      ),
    );
  }
}
