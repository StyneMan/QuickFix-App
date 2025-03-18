import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import "package:intl/intl.dart";
import 'package:money_formatter/money_formatter.dart';

import 'package:timeago/timeago.dart' as timeago;

class Constants {
  static const Color primaryColorDark = Color(0xFF06413D);
  static const Color primaryColor = Color(0xFF0F9E94);
  static const Color primaryColorLight = Color(0xff1a0f9e94);
  static const Color accentColor = Color(0xFF7CE200);
  static const Color secondaryColor = Colors.white;
  static const Color danger = Color(0xFFE60004);
  static const Color textBold = Color(0xFF1F1F39);
  static const Color golden = Color(0xFFF1A038);
  static const Color bgColor = Color(0xFFFCFBFB);

  static const double padding = 20;
  static const double avatarRadius = 60;

  static const Color shimmerBaseColor = Color.fromARGB(255, 203, 203, 203);
  static const Color shimmerHighlightColor = Colors.white;

  static const pStkPub = "pk_test_c1ff9832479e57844403e068516234c701d625ab";

  static const baseURL = "https://quick-fix-api.vercel.app";
  // "http://192.168.253.247:5050";

  static String pstk = "pk_test_40f544aec0415695c9fae0ba0819ee5bebcb6a5e";
  // "pk_test_40f544aec0415695c9fae0ba0819ee5bebcb6a5e"; //"pk_test_043683268da92cd71e0d30f9d72396396f2dfb1f";

  static String formatMoney(int amt) {
    MoneyFormatter fmf = MoneyFormatter(
      amount: double.parse("${amt}.00"),
      settings: MoneyFormatterSettings(
        symbol: 'NGN',
        thousandSeparator: ',',
        decimalSeparator: '.',
        symbolAndNumberSeparator: ' ',
        fractionDigits: 3,
        compactFormatType: CompactFormatType.short,
      ),
    );
    return fmf.output.withoutFractionDigits;
  }

  static String formatMoneyFloat(double amt) {
    MoneyFormatter fmf = MoneyFormatter(
      amount: amt,
      settings: MoneyFormatterSettings(
        symbol: 'NGN',
        thousandSeparator: ',',
        decimalSeparator: '.',
        symbolAndNumberSeparator: ' ',
        fractionDigits: 3,
        compactFormatType: CompactFormatType.short,
      ),
    );
    return fmf.output.withoutFractionDigits;
  }

  static nairaSign(context) {
    Localizations.localeOf(context);
    var format =
        NumberFormat.simpleCurrency(locale: Platform.localeName, name: 'NGN');
    return format;
  }

  static toast(String message) {
    Fluttertoast.showToast(
      msg: "" + message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.grey[800],
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static String timeUntil(DateTime date) {
    return timeago
        .format(date, locale: "en", allowFromNow: true)
        .replaceAll("minute", "min")
        .replaceAll("second", "sec")
        .replaceAll("hour", "hr")
        .replaceAll("a moment ago", "just now")
        .replaceAll("about", "");
  }

  static void showBottomSheet(
      {required var context,
      required var child,
      required String title,
      double heightFactor = 0.70}) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(10.0),
        height: MediaQuery.of(context).size.height * heightFactor,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(21),
            topRight: Radius.circular(21),
          ),
          color: Colors.white,
        ),
        child: child,
      ),
    );
  }

  // static void showConfirmDialog({
  //   required var context,
  //   required var message,
  //   required var onPressed,
  // }) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) {
  //       return SizedBox(
  //         height: MediaQuery.of(context).size.height * 0.4,
  //         width: MediaQuery.of(context).size.width * 0.98,
  //         child: InfoDialog(
  //           body: Wrap(
  //             children: [
  //               Column(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   const SizedBox(height: 16.0),
  //                   Padding(
  //                     padding: const EdgeInsets.all(16.0),
  //                     child: TextPoppins(
  //                       text: "$message",
  //                       fontSize: 13,
  //                     ),
  //                   ),
  //                   Padding(
  //                     padding: const EdgeInsets.all(16.0),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       children: [
  //                         Expanded(
  //                           child: TextButton(
  //                             onPressed: () {
  //                               Get.back();
  //                             },
  //                             child: TextPoppins(
  //                               text: "Close",
  //                               fontSize: 13,
  //                             ),
  //                           ),
  //                         ),
  //                         const SizedBox(
  //                           width: 10.0,
  //                         ),
  //                         Expanded(
  //                           child: ElevatedButton(
  //                             onPressed: onPressed,
  //                             child: TextPoppins(
  //                               text: "Yes, Proceed",
  //                               fontSize: 13,
  //                             ),
  //                           ),
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // static void showStatusDialog({required var context}) => showDialog(
  //       context: context,
  //       builder: (BuildContext context) => SizedBox(
  //         height: MediaQuery.of(context).size.height * 0.4,
  //         width: MediaQuery.of(context).size.width * 0.98,
  //         child: CustomDialog(
  //           ripple: SvgPicture.asset(
  //             "assets/images/check_effect.svg",
  //             width: (Constants.avatarRadius + 20),
  //             height: (Constants.avatarRadius + 20),
  //           ),
  //           avtrBg: Colors.transparent,
  //           avtrChild: Image.asset(
  //             "assets/images/checked.png",
  //           ), //const Icon(CupertinoIcons.check_mark, size: 50,),
  //           body: Padding(
  //             padding: const EdgeInsets.symmetric(
  //               vertical: 16.0,
  //               horizontal: 36.0,
  //             ),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               mainAxisAlignment: MainAxisAlignment.end,
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: [
  //                 TextPoppins(
  //                   text: "Profile Update",
  //                   fontSize: 13,
  //                   fontWeight: FontWeight.w400,
  //                 ),
  //                 const SizedBox(
  //                   height: 5.0,
  //                 ),
  //                 TextPoppins(
  //                   text: "Updated successfully",
  //                   fontSize: 17,
  //                   fontWeight: FontWeight.w600,
  //                 ),
  //                 const SizedBox(
  //                   height: 21,
  //                 ),
  //                 SizedBox(
  //                   width: MediaQuery.of(context).size.width * 0.36,
  //                   child: RoundedButton(
  //                     bgColor: Constants.primaryColor,
  //                     child: TextPoppins(
  //                       text: "CLOSE",
  //                       fontSize: 14,
  //                       fontWeight: FontWeight.w300,
  //                     ),
  //                     borderColor: Colors.transparent,
  //                     foreColor: Colors.white,
  //                     onPressed: () {
  //                       Navigator.pop(context);
  //                     },
  //                     variant: "Filled",
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     );

// AnimationController localAnimationController;
  // static toastify({
  //   required context,
  //   required String message,
  //   required String type,
  //   required bool persistent,
  // }) {
  //   showTopSnackBar(
  //     context,
  //     type == "info"
  //         ? CustomSnackBar.info(
  //             message: message,
  //           )
  //         : type == "success"
  //             ? CustomSnackBar.success(
  //                 message: message,
  //               )
  //             : CustomSnackBar.error(
  //                 message: message,
  //               ),
  //     persistent: persistent,
  //     // onAnimationControllerInit: (controller) =>
  //     //     localAnimationController = controller,
  //   );
  // }

  //Account Page
  static final accScaffoldKey = GlobalKey<ScaffoldState>();
  static const riKey2 = const Key('__RIKEY2__');
  static final riKey3 = const Key('__RIKEY3__');

  static final GlobalKey<ScaffoldMessengerState> snackbarKey =
      GlobalKey<ScaffoldMessengerState>();
}

extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write("ff");
    buffer.write(hexString.replaceFirst("#", ""));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  String toHex({bool loadingHashSign = true}) => "";
}
