import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickfix_app/helper/data/countries.dart';
import 'package:quickfix_app/widgets/inputs/custom_text_field.dart';
import 'package:quickfix_app/widgets/text/text_widget.dart';

typedef OnSelect(Map<String, dynamic> item);

class CountryPicker extends StatefulWidget {
  final OnSelect onSelected;
  const CountryPicker({super.key, required this.onSelected});

  @override
  State<CountryPicker> createState() => _CountryPickerState();
}

class _CountryPickerState extends State<CountryPicker> {
  final _searchController = TextEditingController();
  List<dynamic> _filtered = countries;

  _performFilter(var value) {
    if (value.toString().isEmpty) {
      setState(() {
        _filtered = countries;
      });
    } else {
      final _list = countries
          .where(
            (elem) => elem['name'].toString().toLowerCase().contains(
                  value.toString().toLowerCase(),
                ),
          )
          .toList();

      setState(() {
        _filtered = _list;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const TextMedium(text: "Countries"),
            IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                CupertinoIcons.xmark_circle,
                size: 18,
              ),
            ),
          ],
        ),
        CustomTextField(
          onChanged: (e) {
            _performFilter(e);
          },
          controller: _searchController,
          validator: (val) {},
          inputType: TextInputType.text,
        ),
        const SizedBox(height: 10.0),
        Expanded(
          child: ListView.separated(
            // physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              var item = _filtered.elementAt(index);
              return TextButton(
                onPressed: () {
                  print("ITEM CLICKeD :: $item");
                  widget.onSelected(item);
                  Get.back();
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          item['flag'],
                        ),
                        const SizedBox(
                          width: 16.0,
                        ),
                        TextInter(
                          text: item['name'],
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                    TextInter(
                      text: item['dial_code'],
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(),
            itemCount: _filtered.length,
          ),
        )
      ],
    );
  }
}
