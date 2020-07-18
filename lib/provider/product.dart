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
