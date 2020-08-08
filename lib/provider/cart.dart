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
  /// String is the ID for particular cartItems
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  /// return the total price need to pay, by calculating price * quantity for each cart item
  double get totalAmount {
    double total = 0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  /// add item to the cart
  void addItem({String productId, double price, String title}) {
    // update the amount if the item is already in the cart
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
      // else add a new entry
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

  /// remove an item in cart
  void removeSingleItem(String productId) {
    // ignore when it's not in the cart
    if (!_items.containsKey(productId)) return;

    // lower the amount if it's more than 1
    if (_items[productId].quantity > 1)
      _items.update(
          productId,
          (exisingItem) => CartItem(
                id: exisingItem.id,
                price: exisingItem.price,
                quantity: exisingItem.quantity - 1,
                title: exisingItem.title,
              ));
    else {
      // completely remove it from cart when it reaches zero
      _items.remove(productId);
    }
    notifyListeners();
  }

  /// clear the cart
  void clear() {
    _items = {};
    notifyListeners();
  }
}
