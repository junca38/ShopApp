import 'package:ShopApp/models/http_exception.dart';
import 'package:ShopApp/provider/auth.dart';
import 'package:flutter/foundation.dart';
import 'package:ShopApp/provider/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  String authToken;
  String userId;

  update(String token, String id, List<Product> tempItem) {
    authToken = token;
    userId = id;
    _items = tempItem;
  }

  List<Product> _items = [];
  // dummy data
  // Product(
  //   id: 'p1',
  //   title: 'Red Shirt',
  //   description: 'A red shirt - it is pretty red!',
  //   price: 29.99,
  //   imageUrl:
  //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
  // ),
  // Product(
  //   id: 'p2',
  //   title: 'Trousers',
  //   description: 'A nice pair of trousers.',
  //   price: 59.99,
  //   imageUrl:
  //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
  // ),
  // Product(
  //   id: 'p3',
  //   title: 'Yellow Scarf',
  //   description: 'Warm and cozy - exactly what you need for the winter.',
  //   price: 19.99,
  //   imageUrl:
  //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
  // ),
  // Product(
  //   id: 'p4',
  //   title: 'A Pan',
  //   description: 'Prepare any meal you want.',
  //   price: 49.99,
  //   imageUrl:
  //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
  // ),
  // ];
  //bool _showFavoriteOnly = false;

  List<Product> get items {
    // if (_showFavoriteOnly)
    //   return _items.where((item) => item.isFavorite).toList();
    // else
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((item) => item.id == id);
  }

  // Not used, due to it being global, while we only need in local widget
  // void showFavoritesOnly() {
  //   _showFavoriteOnly = true;
  //   notifyListeners();
  // }
  // void showAll() {
  //   _showFavoriteOnly = false;
  //   notifyListeners();
  // }

  Future<void> fetchAndSetProduct([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? '&orderBy="creatorId"&equalTo="$userId"' : '';
    final url =
        'https://simpleshopping-613e3.firebaseio.com/products.json?auth=$authToken$filterString';
    final favoriteUrl =
        'https://simpleshopping-613e3.firebaseio.com/userFavorite/$userId.json?auth=$authToken';
    try {
      final response = await http.get(url);
      //print(json.decode(response.body));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) return;

      final favoriteResponse = await http.get(favoriteUrl);
      final favoriteData = jsonDecode(favoriteResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((productId, productData) {
        loadedProducts.add(Product(
          id: productId,
          title: productData['title'],
          description: productData['description'],
          imageUrl: productData['imageUrl'],
          price: productData['price'],
          isFavorite:
              favoriteData == null ? false : favoriteData[productId] ?? false,
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://simpleshopping-613e3.firebaseio.com/products.json?auth=$authToken&orderBy="creatorId"&equalTo="$userId"';
    try {
      final http.Response response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'creatorId': userId,
            //'isFavorite': product.isFavorite,
          }));
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
    // .catchError((error) {
    //   print(error.toString());
    //   throw error;
    // });
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final foundIndex = _items.indexWhere((product) => product.id == id);
    if (foundIndex >= 0) {
      final url =
          'https://simpleshopping-613e3.firebaseio.com/products/$id.json?auth=$authToken';
      try {
        await http.patch(url,
            body: jsonEncode({
              'title': newProduct.title,
              'description': newProduct.description,
              'price': newProduct.price,
              'imageUrl': newProduct.imageUrl,
            }));
      } catch (e) {
        throw e;
      }
      _items[foundIndex] = newProduct;
      notifyListeners();
    } else
      print('Update Error!');
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://simpleshopping-613e3.firebaseio.com/products/$id.json?auth=$authToken';
    final tobeDeletedIndex = _items.indexWhere((product) => product.id == id);
    var tobeDeletedItem = _items[tobeDeletedIndex];
    _items.removeAt(tobeDeletedIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(tobeDeletedIndex, tobeDeletedItem);
      notifyListeners();
      throw HttpException(errorMsg: "Could not delete Product.");
    }
    tobeDeletedItem = null;
  }
}
