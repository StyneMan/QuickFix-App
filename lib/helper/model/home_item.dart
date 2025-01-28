import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quickfix_app/screens/dashboard/laundry/categories/wash_n_fold.dart';

class SubItem {
  final String title;
  final String description;
  final Widget icon;
  final Widget child;

  SubItem({
    required this.title,
    required this.icon,
    required this.description,
    required this.child,
  });
}

class HomeItem {
  final String title;
  final Widget icon;
  final Color bgColor;
  final Color color;
  final List<SubItem> children;

  HomeItem({
    required this.title,
    required this.icon,
    required this.bgColor,
    required this.color,
    required this.children,
  });
}

List homeItems = [
  HomeItem(
    title: 'Laundry',
    icon: Image.asset("assets/images/laundry.png"),
    bgColor: const Color(0xff1a0f9e94),
    color: const Color(0xFF1F1F39),
    children: [
      SubItem(
        title: 'Wash and Fold',
        icon: SvgPicture.asset("assets/images/wash_n_fold.svg"),
        description: 'Wash and neatly folded only.',
        child: const WashAndFold(),
      ),
    ],
  ),
  HomeItem(
    title: 'Cleaning',
    icon: Image.asset("assets/images/cleaning.png"),
    bgColor: const Color(0xff1a0f9e94),
    color: const Color(0xFF1F1F39),
    children: [
      SubItem(
        title: 'Duplex',
        icon: SvgPicture.asset("assets/images/duplex.svg"),
        description: 'House with more floors',
        child: const WashAndFold(),
      ),
      SubItem(
        title: 'Flat',
        icon: SvgPicture.asset("assets/images/flat.svg"),
        description: 'A house with only one floor',
        child: const SizedBox(),
      )
    ],
  ),
  HomeItem(
    title: 'Car Wash',
    icon: Image.asset("assets/images/car_wash.png"),
    bgColor: const Color(0xff1a0f9e94),
    color: const Color(0xFF1F1F39),
    children: [
      SubItem(
        title: 'Wash and Fold',
        icon: SvgPicture.asset("assets/images/laundry.svg"),
        description: 'Wash and neatly folded only.',
        child: const WashAndFold(),
      ),
      SubItem(
        title: 'Wash and Dry Cleaned',
        icon: SvgPicture.asset("assets/images/laundry.svg"),
        description: 'Wash, ironed and starched.',
        child: const SizedBox(),
      )
    ],
  ),
  HomeItem(
    title: 'Track Order',
    icon: Image.asset("assets/images/track_order.png"),
    bgColor: const Color(0xff1a0f9e94),
    color: const Color(0xFF1F1F39),
    children: [
      SubItem(
        title: 'Wash and Fold',
        icon: SvgPicture.asset("assets/images/laundry.svg"),
        description: 'Wash and neatly folded only.',
        child: const WashAndFold(),
      ),
      SubItem(
        title: 'Wash and Dry Cleaned',
        icon: SvgPicture.asset("assets/images/laundry.svg"),
        description: 'Wash, ironed and starched.',
        child: const SizedBox(),
      )
    ],
  ),
];
