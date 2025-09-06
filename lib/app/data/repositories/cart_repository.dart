import 'package:myapp/app/domain/entities/cart.dart';
import 'package:myapp/app/domain/entities/product.dart';

class CartRepository {
  final Cart _cart = Cart(items: []);

  Cart getCart() {
    return _cart;
  }

  void addProductToCart(Product product) {
    _cart.items.add(product);
  }

  void removeProductFromCart(Product product) {
    _cart.items.remove(product);
  }

  void clearCart() {
    _cart.items.clear();
  }
}
