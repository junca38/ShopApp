import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  //String is the ID, cart
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem({String productId, double price, String title}) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (exisitingItem) => CartItem(
            id: exisitingItem.id,
            title: exisitingItem.title,
            quantity: exisitingItem.quantity + 1,
            price: exisitingItem.price),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
            id: DateTime.now().toString(),
            title: title,
            quantity: 1,
            price: price),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;
    if (_items[productId].quantity > 1)
      _items.update(
          productId,
          (exisingItem) => CartItem(
                id: exisingItem.id,
                price: exisingItem.price,
                quantity: exisingItem.quantity - 1,
                title: exisingItem.title,
              ));
    else
      _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
