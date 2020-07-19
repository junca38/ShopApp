import 'package:ShopApp/provider/cart.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.dateTime,
    @required this.products,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> get orders {
    return [..._orders];
  }

  String authToken;
  String userId;
  update(String auth, List<OrderItem> prevOrder, String id) {
    authToken = auth;
    if (prevOrder != null) _orders = prevOrder;
    userId = id;
  }

  Future<void> fetchAndSetOrder(String authToken) async {
    final url =
        'https://simpleshopping-613e3.firebaseio.com/orders/$userId.json?auth=$authToken';
    final List<OrderItem> loadedOrder = [];
    final response = await http.get(url);
    final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
    if (extractedData == null) return;
    extractedData.forEach((orderId, orderData) {
      loadedOrder.add(OrderItem(
        id: orderId,
        amount: orderData['amount'],
        dateTime: DateTime.parse(orderData['dateTime']),
        products: (orderData['products'] as List<dynamic>)
            .map((item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  quantity: item['quantity'],
                  price: item['price'],
                ))
            .toList(),
      ));
    });
    _orders = loadedOrder.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder({List<CartItem> cartProducts, double total}) async {
    final url =
        'https://simpleshopping-613e3.firebaseio.com/orders.json?auth=$authToken';
    final timestamp = DateTime.now();
    try {
      final http.Response response = await http.post(url,
          body: jsonEncode({
            'amount': total,
            'dateTime': timestamp.toIso8601String(),
            'products': cartProducts
                .map((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'quantity': cp.quantity,
                      'price': cp.price,
                    })
                .toList(),
          }));
      print(jsonDecode(response.body));
      _orders.insert(
          0,
          OrderItem(
              id: jsonDecode(response.body)['name'],
              amount: total,
              dateTime: timestamp,
              products: cartProducts));
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
