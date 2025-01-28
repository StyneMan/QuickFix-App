import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:quickfix_app/helper/state/state_manager.dart';
import 'package:quickfix_app/widgets/picker/file_picker.dart';
import 'package:quickfix_app/widgets/text/text_widget.dart';

typedef onCropped(var item);

class CustomFileUploader extends StatefulWidget {
  final String title;
  final onCropped onImageCropped;
  const CustomFileUploader({
    super.key,
    required this.title,
    required this.onImageCropped,
  });

  @override
  State<CustomFileUploader> createState() => _CustomFileUploaderState();
}

class _CustomFileUploaderState extends State<CustomFileUploader> {
  final _controller = Get.find<StateController>();
  bool _isImagePicked = false;
  String _croppedFile = "";

  _onImageSelected(var file) {
    setState(() {
      _isImagePicked = true;
      _croppedFile = file;
    });
    widget.onImageCropped(file);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey, strokeAlign: 1.0),
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
                  FilePicker(
                    onCropped: _onImageSelected,
                  ),
                ],
              ),
            ),
          );
        },
        child: _isImagePicked
            ? Obx(
                () => Container(
                  padding: const EdgeInsets.all(10.0),
                  width: double.infinity,
                  height: 256,
                  child: Image.file(
                    File(_controller.croppedProof.value),
                    errorBuilder: (context, error, stackTrace) => ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: const Icon(
                        Icons.image,
                        size: 256,
                      ),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/images/uploader_img.svg"),
                  TextInter(
                    text: widget.title,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    align: TextAlign.center,
                    color: const Color(0xFFA4A4A4),
                  )
                ],
              ),
      ),
    );
  }
}
