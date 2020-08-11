import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ShopApp/models/http_exception.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ShopApp/helpers/Constants.dart';

/// auth class to handle logics: signup, login, logout, autologin, timeout
class Auth with ChangeNotifier {
  String _apiKey = Constants.kAPIKey;
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get userId {
    return _userId;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  /// handle either login or sign up depends on the urlSeg string
  /// https://firebase.google.com/docs/reference/rest/auth
  /// check signup with email and password session
  ///
  /// 1.) connect to firebase to either login or signup
  /// 2.) call autologout to start the timer
  /// 3.) store the login status into shared pref
  Future<void> _authenticate(
      String email, String password, String urlSeg) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSeg?key=$_apiKey";
    try {
      final response = await http.post(url,
          body: jsonEncode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = jsonDecode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(errorMsg: responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(seconds: int.parse(responseData['expiresIn'])),
      );

      /// call auto logout to start the counter for auto logout
      autoLogout();
      notifyListeners();

      ///store the login status in shared Preference
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      prefs.setString('userData', userData);
    } catch (e) {
      throw e;
    }
  }

  /// handle auto login logic
  /// 1.) check if it is in sharedPreference, if so loads it
  /// 2.) check if sharedpreference expired or not, if not restore the login status
  /// 3.) call autologout to update the logout timer
  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) return false;
    final extractedUserData =
        jsonDecode(prefs.getString('userData')) as Map<String, Object>;
    final expirayDate = DateTime.parse(extractedUserData['expiryDate']);
    if (expirayDate.isAfter(DateTime.now())) return false;
    //auto login whe not expired
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expirayDate;
    notifyListeners();
    autoLogout();
    return true;
  }

  /// handle logout logic
  Future<void> logout() async {
    print("logout is called");
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    //clear the shared Preference when logout
    final prefs = await SharedPreferences.getInstance();
    //prefs.clear(); this work too since we are only storing one thing in shared pref
    prefs.remove('userData');
  }

  /// handle the autologout logic
  /// 1.) stop the timer if there is one
  /// 2.) use Timer Function, given the time to expiry, it will call logout logic when timer reaches expiry
  void autoLogout() {
    if (_authTimer != null) _authTimer.cancel();
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
