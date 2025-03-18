import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:quickfix_app/helper/constants/constants.dart';
import 'package:quickfix_app/helper/state/payment_manager.dart';
import 'package:quickfix_app/helper/state/state_manager.dart';
import 'package:quickfix_app/screens/dashboard/pocket/payment_view.dart';
import 'package:quickfix_app/screens/dashboard/pocket/transactions.dart';
import 'package:quickfix_app/service/api_service.dart';
import 'package:quickfix_app/widgets/inputs/custom_money_input.dart';
import 'package:quickfix_app/widgets/inputs/custom_text_field.dart';
import 'package:quickfix_app/widgets/text/text_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pocket extends StatefulWidget {
  const Pocket({super.key});

  @override
  State<Pocket> createState() => _PocketState();
}

class _PocketState extends State<Pocket> {
  final _amountController = TextEditingController();
  final _emailController = TextEditingController();
  final _controller = Get.find<StateController>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setState(() {
      _emailController.text = _controller.userData.value['email_address'] ?? "";
    });
  }

  initTransaction() async {
    try {
      Get.back();
      _controller.setLoading(true);
      final prefs = await SharedPreferences.getInstance();
      String _token = prefs.getString("accessToken") ?? "";

      var filteredAmt = _amountController.text.replaceAll("₦", "");
      var amt = filteredAmt.replaceAll(",", "");
      debugPrint("FILTETED AMMOUNT ::: $amt");

      Map payload = {
        "email": _emailController.text,
        "amount": double.parse(amt) * 100,
      };

      debugPrint("paYLOAd HERE ::: ::: :: $payload");

      final response = await APIService().initTransaction(
        body: payload,
        accessToken: _token,
      );
      debugPrint("RESPONSE HERE ::: ${response.body}");
      _controller.setLoading(false);
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        Map<String, dynamic> map = jsonDecode(response.body);
        // Launch webview here
        Get.lazyPut<PaymentController>(() => PaymentController(), fenix: true);

        Get.to(
          const PaymentView(),
          arguments: {
            'auth_url': map['data']['authorization_url'],
            'access_code': map['data']['access_code'],
            'reference': map['data']['reference'],
          },
        );
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
            title: TextRegular(
              text: "Pocket",
              fontSize: 22,
            ),
            centerTitle: true,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextOnest(
                      text: 'Available Balance',
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          '₦',
                          style: TextStyle(
                            color: Constants.primaryColorDark,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextOnest(
                          text: Constants.formatMoney(
                              _controller.userData.value['wallet']['balance'] ??
                                  ''),
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: Constants.primaryColorDark,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        Get.bottomSheet(
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24.0),
                                topRight: Radius.circular(24.0),
                              ),
                            ),
                            height: 320,
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                Form(
                                  key: _formKey,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 21.0,
                                        ),
                                        CustomMoneyField(
                                          hintText: "Amount",
                                          onChanged: (e) {},
                                          controller: _amountController,
                                          validator: (value) {
                                            if (value.toString().isEmpty) {
                                              return "Amount is required!";
                                            }
                                            if (value
                                                .toString()
                                                .contains("-")) {
                                              return "Negative numbers not allowed";
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(
                                          height: 8.0,
                                        ),
                                        CustomTextField(
                                          onChanged: (e) {},
                                          placeholder: "Email",
                                          controller: _emailController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Email address is required';
                                            }
                                            if (!RegExp(
                                                    '^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]')
                                                .hasMatch(value)) {
                                              return 'Enter a valid email address';
                                            }
                                            return null;
                                          },
                                          inputType: TextInputType.emailAddress,
                                        ),
                                        const SizedBox(
                                          height: 16.0,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              initTransaction();
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.all(16.0),
                                            backgroundColor:
                                                Constants.primaryColor,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: TextOnest(
                                              text: "Continue",
                                              align: TextAlign.center,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.primaryColor,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 24.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: SizedBox(
                        width: 200,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextRegular(
                              text: 'Fund Pocket',
                              fontSize: 20,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 4.0,
                            ),
                            const Icon(
                              CupertinoIcons.add_circled,
                              size: 16,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextOnest(
                    text: 'Recent Transactions',
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Constants.textBold,
                  ),
                  const SizedBox(
                    width: 4.0,
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(
                        AllTransactions(),
                        transition: Transition.cupertino,
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 1.0,
                        vertical: 10.0,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextOnest(
                          text: 'View all ',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Constants.primaryColorDark,
                        ),
                        const Icon(
                          CupertinoIcons.arrow_right,
                          size: 14,
                          color: Constants.primaryColorDark,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16.0),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final item = _controller.transactions.value[index];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: item['type'] == "topup"
                                  ? const Color(0xFF4D57BBB4)
                                  : const Color(0xFF33E60004),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Center(
                              child: item['type'] == "topup"
                                  ? const Icon(
                                      CupertinoIcons.arrow_down_left,
                                      color: Constants.primaryColor,
                                      size: 18,
                                    )
                                  : const Icon(
                                      CupertinoIcons.arrow_up_right,
                                      color: Color(0xFFE60004),
                                      size: 18,
                                    ),
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextOnest(
                                text: item['type'] == "topup"
                                    ? "Pocket Top-Up"
                                    : "Order Payment",
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF1F1F39),
                              ),
                              TextOnest(
                                text:
                                    "${DateFormat('dd.MM.yyyy').format(DateTime.parse(item['createdAt']))} (${Constants.timeUntil(DateTime.parse(item['createdAt']))})",
                                fontSize: 11,
                                color: const Color(0xFF626678),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 16.0,
                      ),
                      Text(
                        "₦${Constants.formatMoney(item['amount'])}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF06413D),
                        ),
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16.0),
                itemCount: _controller.transactions.length ?? 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
