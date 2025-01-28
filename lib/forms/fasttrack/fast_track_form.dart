// import 'dart:convert';
// import 'dart:io';

// import 'package:cloudinary_sdk/cloudinary_sdk.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:quickfix_app/helper/constants/constants.dart';
// import 'package:quickfix_app/helper/state/state_manager.dart';
// import 'package:quickfix_app/screens/dashboard/account/profile.dart';
// import 'package:quickfix_app/service/api_service.dart';
// import 'package:quickfix_app/widgets/button/custombutton.dart';
// import 'package:quickfix_app/widgets/dialog/info_dialog.dart';
// import 'package:quickfix_app/widgets/inputs/custom_date_field_advanced.dart';
// import 'package:quickfix_app/widgets/inputs/custom_drop_down_location.dart';
// import 'package:quickfix_app/widgets/inputs/custom_drop_down_reason.dart';
// import 'package:quickfix_app/widgets/inputs/custom_money_input.dart';
// import 'package:quickfix_app/widgets/inputs/custom_text_field.dart';
// import 'package:quickfix_app/widgets/inputs/custom_upload_field.dart';
// import 'package:quickfix_app/widgets/text/text_widget.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class FastTrackForm extends StatefulWidget {
//   const FastTrackForm({super.key});

//   @override
//   State<FastTrackForm> createState() => _FastTrackFormState();
// }

// class _FastTrackFormState extends State<FastTrackForm> {
//   List<String> locations = [
//     'Lagos',
//     'Abuja',
//     'Port Harcourt',
//   ];

//   final _formKey = GlobalKey<FormState>();
//   final _controller = Get.find<StateController>();
//   final _amountController = TextEditingController();
//   final _assetController = TextEditingController();
//   final _dateController = TextEditingController();

//   final cloudinary = Cloudinary.full(
//     apiKey: '346566731948151',
//     apiSecret: 't8XdHOHzH0hd63k9w503NPHlClk',
//     cloudName: 'dkrts2wv9',
//   );

//   String _datePlaceholder = "Appointment Date";
//   String _dateValue = "";

//   String _selectedReason = "";
//   String _selectedLocation = "";
//   RegExp regExp = RegExp(r'[^0-9.]');
//   var _fileCropped;

//   _bookAppointment() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       String _token = prefs.getString("accessToken") ?? "";

//       var filteredAmt = _amountController.text.replaceAll("₦", "");
//       var amt = filteredAmt.replaceAll(",", "");
//       debugPrint("FILTETED AMMOUNT ::: $amt");

//       if (_controller.croppedProof.isNotEmpty) {
//         _controller.setLoading(true);
//         File imageFile = File(_fileCropped);

//         final resp = await cloudinary.uploadResource(
//           CloudinaryUploadResource(
//             uploadPreset: 'ml_default',
//             filePath: _fileCropped,
//             fileBytes: imageFile.readAsBytesSync(),
//             resourceType: CloudinaryResourceType.image,
//             progressCallback: (count, total) {
//               print('Uploading image from file with progress: $count/$total');
//             },
//           ),
//         );

//         if (resp.isSuccessful) {
//           print('Get your image from with ${resp.secureUrl}');

//           // Now make trip to API
//           Map _body = {
//             "reason": _selectedReason,
//             "location": _selectedLocation,
//             "category": "fast-track",
//             "amount": int.parse(amt),
//             "asset": _assetController.text,
//             "upload_url": '${resp.secureUrl}',
//             "appointment_date": _dateValue,
//           };

//           final response = await APIService().bookAppointment(
//             body: _body,
//             accessToken: _token,
//             userId: _controller.userData.value['_id'],
//           );
//           _controller.setLoading(false);
//           debugPrint("BOOK APPOINTMENT RESPONSE ::: ${response.body}");
//           if (response.statusCode >= 200 && response.statusCode <= 299) {
//             Map<String, dynamic> map = jsonDecode(response.body);
//             Constants.toast(map['message']);
//             Get.back();
//           } else {
//             Map<String, dynamic> error = jsonDecode(response.body);
//             Constants.toast(error['message']);
//           }
//         }
//       } else {
//         Constants.toast("Proof of asset is required!");
//       }
//     } catch (e) {
//       _controller.setLoading(false);
//       debugPrint(e.toString());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     debugPrint("LOCATIONS INFO ::: ${_controller.locations.value}");
//     return Form(
//       key: _formKey,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CustomDropdownReason(
//             items: _controller.reasons.value,
//             placeholder: "Reasons",
//             onSelected: (value) {
//               setState(() {
//                 _selectedReason = value;
//               });
//             },
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Reason is required';
//               }
//               return null;
//             },
//           ),
//           const SizedBox(
//             height: 10.0,
//           ),
//           CustomDropdownLocation(
//             items: _controller.locations.value,
//             placeholder: "Locations",
//             onSelected: (value) {
//               setState(() {
//                 _selectedLocation = value;
//               });
//             },
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Location is required';
//               }
//               return null;
//             },
//           ),
//           const SizedBox(
//             height: 10.0,
//           ),
//           CustomMoneyField(
//             hintText: "Amount",
//             onChanged: (e) {},
//             controller: _amountController,
//             validator: (value) {
//               if (value.toString().isEmpty) {
//                 return "Amount is required!";
//               }
//               if (value.toString().contains("-")) {
//                 return "Negative numbers not allowed";
//               }
//               return null;
//             },
//           ),
//           CustomDateFieldAdvanced(
//             hintText: _datePlaceholder,
//             onDateSelected: (rawDate, date) {
//               debugPrint("RAW DATE :: $rawDate");
//               debugPrint("NORAL DATE :: $date");
//               setState(() {
//                 _dateValue = rawDate;
//                 _dateController.text = date;
//                 _datePlaceholder = date;
//               });
//             },
//             controller: _dateController,
//           ),
//           const SizedBox(
//             height: 14.0,
//           ),
//           CustomTextField(
//             onChanged: (e) {},
//             placeholder: "Asset",
//             controller: _assetController,
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Asset name is required';
//               }
//               return null;
//             },
//             inputType: TextInputType.text,
//             capitalization: TextCapitalization.words,
//           ),
//           const SizedBox(
//             height: 10.0,
//           ),
//           CustomFileUploader(
//             title: "Upload Proof of Asset",
//             onImageCropped: (item) {
//               setState(() {
//                 _fileCropped = item;
//               });
//             },
//           ),
//           const SizedBox(
//             height: 18.0,
//           ),
//           CustomButton(
//             bgColor: Constants.primaryColor,
//             borderColor: Colors.transparent,
//             foreColor: Colors.white,
//             onPressed: () {
//               if (_formKey.currentState!.validate()) {
//                 if (!_controller.userData.value['is_profile_set']) {
//                   // Show dialog here
//                   showDialog(
//                     context: context,
//                     barrierDismissible: false,
//                     builder: (context) {
//                       return SizedBox(
//                         height: 386,
//                         width: MediaQuery.of(context).size.width * 0.98,
//                         child: InfoDialog(
//                           body: Wrap(
//                             children: [
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Container(
//                                     decoration: const BoxDecoration(
//                                       color: Constants.primaryColor,
//                                       borderRadius: BorderRadius.only(
//                                         topLeft: Radius.circular(
//                                           Constants.padding,
//                                         ),
//                                         topRight: Radius.circular(
//                                           Constants.padding,
//                                         ),
//                                       ),
//                                     ),
//                                     padding: const EdgeInsets.all(16.0),
//                                   ),
//                                   const SizedBox(height: 8.0),
//                                   Padding(
//                                     padding: const EdgeInsets.all(16.0),
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.center,
//                                       children: [
//                                         TextInter(
//                                           text:
//                                               "You must complete your profile first to proceed",
//                                           align: TextAlign.center,
//                                           fontSize: 15,
//                                         ),
//                                         const SizedBox(height: 16.0),
//                                         ElevatedButton(
//                                           onPressed: () {
//                                             Get.to(
//                                               ProfileScreen(
//                                                 isDirect: true,
//                                               ),
//                                             );
//                                           },
//                                           style: ElevatedButton.styleFrom(
//                                             backgroundColor:
//                                                 Constants.primaryColor,
//                                             foregroundColor:
//                                                 Constants.secondaryColor,
//                                           ),
//                                           child: TextRegular(
//                                             text: "Complete Profile",
//                                             fontSize: 15,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 } else {
//                   _bookAppointment();
//                 }
//               }
//             },
//             variant: "filled",
//             child: TextInter(
//               text: "Book Appointment",
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(
//             height: 10.0,
//           ),
//         ],
//       ),
//     );
//   }
// }
