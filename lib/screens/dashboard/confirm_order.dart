// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:quickfix_app/helper/constants/constants.dart';
import 'package:quickfix_app/helper/model/order_item.dart';
import 'package:quickfix_app/helper/state/state_manager.dart';
import 'package:quickfix_app/service/api_service.dart';
import 'package:quickfix_app/widgets/dashboard/dashboard.dart';
import 'package:quickfix_app/widgets/inputs/custom_drop_down.dart';
import 'package:quickfix_app/widgets/inputs/custom_drop_down_express.dart';
import 'package:quickfix_app/widgets/inputs/custom_text_area.dart';
import 'package:quickfix_app/widgets/inputs/custom_text_field.dart';
import 'package:quickfix_app/widgets/text/text_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmOrder extends StatefulWidget {
  var data;
  ConfirmOrder({super.key, required this.data});

  @override
  State<ConfirmOrder> createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends State<ConfirmOrder> {
  int totalAmt = 0;
  var items = [];
  final _controller = Get.find<StateController>();
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _dateController = TextEditingController();
  final _landmarkController = TextEditingController();
  final _noteController = TextEditingController();

  String _datePlaceholder = "Pick up date";
  String _dateValue = "";
  String _selectedDeliveryType = "";
  String _selectedExpress = '';

  bool _isExpressOn = false;
  double totalAmount = 0.0;
  double deliveryFee = 0.0;

  @override
  void initState() {
    super.initState();
    debugPrint("SETTINGS CONTENT HERE ::: ${_controller.settings.value}");
    setState(() {
      totalAmount = _controller.totalPrice;
    });
  }

  createOrder() async {
    try {
      _controller.setLoading(true);
      final prefs = await SharedPreferences.getInstance();
      String _token = prefs.getString("accessToken") ?? "";

      // var filteredAmt = _amountController.text.replaceAll("₦", "");
      // var amt = filteredAmt.replaceAll(",", "");
      debugPrint("SERVICE ID ::: ${widget.data['_id']}");
      Map payload = {};
      final itemsToJson = _controller.itemsList.value
          .map((item) => OrderItem.toJson(item))
          .toList();
      debugPrint("ITEMS TO JSON ::: $itemsToJson");

      if (_selectedDeliveryType.toLowerCase() == "shop pickup") {
        payload = {
          "amount": totalAmount,
          "service": widget.data['_id'],
          "description": _noteController.text,
          "location": _controller.selectedLocation.value,
          "delivery_type": "shop_pickup",
          "items": itemsToJson,
        };
      } else {
        if (_isExpressOn) {
          payload = {
            "amount": totalAmount,
            "delivery_fee": deliveryFee,
            "service": widget.data['_id'],
            "description": _noteController.text,
            "pickup_date": _dateValue,
            "location": _controller.selectedLocation.value,
            "address": _addressController.text,
            "landmark": _landmarkController.text,
            "delivery_type": _selectedDeliveryType.toLowerCase(),
            "items": itemsToJson,
            "express": _selectedExpress,
          };
        } else {
          payload = {
            "amount": totalAmount,
            "delivery_fee": deliveryFee,
            "service": widget.data['_id'],
            "description": _noteController.text,
            "pickup_date": _dateValue,
            "location": _controller.selectedLocation.value,
            "address": _addressController.text,
            "landmark": _landmarkController.text,
            "delivery_type": _selectedDeliveryType.toLowerCase(),
            "items": itemsToJson,
          };
        }
      }

      debugPrint("PAYLOAD CREATE ORDDER ::: $payload");

      final resp = await APIService().createOrder(
        body: payload,
        accessToken: _token,
      );
      debugPrint("CRATE ORDER RESPONSE HERE  :::: ${resp.body}");
      _controller.setLoading(false);
      if (resp.statusCode >= 200 && resp.statusCode <= 299) {
        Map<String, dynamic> map = jsonDecode(resp.body);
        Constants.toast(map['message']);
        // Now update the orders list here
        final orders = await APIService().getOrders(accessToken: _token);
        debugPrint("PAYLOAD CREATE ORDDER ::: ${orders.body}");
        if (orders.statusCode >= 200 && orders.statusCode <= 299) {
          Map<String, dynamic> map = jsonDecode(orders.body);
          _controller.orders.value = map['data'];
          _controller.ordersCurrentPage.value =
              int.parse("${map['currentPage']}");
          _controller.ordersTotalPages.value = map['totalItems'];
        }

        // Navigate to Orders screen here
        _controller.selectedIndex.value = 1;
        Future.delayed(const Duration(seconds: 2), () {
          Get.to(
            const Dashboard(),
            transition: Transition.cupertino,
          );
        });
      } else {
        Map<String, dynamic> errMap = jsonDecode(resp.body);
        Constants.toast(errMap['message']);
      }
    } catch (e) {
      _controller.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LoadingOverlayPro(
        isLoading: _controller.isLoading.value,
        progressIndicator: const CircularProgressIndicator.adaptive(),
        backgroundColor: Colors.black54,
        child: Scaffold(
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
            () => Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 16.0,
                  left: 16.0,
                  right: 16.0,
                  top: 4.0,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: Image.network(
                            widget.data['icon_url'],
                            width: 48,
                          ),
                        ),
                        const SizedBox(
                          width: 16.0,
                        ),
                        TextOnest(
                          text: '${widget.data['title']}',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF222222),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(3.0),
                        children: [
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
                                OrderItem item =
                                    _controller.itemsList.value[index];
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    TextOnest(
                                      text: "${item.name}",
                                      fontSize: 16,
                                    ),
                                    const SizedBox(width: 16.0),
                                    Text(
                                      "₦${Constants.formatMoneyFloat(double.parse("${item.price}.0"))} x ${item.quantity}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                height: 16.0,
                              ),
                              itemCount: _controller.itemsList.length,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          CustomDropdown(
                            items: const [
                              "Pickup Only",
                              "Delivery Only",
                              "Pickup & Delivery",
                              "Shop Pickup"
                            ],
                            placeholder: "Select delivery type",
                            onSelected: (value) {
                              setState(() {
                                _selectedDeliveryType = value;
                              });

                              debugPrint(
                                  "VALU SEELCRED :: ${_controller.settings.value['pickup_n_delivery']}");

                              if (value == "Pickup & Delivery") {
                                final double cost = double.parse(
                                    "${_controller.settings.value['pickup_n_delivery']}");

                                if (_isExpressOn) {
                                  // Overridde with express delivery charge
                                } else {
                                  setState(() {
                                    deliveryFee = cost;
                                    totalAmount = _controller.totalPrice + cost;
                                  });
                                }
                              } else if (value == "Pickup Only") {
                                final double cost = double.parse(
                                    "${_controller.settings.value['pickup_fee']}");

                                if (_isExpressOn) {
                                  // Overridde with express delivery charge
                                } else {
                                  setState(() {
                                    deliveryFee = cost;
                                    totalAmount = _controller.totalPrice + cost;
                                  });
                                }
                              } else if (value == "Delivery Only") {
                                final double cost = double.parse(
                                    "${_controller.settings.value['delivery_fee']}");

                                if (_isExpressOn) {
                                  // Overridde with express delivery charge
                                } else {
                                  setState(() {
                                    deliveryFee = cost;
                                    totalAmount = _controller.totalPrice + cost;
                                  });
                                }
                              } else {
                                setState(() {
                                  deliveryFee = 0.0;
                                  totalAmount = _controller.totalPrice;
                                });
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Select delivery type!';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14.0),

                          _selectedDeliveryType.toLowerCase() != "shop pickup"
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const SizedBox(
                                      height: 14.0,
                                    ),
                                    CustomTextField(
                                      onChanged: (e) {},
                                      placeholder: "Address (optional)",
                                      controller: _addressController,
                                      validator: (value) {
                                        // if (value == null || value.isEmpty) {
                                        //   return 'Address is required';
                                        // }
                                        return null;
                                      },
                                      inputType: TextInputType.text,
                                      capitalization: TextCapitalization.words,
                                    ),
                                    const SizedBox(
                                      height: 14.0,
                                    ),
                                    CustomTextField(
                                      onChanged: (e) {},
                                      placeholder: "Landmark (optional)",
                                      controller: _landmarkController,
                                      validator: (value) {
                                        return null;
                                      },
                                      inputType: TextInputType.text,
                                      capitalization: TextCapitalization.words,
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                          const SizedBox(
                            height: 14.0,
                          ),
                          // Add express delivery for launddry only
                          widget.data['category'].toLowerCase() == "laundry" &&
                                  (_selectedDeliveryType.toLowerCase() ==
                                          "delivery only" ||
                                      _selectedDeliveryType.toLowerCase() ==
                                          "pickup & delivery")
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const SizedBox(
                                      height: 14.0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        TextOnest(
                                          text: "Express Delivery",
                                          align: TextAlign.start,
                                          fontSize: 15,
                                        ),
                                        Switch(
                                          value: _isExpressOn,
                                          activeColor: Constants.primaryColor,
                                          onChanged: (e) {
                                            setState(() {
                                              _isExpressOn = e;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    _isExpressOn
                                        ? const SizedBox(
                                            height: 4.0,
                                          )
                                        : const SizedBox(),
                                    _isExpressOn
                                        ? CustomDropdownExpress(
                                            items: _controller
                                                .expressFeeList.value,
                                            placeholder: "Select express type",
                                            onSelected: (value) {
                                              setState(() {
                                                _selectedExpress =
                                                    value['_id'] ?? value['id'];
                                              });
                                              // Adjust amount here
                                              final chrage = _controller
                                                  .expressFeeList.value;
                                              debugPrint(
                                                  "EXPRESS CHARGE :::: ${chrage}");

                                              debugPrint(
                                                  "VALUE EXPRE :: $value");

                                              final perc = value['fee'] / 100;
                                              final mult =
                                                  perc * _controller.totalPrice;

                                              final deliv =
                                                  mult + _controller.totalPrice;

                                              debugPrint(
                                                  "DELIVE FEE :: $deliv");
                                              setState(() {
                                                deliveryFee = mult;
                                                totalAmount =
                                                    _controller.totalPrice +
                                                        mult;
                                              });
                                            },
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Select delivery type!';
                                              }
                                              return null;
                                            },
                                          )
                                        : const SizedBox(),
                                    const SizedBox(
                                      height: 14.0,
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                          CustomTextArea(
                            onChanged: (e) {},
                            hintText: "Note (optional)",
                            controller: _noteController,
                            validator: (value) {
                              return null;
                            },
                            inputType: TextInputType.text,
                            capitalization: TextCapitalization.sentences,
                          ),
                          const SizedBox(
                            height: 21.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextOnest(
                                text: "Subtotal",
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              const SizedBox(
                                width: 16.0,
                              ),
                              Text(
                                '₦${Constants.formatMoneyFloat(_controller.totalPrice)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                          _selectedDeliveryType.toLowerCase() ==
                                      "delivery only" ||
                                  _selectedDeliveryType.toLowerCase() ==
                                      "pickup & delivery" ||
                                  _selectedDeliveryType.toLowerCase() ==
                                      "pickup only"
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        TextOnest(
                                          text: _selectedDeliveryType
                                                      .toLowerCase() ==
                                                  "pickup only"
                                              ? "Pickup Fee"
                                              : "Delivery Fee",
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        const SizedBox(
                                          width: 16.0,
                                        ),
                                        Text(
                                          '₦${Constants.formatMoneyFloat(deliveryFee)}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 16.0,
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextOnest(
                                text: "Total",
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              const SizedBox(
                                width: 16.0,
                              ),
                              Text(
                                '₦${Constants.formatMoneyFloat(totalAmount)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 18.0,
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/pocket.svg',
                                    width: 18,
                                    height: 18,
                                    color: Constants.primaryColorDark,
                                  ),
                                  const SizedBox(width: 8.0),
                                  TextOnest(
                                    text: "Pocket Balance",
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  )
                                ],
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                '₦${Constants.formatMoney(_controller.userData.value['wallet']['balance'])}',
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
                            if (_formKey.currentState!.validate()) {
                              createOrder();
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
                                borderRadius: BorderRadius.circular(32.0),
                              )),
                          child: TextOnest(
                            text: "Make Payment",
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
