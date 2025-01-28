import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quickfix_app/helper/constants/constants.dart';
import 'package:quickfix_app/helper/state/state_manager.dart';
import 'package:quickfix_app/widgets/text/text_widget.dart';

class AllTransactions extends StatelessWidget {
  AllTransactions({super.key});

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
          text: 'Transactions',
          fontSize: 21,
          fontWeight: FontWeight.w500,
          color: Constants.textBold,
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
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
        separatorBuilder: (context, index) => const SizedBox(height: 16.0),
        itemCount: _controller.transactions.length ?? 0,
      ),
    );
  }
}
