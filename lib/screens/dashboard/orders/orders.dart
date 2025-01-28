import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickfix_app/helper/state/state_manager.dart';
import 'package:quickfix_app/screens/dashboard/orders/order_detail.dart';
import 'package:quickfix_app/widgets/text/text_widget.dart';

class Orders extends StatelessWidget {
  Orders({super.key});

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
        title: TextRegular(
          text: "Orders",
          fontSize: 22,
        ),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, index) {
          final item = _controller.orders.value[index];
          return InkWell(
            onTap: () {
              Get.to(
                OrderDetail(order: item),
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
        itemCount: _controller.orders.length,
      ),
    );
  }
}
