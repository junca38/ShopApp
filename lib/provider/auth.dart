import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> _authenticate(
      String email, String password, String urlSeg) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSeg?key=AIzaSyAyVX-Wf9vZqd-a5cuAZWHUBVUGlByWZ_k";
    final response = await http.post(url,
        body: jsonEncode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }));
    //print(jsonDecode(response.body));
  }
}
