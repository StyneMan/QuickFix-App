import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickfix_app/helper/constants/constants.dart';
import 'package:quickfix_app/helper/model/order_item.dart';
import 'package:quickfix_app/helper/state/state_manager.dart';
import 'package:quickfix_app/screens/dashboard/confirm_order.dart';
import 'package:quickfix_app/screens/dashboard/price_list.dart';
import 'package:quickfix_app/widgets/text/text_widget.dart';

class ServiceDetail extends StatefulWidget {
  var data;
  final List<OrderItem> itemList;
  ServiceDetail({
    super.key,
    required this.data,
    required this.itemList,
  });

  @override
  State<ServiceDetail> createState() => _ServiceDetailState();
}

class _ServiceDetailState extends State<ServiceDetail> {
  int totalAmt = 0;
  var items = [];
  final _controller = Get.find<StateController>();

  @override
  void initState() {
    super.initState();
    _controller.itemsList.value = widget.itemList;
  }

  locationFromID(String id) {
    final found = _controller.locations.value
        .where(
          (item) => (item['_id'] ?? item['id']) == id,
        )
        .toList();
    return "${found[0]['region']}, ${found[0]['city']}".capitalize;
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
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(
                height: 8.0,
              ),
              Container(
                padding: const EdgeInsets.all(1.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: Constants.primaryColor,
                    strokeAlign: 1.0,
                    width: 1.0,
                  ),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    TextButton(
                      onPressed: null,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 32.0,
                          horizontal: 18.0,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            child: Image.network(
                              widget.data['icon_url'],
                              width: 48,
                            ),
                          ),
                          const SizedBox(
                            width: 16.0,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextOnest(
                                text: widget.data['title'],
                                fontSize: 21,
                                color: Constants.textBold,
                              ),
                              TextOnest(
                                text: widget.data['description'],
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF222222),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: -10,
                      right: -2,
                      child: ClipOval(
                        child: Container(
                          color: Colors.white,
                          child: const Icon(
                            CupertinoIcons.check_mark_circled_solid,
                            size: 24,
                            color: Constants.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              TextOnest(
                text:
                    "Ordering Location: ${locationFromID(_controller.selectedLocation.value)}",
                align: TextAlign.start,
                fontSize: 15,
              ),
              const SizedBox(
                height: 16.0,
              ),
              TextButton(
                onPressed: () {
                  Get.to(
                    PriceList(
                      list: widget.data['items'],
                    ),
                    transition: Transition.cupertino,
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: Constants.primaryColorLight,
                  foregroundColor: Constants.textBold,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 12.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextOnest(
                      text: 'Check Price List',
                      fontSize: 15,
                    ),
                    const Icon(
                      CupertinoIcons.chevron_forward,
                      color: Colors.grey,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 36.0,
              ),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final item = _controller.itemsList.value[index];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextOnest(
                          text: "${item.name}",
                          fontSize: 15,
                        ),
                        const SizedBox(
                          width: 16.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipOval(
                              child: InkWell(
                                onTap: () {
                                  _controller.decrementQuantity(index);
                                },
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  color: const Color(0xFF668A95BF),
                                  child: const Center(
                                    child: Icon(
                                      Icons.remove,
                                      size: 14,
                                      color: Color(0xFF8A95BF),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            TextOnest(text: '${item.quantity}', fontSize: 16),
                            const SizedBox(
                              width: 8.0,
                            ),
                            ClipOval(
                              child: InkWell(
                                onTap: () {
                                  _controller.incrementQuantity(index);
                                },
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  color: Constants.primaryColorLight,
                                  child: const Center(
                                    child: Icon(
                                      Icons.add,
                                      size: 14,
                                      color: Color(0xFF0F9E94),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    );
                  },
                  itemCount: _controller.itemsList.value.length,
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
              ),
              const SizedBox(height: 36.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18.0,
                      vertical: 21.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Constants.primaryColor,
                        strokeAlign: 1.0,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(32.0),
                      color: Constants.primaryColorLight,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextOnest(
                          text: 'Total',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 10.0),
                        Text(
                          '₦${Constants.formatMoneyFloat(_controller.totalPrice)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      Get.to(
                        ConfirmOrder(data: widget.data),
                        transition: Transition.cupertino,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18.0,
                        vertical: 21.0,
                      ),
                      backgroundColor: Constants.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    child: TextOnest(
                      text: "Continue",
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
