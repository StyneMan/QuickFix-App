import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:quickfix_app/helper/constants/constants.dart';
import 'package:quickfix_app/helper/model/account_item.dart';
import 'package:quickfix_app/helper/state/state_manager.dart';
import 'package:quickfix_app/service/api_service.dart';
import 'package:quickfix_app/widgets/account/account_item_row.dart';
import 'package:quickfix_app/widgets/picker/img_picker.dart';
import 'package:quickfix_app/widgets/text/text_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen extends StatefulWidget {
  AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _controller = Get.find<StateController>();

  bool _isImagePicked = false;
  String _croppedFile = "";

  final cloudinary = Cloudinary.full(
    apiKey: '346566731948151',
    apiSecret: 't8XdHOHzH0hd63k9w503NPHlClk',
    cloudName: 'dkrts2wv9',
  );

  _onImageSelected(var file) {
    setState(() {
      _isImagePicked = true;
      _croppedFile = file;
    });

    // Future.delayed(const Duration(seconds: 2), () {
    _uploadPhoto();
    // });
  }

  _uploadPhoto() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String _token = prefs.getString("accessToken") ?? "";
      if (_controller.croppedPic.value.isNotEmpty) {
        File imageFile = File(_croppedFile);

        final response = await cloudinary.uploadResource(
          CloudinaryUploadResource(
            uploadPreset: 'ml_default',
            filePath: _croppedFile,
            fileBytes: imageFile.readAsBytesSync(),
            resourceType: CloudinaryResourceType.image,
            progressCallback: (count, total) {
              print('Uploading image from file with progress: $count/$total');
            },
          ),
        );

        if (response.isSuccessful) {
          print('Get your image from with ${response.secureUrl}');
          // List<dynamic> decodedJson = jsonDecode(resp.body);
          // List<String> maps = decodedJson.map((e) => e as String).toList();

          Map _body = {
            ..._controller.userData.value,
            "photoUrl": "${response.secureUrl}",
          };

          // Now update theis user's profile here
          final apiresponse = await APIService().updateProfile(
            body: _body,
            accessToken: _token,
          );
          debugPrint("UPDATED PROFILE RESPONSE HERE ::: ${apiresponse.body}");
          if (apiresponse.statusCode >= 200 && apiresponse.statusCode <= 299) {
            Map<String, dynamic> map = jsonDecode(apiresponse.body);
            _controller.userData.value = map['user'];
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
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
                  width: 16.0,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    CupertinoIcons.arrow_left,
                  ),
                ),
                const SizedBox(
                  width: 4.0,
                ),
              ],
            ),
            title: TextRegular(
              text: "Account",
              fontSize: 22,
            ),
            centerTitle: true,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            shrinkWrap: true,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24.0),
                        child: Obx(
                          () => Container(
                            width: 145,
                            height: 145,
                            padding: const EdgeInsets.all(0.0),
                            child: _isImagePicked
                                ? Image.file(
                                    File(
                                      _croppedFile,
                                    ),
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            SvgPicture.asset(
                                      "assets/images/personal.svg",
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Image.network(
                                    '${_controller.userData.value['photoUrl']}',
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      color: Constants.primaryColorLight,
                                      padding: const EdgeInsets.all(4.0),
                                      child: const Center(
                                        child: Icon(
                                          CupertinoIcons.person,
                                          color: Constants.primaryColorDark,
                                          size: 56.0,
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: -5,
                        bottom: -4,
                        child: ClipOval(
                          child: Container(
                            padding: const EdgeInsets.all(0.0),
                            height: 48,
                            width: 48,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: TextButton(
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
                                    height: 175,
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 16.0,
                                        ),
                                        ImgPicker(
                                          onCropped: _onImageSelected,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.all(0.0),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  "assets/images/upload.svg",
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  TextEpilogue(
                    text:
                        "${_controller.userData.value['first_name']} ${_controller.userData.value['last_name']}",
                    fontSize: 30,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        CupertinoIcons.checkmark_seal_fill,
                        color: Constants.primaryColor,
                        size: 18,
                      ),
                      const SizedBox(
                        width: 2.0,
                      ),
                      TextEpilogue(
                        text: "Account Verified",
                        fontSize: 13,
                        color: Constants.primaryColor,
                        fontWeight: FontWeight.w500,
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 48.0,
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => AccountItemRow(
                  item: accountItems[index],
                  stateController: _controller,
                ),
                separatorBuilder: (context, index) => const Divider(),
                itemCount: accountItems.length,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
