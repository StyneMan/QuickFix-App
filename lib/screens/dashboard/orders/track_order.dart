import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickfix_app/helper/state/state_manager.dart';
import 'package:quickfix_app/screens/dashboard/orders/track_order_detail.dart';
import 'package:quickfix_app/widgets/text/text_widget.dart';

class TrackOrder extends StatelessWidget {
  TrackOrder({super.key});

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
          text: "Track Order",
          fontSize: 22,
        ),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, index) {
          final item = _controller.trackableOrders.value[index];
          return InkWell(
            onTap: () {
              Get.to(
                TrackOrderDetail(order: item),
                transition: Transition.cupertino,
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: Image.network(
                        "${item['service']['icon_url']}",
                        width: 48,
                        height: 48,
                      ),
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextOnest(
                          text: "${item['service']['title']}",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        TextOnest(
                          text: "Order ID: ${item['order_id']}",
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ],
                ),
                const Icon(
                  CupertinoIcons.forward,
                  size: 18,
                )
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(
          height: 21.0,
        ),
        itemCount: _controller.trackableOrders.length,
      ),
    );
  }
}
