import 'package:flutter/material.dart';

class TextLarge extends StatelessWidget {
  late final String? text;
  late final Color? color;
  late final TextAlign? align;
  late final FontStyle? fontStyle;
  late final bool? softWrap;

  TextLarge({
    required this.text,
    this.color,
    this.fontStyle,
    this.align,
    this.softWrap,
  });

  final fontFamily = "Onest";

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      softWrap: softWrap,
      textAlign: align,
      style: TextStyle(
        color: color,
        fontSize: 32,
        fontStyle: fontStyle,
        fontFamily: fontFamily,
        fontWeight: FontWeight.w600,
        height: 1.15,
      ),
    );
  }
}

class TextMedium extends StatelessWidget {
  final String? text;
  final Color? color;
  final TextAlign? align;
  final FontWeight? fontWeight;
  final bool? softWrap;

  const TextMedium({
    required this.text,
    this.color,
    this.fontWeight,
    this.align,
    this.softWrap,
  });

  final fontFamily = "BeVietnamPro";

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      softWrap: softWrap,
      textAlign: align,
      style: TextStyle(
        color: color,
        fontSize: 20,
        fontFamily: fontFamily,
        fontWeight: fontWeight,
      ),
    );
  }
}

class TextRegular extends StatelessWidget {
  late final String? text;
  late final double? fontSize;
  late final Color? color;
  late final FontWeight? fontWeight;
  late final TextAlign? align;

  TextRegular({
    required this.text,
    this.color,
    required this.fontSize,
    this.fontWeight,
    this.align,
  });

  final fontFamily = "BeVietnamPro";

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      textAlign: align,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontFamily: fontFamily,
        fontWeight: fontWeight,
      ),
    );
  }
}

class TextInter extends StatelessWidget {
  late final String? text;
  late final double? fontSize;
  late final Color? color;
  late final FontWeight? fontWeight;
  late final TextAlign? align;

  TextInter({
    required this.text,
    this.color,
    required this.fontSize,
    this.fontWeight,
    this.align,
  });

  final fontFamily = "Inter";

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      textAlign: align,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontFamily: fontFamily,
        fontWeight: fontWeight,
      ),
    );
  }
}

class TextEpilogue extends StatelessWidget {
  late final String? text;
  late final double? fontSize;
  late final Color? color;
  late final FontWeight? fontWeight;
  late final TextAlign? align;

  TextEpilogue({
    required this.text,
    this.color,
    required this.fontSize,
    this.fontWeight,
    this.align,
  });

  final fontFamily = "Onest";

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      textAlign: align,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontFamily: fontFamily,
        fontWeight: fontWeight,
        height: 1.1,
      ),
    );
  }
}

class TextOnest extends StatelessWidget {
  late final String? text;
  late final double? fontSize;
  late final Color? color;
  late final FontWeight? fontWeight;
  late final TextAlign? align;

  TextOnest({
    required this.text,
    this.color,
    required this.fontSize,
    this.fontWeight,
    this.align,
  });

  final fontFamily = "Onest";

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      textAlign: align,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontFamily: fontFamily,
        fontWeight: fontWeight,
        height: 1.1,
      ),
    );
  }
}
