class OrderItem {
  String name;
  int price;
  int quantity;

  OrderItem({
    required this.name,
    required this.price,
    required this.quantity,
  });

  // fromJson(Map<String, dynamic> json) {
  //   return OrderItem(name: json['name'], price: json['price'], quantity: 0);
  // }
  // Factory method to create a Product from JSON (Map)
  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      name: json['name'] as String,
      price: (json['price'] as int), // Ensures price is double
      quantity: json['quantity'] ?? 0, // Default to 0 if quantity is null
    );
  }

  static Map<String, dynamic> toJson(OrderItem item) {
    return {
      'name': item.name,
      'price': item.price,
      'quantity': item.quantity,
    };
  }
}
