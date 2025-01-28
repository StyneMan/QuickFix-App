import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickfix_app/helper/constants/constants.dart';
import 'package:quickfix_app/helper/model/order_item.dart';
import 'package:quickfix_app/widgets/text/text_widget.dart';

class OrderDetail extends StatelessWidget {
  var order;
  OrderDetail({
    super.key,
    required this.order,
  });

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
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipOval(
                child: Image.network(
                  order['service']['icon_url'],
                  width: 48,
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
                    text: '${order['service']['title']}',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF222222),
                  ),
                  TextOnest(
                    text: 'Order ID: ${order['order_id']}',
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF222222),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 16.0,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 24.0,
            ),
            decoration: BoxDecoration(
              color: Constants.primaryColorLight,
              border: Border.all(
                color: Constants.primaryColor,
                width: 1.0,
                strokeAlign: 1.0,
              ),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final item = order['items'][index];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextOnest(
                      text: item['name'],
                      fontSize: 16,
                    ),
                    const SizedBox(width: 16.0),
                    Text(
                      "₦${Constants.formatMoneyFloat(double.parse("${item['price']}.0"))} x ${item['quantity']}",
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) => const SizedBox(
                height: 16.0,
              ),
              itemCount: order['items']?.length,
            ),
          ),
        ],
      ),
    );
  }
}
