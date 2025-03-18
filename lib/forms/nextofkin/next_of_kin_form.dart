// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickfix_app/helper/constants/constants.dart';
import 'package:quickfix_app/helper/data/relationships.dart';
import 'package:quickfix_app/helper/state/state_manager.dart';
import 'package:quickfix_app/widgets/button/custombutton.dart';
import 'package:quickfix_app/widgets/inputs/custom_drop_down.dart';
import 'package:quickfix_app/widgets/inputs/custom_text_field.dart';
import 'package:quickfix_app/widgets/inputs/custom_text_area.dart';
import 'package:quickfix_app/widgets/text/text_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NextOfKinForm extends StatefulWidget {
  const NextOfKinForm({super.key});

  @override
  State<NextOfKinForm> createState() => _NextOfKinFormState();
}

class _NextOfKinFormState extends State<NextOfKinForm> {
  final _formKey = GlobalKey<FormState>();
  final _controller = Get.find<StateController>();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  var _selectedRelationship = "Relationship";

  @override
  void initState() {
    super.initState();
    setState(() {
      _firstnameController.text =
          _controller.nextofKin.value['first_name'] ?? "";
      _lastnameController.text = _controller.nextofKin.value['last_name'] ?? "";
      _emailController.text =
          _controller.nextofKin.value['email_address'] ?? "";
      _phoneController.text = _controller.nextofKin.value['phone_number'] ?? "";
      _addressController.text = _controller.nextofKin.value['address'] ?? "";
      _selectedRelationship = "${_controller.nextofKin.value['relationship']}";
    });
  }

  _saveNOK() async {
    try {
      _controller.setLoading(true);
      final prefs = await SharedPreferences.getInstance();
      String _token = prefs.getString("accessToken") ?? "";

      // if (_selectedRelationship.isNotEmpty &&
      //     _selectedRelationship != "Relationship") {
      //   Map payload = {
      //     "first_name": _firstnameController.text.trim(),
      //     "last_name": _lastnameController.text.trim(),
      //     "email_address": _emailController.text.trim(),
      //     'phone_number': _phoneController.text.trim(),
      //     "address": _addressController.text,
      //     "relationship": _selectedRelationship,
      //   };
      //   final response = await APIService().saveNextOfKin(
      //     body: payload,
      //     accessToken: _token,
      //     userId: _controller.userData.value['_id'],
      //   );
      //   debugPrint("UPDATE NOK RESPONSE HERE ::: ${response.body}");
      //   _controller.setLoading(false);
      //   if (response.statusCode >= 200 && response.statusCode <= 299) {
      //     Map<String, dynamic> map = jsonDecode(response.body);
      //     Constants.toast(map['message']);
      //     //Update state here
      //     _controller.setNextofKinData(map['data']);
      //     Get.back();
      //   } else {
      //     Map<String, dynamic> error = jsonDecode(response.body);
      //     Constants.toast(error['message']);
      //   }
      // } else {
      //   _controller.setLoading(false);
      //   Constants.toast("Relationship with Next of Kin is required");
      // }
    } catch (e) {
      _controller.setLoading(false);
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: CustomTextField(
                    placeholder: "First Name",
                    onChanged: (val) {},
                    controller: _firstnameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your first name';
                      }

                      return null;
                    },
                    inputType: TextInputType.name,
                    capitalization: TextCapitalization.words,
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: CustomTextField(
                    placeholder: "Last Name",
                    onChanged: (val) {},
                    controller: _lastnameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your last name';
                      }

                      return null;
                    },
                    inputType: TextInputType.name,
                    capitalization: TextCapitalization.words,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16.0,
            ),
            CustomTextField(
              placeholder: "Phone",
              onChanged: (val) {},
              controller: _phoneController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter your phone number';
                }
                return null;
              },
              inputType: TextInputType.number,
            ),
            const SizedBox(
              height: 16.0,
            ),
            CustomTextField(
              placeholder: "Email",
              onChanged: (val) {},
              controller: _emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email or phone';
                }
                if (!RegExp('^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]')
                    .hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
              inputType: TextInputType.emailAddress,
            ),
            const SizedBox(
              height: 16.0,
            ),
            CustomDropdown(
              placeholder: _selectedRelationship,
              items: relationships,
              onSelected: (value) {
                setState(() {
                  _selectedRelationship = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Select your relationship';
                }

                return null;
              },
            ),
            const SizedBox(
              height: 16.0,
            ),
            CustomTextArea(
              hintText: "Address",
              onChanged: (e) {},
              controller: _addressController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Next of Kin address required';
                }

                return null;
              },
              inputType: TextInputType.streetAddress,
            ),
            const SizedBox(
              height: 21.0,
            ),
            CustomButton(
              bgColor: Constants.primaryColor,
              borderColor: Colors.transparent,
              foreColor: Colors.white,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _saveNOK();
                }
              },
              variant: "filled",
              child: TextInter(
                text: "Save Changes",
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}
