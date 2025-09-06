import 'package:myapp/app/domain/entities/product.dart';

class Cart {
  final List<Product> items;

  Cart({required this.items});

  double get totalPrice {
    return items.fold(0.0, (sum, item) => sum + item.price);
  }
}
