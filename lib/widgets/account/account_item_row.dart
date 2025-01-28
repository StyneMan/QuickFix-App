import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickfix_app/helper/constants/constants.dart';
import 'package:quickfix_app/helper/model/account_item.dart';
import 'package:quickfix_app/screens/getstarted/getstarted.dart';
import 'package:quickfix_app/service/api_service.dart';
import 'package:quickfix_app/widgets/inputs/custom_drop_down.dart';
import 'package:quickfix_app/widgets/text/text_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountItemRow extends StatefulWidget {
  final AccountItem item;
  var stateController;
  AccountItemRow({
    super.key,
    required this.item,
    required this.stateController,
  });

  @override
  State<AccountItemRow> createState() => _AccountItemRowState();
}

class _AccountItemRowState extends State<AccountItemRow> {
  String _selectedReason = "Your reason";
  final _formKey = GlobalKey<FormState>();
  // final _controller = Get.find<StateController>();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (widget.item.name == "Delete Account") {
          showAdaptiveDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog.adaptive(
                content: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 10.0),
                        TextEpilogue(
                          text: "We are sad to see you go 😔".capitalize,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        const SizedBox(height: 16.0),
                        CustomDropdown(
                          items: const [
                            'taking a break',
                            'no longer interested',
                            "got what I wanted",
                            "can't say",
                          ],
                          placeholder: _selectedReason,
                          onSelected: (value) {
                            setState(() {
                              _selectedReason = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Reason is required';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: TextRegular(
                      text: "Cancel",
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _requestDelete();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constants.primaryColor,
                      foregroundColor: Constants.secondaryColor,
                    ),
                    child: TextRegular(
                      text: "Proceed",
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              );
            },
          );
        } else if (widget.item.name == "Log Out") {
          showAdaptiveDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog.adaptive(
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 8.0),
                      TextInter(
                        text: "Are you sure you want to log out?",
                        fontSize: 15,
                      ),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: TextRegular(
                      text: "Cancel",
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      try {
                        Get.back();
                        widget.stateController.setLoading(true);
                        Future.delayed(const Duration(seconds: 3), () async {
                          final prefs = await SharedPreferences.getInstance();
                          prefs.clear();
                          widget.stateController.setLoading(false);
                          Get.offAll(
                            GetStarted(),
                            transition: Transition.cupertino,
                          );
                        });
                      } catch (e) {
                        widget.stateController.setLoading(false);
                        debugPrint(e.toString());
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constants.primaryColor,
                      foregroundColor: Constants.secondaryColor,
                    ),
                    child: TextRegular(
                      text: "Proceed",
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              );
            },
          );
        } else {
          Get.to(
            widget.item.child,
            transition: Transition.cupertino,
          );
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              widget.item.icon,
              const SizedBox(
                width: 16.0,
              ),
              TextEpilogue(
                text: widget.item.name,
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              )
            ],
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
            size: 14,
          )
        ],
      ),
    );
  }

  _requestDelete() async {
    try {
      Get.back();
      widget.stateController.setLoading(true);

      final prefs = await SharedPreferences.getInstance();
      String _token = prefs.getString("accessToken") ?? "";

      Map body = {
        "reason": _selectedReason.toLowerCase(),
      };
      final resp = await APIService().deleteAccount(
        body: body,
        userId: widget.stateController.userData.value['_id'],
        accessToken: _token,
      );
      debugPrint("DELETE ACC RESPONSE ::: ${resp.body}");
      widget.stateController.setLoading(false);
      if (resp.statusCode >= 200 && resp.statusCode <= 299) {
        Map<String, dynamic> map = jsonDecode(resp.body);
        Constants.toast(map['message']);
      } else {
        Map<String, dynamic> err = jsonDecode(resp.body);
        Constants.toast(err['message']);
      }
    } catch (e) {
      widget.stateController.setLoading(false);
      debugPrint(e.toString());
    }
  }
}
