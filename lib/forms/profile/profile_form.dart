import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quickfix_app/helper/constants/constants.dart';
import 'package:quickfix_app/helper/state/state_manager.dart';
import 'package:quickfix_app/service/api_service.dart';
import 'package:quickfix_app/widgets/button/custombutton.dart';
import 'package:quickfix_app/widgets/inputs/custom_date_field.dart';
import 'package:quickfix_app/widgets/inputs/custom_drop_down.dart';
import 'package:quickfix_app/widgets/inputs/custom_phone_field.dart';
import 'package:quickfix_app/widgets/inputs/custom_text_field.dart';
import 'package:quickfix_app/widgets/inputs/custom_text_area.dart';
import 'package:quickfix_app/widgets/text/text_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileForm extends StatefulWidget {
  const ProfileForm({super.key});

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final _controller = Get.find<StateController>();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _dobController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  var _selectedGender = "Select Gender";

  String _countryCode = "+234";
  String _dobPlaceholder = "Date of Birth";
  String _dobValue = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      _firstnameController.text =
          _controller.userData.value['first_name'] ?? "";
      _lastnameController.text = _controller.userData.value['last_name'] ?? "";
      _emailController.text = _controller.userData.value['email_address'] ?? "";
      _phoneController.text = _controller.userData.value['phone_number'] ?? "";

      if (_controller.userData.value['address'] != null) {
        _addressController.text = _controller.userData.value['address'] ?? "";
      }
      if (_controller.userData.value['gender'] != null) {
        _selectedGender = "${_controller.userData.value['gender']}";
      }
      if (_controller.userData.value['dob'] != null) {
        String formattedDate = DateFormat('dd/MMM/yyyy').format(
          DateTime.parse(_controller.userData.value['dob']),
        );
        _dobController.text = formattedDate;
      }
    });
  }

  _updateProfile() async {
    try {
      _controller.setLoading(true);
      final prefs = await SharedPreferences.getInstance();
      String _token = prefs.getString("accessToken") ?? "";

      Map payload = {
        ..._controller.userData.value,
        "first_name": _firstnameController.text.trim(),
        "last_name": _lastnameController.text.trim(),
        "gender": _selectedGender.toString().toLowerCase(),
        "address": _addressController.text,
        "dob": _dobValue,
        "is_profile_set": true,
      };
      final response = await APIService().updateProfile(
        body: payload,
        accessToken: _token,
      );
      debugPrint("UPDATE PROFILE RESPONSE HERE ::: ${response.body}");
      _controller.setLoading(false);
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        Map<String, dynamic> map = jsonDecode(response.body);
        Constants.toast(map['message']);
        //Update state here
        _controller.setUserData(map['user']);
        Get.back();
      } else {
        Map<String, dynamic> error = jsonDecode(response.body);
        Constants.toast(error['message']);
      }
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: CustomDropdown(
                    placeholder: _selectedGender,
                    items: const ['Select gender', 'male', 'female'],
                    onSelected: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Select your gender';
                      }

                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: CustomDateField(
                    hintText: _dobPlaceholder,
                    onDateSelected: (rawDate, date) {
                      debugPrint("RAW DATE :: $rawDate");
                      debugPrint("NORAL DATE :: $date");
                      setState(() {
                        _dobValue = rawDate;
                        _dobController.text = date;
                        _dobPlaceholder = date;
                      });
                    },
                    controller: _dobController,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16.0,
            ),
            // CustomTextField(
            //   placeholder: "NIN",
            //   onChanged: (val) {},
            //   controller: _ninController,
            //   validator: (value) {
            //     if (value == null || value.isEmpty) {
            //       return 'Enter your NIN';
            //     }
            //     return null;
            //   },
            //   inputType: TextInputType.text,
            //   capitalization: TextCapitalization.characters,
            // ),
            // const SizedBox(
            //   height: 16.0,
            // ),
            CustomPhoneField(
              placeholder: "Enter phone number",
              onChanged: (val) {},
              controller: _phoneController,
              isEnabled: false,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email or phone';
                }
                return null;
              },
              onSelected: (item) {
                setState(() {
                  _countryCode = item['dial_code'];
                });
              },
              inputType: TextInputType.number,
            ),
            const SizedBox(
              height: 16.0,
            ),
            CustomTextField(
              placeholder: "email",
              onChanged: (val) {},
              isEnabled: false,
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
            CustomTextArea(
              hintText: "Address",
              onChanged: (e) {},
              controller: _addressController,
              validator: (value) {},
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
                  _updateProfile();
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
