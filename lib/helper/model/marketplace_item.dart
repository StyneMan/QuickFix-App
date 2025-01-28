class MarketPlaceItem {
  final int id;
  final String title;
  final List<String> images;
  final String details;
  final double amount;

  MarketPlaceItem({
    required this.id,
    required this.title,
    required this.images,
    required this.details,
    required this.amount,
  });
}

List<MarketPlaceItem> marketplaceItems = [
  MarketPlaceItem(
    id: 1,
    title: 'Mustang v6',
    images: ["assets/images/mustang.jpeg", "assets/images/catepillar.jpeg"],
    amount: 18000000.00,
    details:
        "Lorem ipsum dolor sit amet consectetur. Sit ipsum etiam lobortis nunc. Facilisis nec nunc at turpis morbi. Purus pretium eleifend volutpat mauris leo imperdiet sit diam. Molestie molestie velit aliquam dolor risus est nulla. Imperdiet ac lacus morbi nullam cursus. Enim mattis rhoncus feugiat arcu convallis a. Enim quisque tortor adipiscing amet dolor. Facilisis sed velit adipiscing euismod.",
  ),
  MarketPlaceItem(
    id: 2,
    title: '3Bedroom Duplex',
    images: ["assets/images/house.jpeg", "assets/images/mustang.jpeg"],
    amount: 35000000.00,
    details:
        "Lorem ipsum dolor sit amet consectetur. Sit ipsum etiam lobortis nunc. Facilisis nec nunc at turpis morbi. Purus pretium eleifend volutpat mauris leo imperdiet sit diam. Molestie molestie velit aliquam dolor risus est nulla. Imperdiet ac lacus morbi nullam cursus. Enim mattis rhoncus feugiat arcu convallis a. Enim quisque tortor adipiscing amet dolor. Facilisis sed velit adipiscing euismod.",
  ),
  MarketPlaceItem(
    id: 3,
    title: 'Caterpillar',
    images: [
      "assets/images/catepillar.jpeg",
      "assets/images/mustang.jpeg",
      "assets/images/mustang.jpeg"
    ],
    amount: 25000000.00,
    details:
        "Lorem ipsum dolor sit amet consectetur. Sit ipsum etiam lobortis nunc. Facilisis nec nunc at turpis morbi. Purus pretium eleifend volutpat mauris leo imperdiet sit diam. Molestie molestie velit aliquam dolor risus est nulla. Imperdiet ac lacus morbi nullam cursus. Enim mattis rhoncus feugiat arcu convallis a. Enim quisque tortor adipiscing amet dolor. Facilisis sed velit adipiscing euismod.",
  ),
  MarketPlaceItem(
    id: 4,
    title: 'Oil Rig',
    images: ["assets/images/oilrig.jpeg", "assets/images/mustang.jpeg"],
    amount: 135000000.00,
    details:
        "Lorem ipsum dolor sit amet consectetur. Sit ipsum etiam lobortis nunc. Facilisis nec nunc at turpis morbi. Purus pretium eleifend volutpat mauris leo imperdiet sit diam. Molestie molestie velit aliquam dolor risus est nulla. Imperdiet ac lacus morbi nullam cursus. Enim mattis rhoncus feugiat arcu convallis a. Enim quisque tortor adipiscing amet dolor. Facilisis sed velit adipiscing euismod.",
  ),
  MarketPlaceItem(
    id: 5,
    title: '3Bedroom Duplex',
    images: ["assets/images/house.jpeg", "assets/images/mustang.jpeg"],
    amount: 35000000.00,
    details:
        "Lorem ipsum dolor sit amet consectetur. Sit ipsum etiam lobortis nunc. Facilisis nec nunc at turpis morbi. Purus pretium eleifend volutpat mauris leo imperdiet sit diam. Molestie molestie velit aliquam dolor risus est nulla. Imperdiet ac lacus morbi nullam cursus. Enim mattis rhoncus feugiat arcu convallis a. Enim quisque tortor adipiscing amet dolor. Facilisis sed velit adipiscing euismod.",
  ),
];
