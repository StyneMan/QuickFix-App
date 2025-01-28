import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickfix_app/helper/constants/constants.dart';
import 'package:quickfix_app/helper/state/state_manager.dart';
import 'package:quickfix_app/widgets/text/text_widget.dart';

typedef InitCallback(params);

class ImgPicker extends StatefulWidget {
  final InitCallback onCropped;
  const ImgPicker({
    Key? key,
    required this.onCropped,
  }) : super(key: key);

  @override
  State<ImgPicker> createState() => _ImgPickerState();
}

class _ImgPickerState extends State<ImgPicker> {
  final ImagePicker _picker = ImagePicker();
  final _controller = Get.find<StateController>();

  Future imgFromGallery() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        //Now crop image
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Image Cropper',
              toolbarColor: Constants.primaryColor,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
            ),
            IOSUiSettings(
              title: 'Image Cropper',
            ),
            WebUiSettings(
              context: context,
            ),
          ],
        );

        widget.onCropped(croppedFile?.path);
        _controller.croppedPic.value = "${croppedFile?.path}";

        Future.delayed(const Duration(milliseconds: 200), () {
          Navigator.of(context).pop();
        });
      } else {
        debugPrint('No image selected.');
      }
    } catch (e) {
      debugPrint("IMAGE CROP ERR: ${e.toString()}");
    }
    // });
  }

  Future imgFromCamera() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);

      // setState(() {
      if (pickedFile != null) {
        //Now crop image
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Image Cropper',
              toolbarColor: Constants.primaryColor,
              toolbarWidgetColor: Colors.white,
              aspectRatioPresets: [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
              ],
            ),
            IOSUiSettings(
              title: 'Image Cropper',
              aspectRatioPresets: [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
              ],
            ),
            WebUiSettings(
              context: context,
            ),
          ],
        );

        widget.onCropped(pickedFile.path);
        _controller.croppedPic.value = "${croppedFile?.path}";

        Future.delayed(const Duration(milliseconds: 200), () {
          Navigator.of(context).pop();
        });
      } else {
        debugPrint('No image selected.');
      }
    } catch (e) {
      debugPrint("IMAGE CROP ERR: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(16.0),
      children: [
        ElevatedButton.icon(
          onPressed: () {
            // Navigator.of(context).pop();
            imgFromCamera();
          },
          icon: const Icon(
            CupertinoIcons.camera,
            color: Colors.white,
          ),
          label: TextEpilogue(
            text: "Camera",
            fontSize: 13,
            color: Colors.white,
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(10.0),
            backgroundColor: Constants.primaryColor,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        ElevatedButton.icon(
          onPressed: () {
            imgFromGallery();
          },
          icon: const Icon(CupertinoIcons.folder),
          label: TextEpilogue(text: "Gallery", fontSize: 13),
          style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(10.0)),
        ),
      ],
    );
  }
}
