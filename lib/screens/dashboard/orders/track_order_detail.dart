import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickfix_app/helper/constants/constants.dart';
import 'package:quickfix_app/widgets/text/text_widget.dart';

class TrackOrderDetail extends StatelessWidget {
  var order;
  TrackOrderDetail({
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
          const SizedBox(
            height: 48.0,
          ),
          trackerIndicator(
            status: "pending",
            active: true,
          ),
          lineConnector(
            active: order['status'].toString().toLowerCase() == "pending"
                ? false
                : true,
          ),
          trackerIndicator(
            status: "washed",
            active: (order['status'].toString().toLowerCase() == "washed" ||
                    order['status'].toString().toLowerCase() == "ironed" ||
                    order['status'].toString().toLowerCase() == "packaged" ||
                    order['status'].toString().toLowerCase() == "delivered")
                ? true
                : false,
          ),
          lineConnector(
            active: (order['status'].toString().toLowerCase() == "ironed" ||
                    order['status'].toString().toLowerCase() == "packaged" ||
                    order['status'].toString().toLowerCase() == "delivered")
                ? true
                : false,
          ),
          trackerIndicator(
            status: "ironed",
            active: (order['status'].toString().toLowerCase() == "ironed" ||
                    order['status'].toString().toLowerCase() == "packaged" ||
                    order['status'].toString().toLowerCase() == "delivered")
                ? true
                : false,
          ),
          lineConnector(
            active: (order['status'].toString().toLowerCase() == "packaged" ||
                    order['status'].toString().toLowerCase() == "delivered")
                ? true
                : false,
          ),
          trackerIndicator(
            status: "packaged",
            active: (order['status'].toString().toLowerCase() == "packaged" ||
                    order['status'].toString().toLowerCase() == "delivered")
                ? true
                : false,
          ),
          lineConnector(
            active: (order['status'].toString().toLowerCase() == "delivered")
                ? true
                : false,
          ),
          trackerIndicator(
            status: "delivered",
            active: (order['status'].toString().toLowerCase() == "delivered")
                ? true
                : false,
          ),
        ],
      ),
    );
  }

  Widget trackerIndicator({required String status, required bool active}) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipOval(
                child: Container(
                  width: 32.0,
                  height: 32.0,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: active ? Constants.primaryColor : Colors.grey,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: active
                      ? const Icon(
                          Icons.check_circle,
                          size: 24,
                          color: Constants.primaryColor,
                        )
                      : const Icon(
                          Icons.circle,
                          size: 24,
                          color: Colors.grey,
                        ),
                ),
              ),
              const SizedBox(
                width: 16.0,
              ),
              TextOnest(
                text: status,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF1F1F39),
              ),
            ],
          )
        ],
      );

  Widget lineConnector({required bool active}) => SizedBox(
        width: 2,
        child: Container(
          width: 1.1,
          height: 36.0,
          margin: const EdgeInsets.only(left: 16.0),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: active ? Constants.primaryColor : Colors.grey,
                width: 1.5,
              ),
            ),
          ),
        ),
      );
}
