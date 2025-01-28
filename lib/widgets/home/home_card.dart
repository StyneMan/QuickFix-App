import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickfix_app/helper/constants/constants.dart';
import 'package:quickfix_app/helper/model/home_item.dart';
import 'package:quickfix_app/helper/state/state_manager.dart';
import 'package:quickfix_app/screens/dashboard/category.dart';
import 'package:quickfix_app/screens/dashboard/orders/track_order.dart';
import 'package:quickfix_app/widgets/text/text_widget.dart';

class HomeItemCard extends StatelessWidget {
  final HomeItem item;
  const HomeItemCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StateController>(
      builder: (controller) => GestureDetector(
        onTap: () {
          if (item.title.toLowerCase() == 'laundry') {
            Get.to(
              ServiceCategory(
                data: controller.laundryServices.value,
                title: item.title,
              ),
              transition: Transition.cupertino,
            );
          } else if (item.title.toLowerCase() == 'cleaning') {
            Constants.toast("Coming soon!");
            // Get.to(
            //   ServiceCategory(
            //     data: controller.cleaningServices.value,
            //     title: item.title,
            //   ),
            //   transition: Transition.cupertino,
            // );
          } else if (item.title.toLowerCase() == 'car wash') {
            Constants.toast("Coming soon!");
            // Get.to(
            //   ServiceCategory(
            //     data: controller.carwashServices.value,
            //     title: item.title,
            //   ),
            //   transition: Transition.cupertino,
            // );
          } else if (item.title.toLowerCase() == 'track order') {
            Get.to(
              TrackOrder(),
              transition: Transition.cupertino,
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          decoration: BoxDecoration(
            color: item.bgColor,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 2.0),
              ClipOval(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.13,
                  height: MediaQuery.of(context).size.width * 0.13,
                  color: Colors.white,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: item.icon,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextEpilogue(
                    text: item.title,
                    fontSize: 18,
                    align: TextAlign.center,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
