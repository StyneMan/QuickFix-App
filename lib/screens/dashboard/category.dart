import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickfix_app/helper/constants/constants.dart';
import 'package:quickfix_app/helper/model/order_item.dart';
import 'package:quickfix_app/helper/state/state_manager.dart';
import 'package:quickfix_app/screens/dashboard/servicedetail.dart';
import 'package:quickfix_app/widgets/inputs/custom_drop_down_location.dart';
import 'package:quickfix_app/widgets/text/text_widget.dart';

class ServiceCategory extends StatelessWidget {
  final List data;
  final String title;
  ServiceCategory({
    super.key,
    required this.data,
    required this.title,
  });

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    debugPrint("DATA LIST HERE :: :::: ${data}");
    return GetBuilder<StateController>(
      builder: (controller) => Scaffold(
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
            text: title,
            fontSize: 21,
            fontWeight: FontWeight.w500,
            color: Constants.textBold,
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const SizedBox(
              height: 16.0,
            ),
            TextOnest(
              text: 'Select $title Type',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Constants.textBold,
            ),
            const SizedBox(
              height: 16.0,
            ),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final item = data.elementAt(index);

                return Container(
                  padding: const EdgeInsets.all(1.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(
                      color: Constants.primaryColor,
                      strokeAlign: 1.0,
                      width: 1.0,
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      // Show Loccaation Sheet first
                      debugPrint(
                          "LOGGED LOCATIONS ::: ${controller.locations.value}");
                      Constants.showBottomSheet(
                        context: context,
                        child: Container(
                          width: double.infinity,
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 10.0,
                                ),
                                const TextMedium(
                                  text: "Select Your Location",
                                  align: TextAlign.center,
                                  fontWeight: FontWeight.w600,
                                ),
                                const SizedBox(
                                  height: 16.0,
                                ),
                                CustomDropdownLocation(
                                  items: controller.locations.value,
                                  placeholder: "Locations",
                                  onSelected: (value) {
                                    debugPrint("LOCATION ID:: $value");
                                    controller.selectedLocation.value = value;
                                    // setState(() {
                                    //   _selectedLocation = value;
                                    // });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Location is required';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 32.0,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        var orderList = (item['items'] as List)
                                            .map((elem) =>
                                                OrderItem.fromJson(elem))
                                            .toList();
                                        Future.delayed(
                                            const Duration(seconds: 1), () {
                                          Get.to(
                                            ServiceDetail(
                                              data: item,
                                              itemList: orderList,
                                            ),
                                            transition: Transition.cupertino,
                                          );
                                        });
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0,
                                        vertical: 18.0,
                                      ),
                                      backgroundColor: Constants.primaryColor,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(32.0),
                                      ),
                                    ),
                                    child: TextOnest(
                                      text: "Continue",
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        title: title,
                        heightFactor: 0.3,
                      );
                    },
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
                            item['icon_url'],
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
                              text: item['title'],
                              fontSize: 21,
                              color: Constants.textBold,
                            ),
                            TextOnest(
                              text: item['description'],
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF222222),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(
                height: 16.0,
              ),
              itemCount: data.length,
            )
          ],
        ),
      ),
    );
  }
}
