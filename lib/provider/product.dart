import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  ///switching the state of flavorite of a product
  /// 1.) handle it gracefully, by storing the orignal state
  /// 2.) toggle the local state first
  /// 3.) then update it on the database
  /// 4.) if fail, then restore it to original state
  Future<void> toggleFavoriteStatus(String authToken, String userId) async {
    final storeFavorite = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    final url =
        "https://simpleshopping-613e3.firebaseio.com/userFavorite/$userId/$id.json?auth=$authToken";
    try {
      final response = await http.put(url, body: jsonEncode(isFavorite));
      if (response.statusCode >= 400) {}
    } catch (e) {
      isFavorite = storeFavorite;
      notifyListeners();
    }
  }
}
