import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/http_exception.dart';

/* 
  ┌─────────────────────────────────────────────────────────────────────────────┐
  │   NAPOMENA:::::  Koristio sam Firebase kao backhand za authentikaciju       |
  |                                                                             |
  |   Kredencijali :  email:                       password:                    |
  |                   career@tech387.com            Pass123!                    |
  |                   test@gmail.com                test123                     |
  |                                                                             │
  └─────────────────────────────────────────────────────────────────────────────┘
 */

class AuthProvider with ChangeNotifier {
  /* 
  ┌─────────────────────────────────────────────────────────────────────────────┐
  │   Properties                                                                │
  └─────────────────────────────────────────────────────────────────────────────┘
 */
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;
  //Posto nemam ime od trenutno logiranog korisnika, umjesto imena uzimam njegov email za prikaz logiranog korisnika na pocetnom skrinu
  String? _email;

  /* 
  ┌─────────────────────────────────────────────────────────────────────────────┐
  │   Getters                                                                   │
  └─────────────────────────────────────────────────────────────────────────────┘
 */

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

//pomocu ove asinhrone funkcije, preko konstruktora prilikom logiranja preuzimam email iz inputa i dalje ga prosljedjujem na homescreen
  Future<void> emailF(String email) async {
    _email = email;
  }

  String? get email {
    return _email;
  }

  /* 
  ┌─────────────────────────────────────────────────────────────────────────┐
  │ Authenticate                                                            │
  └─────────────────────────────────────────────────────────────────────────┘
 */

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCVQf5ODUNU72hoJBteVJxvyAAmkWdRvAs');

    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final extractedData = json.decode(response.body);

      if (extractedData['error'] != null) {
        throw HttpException(extractedData['error']['message']);
      }

      _token = extractedData['idToken'];
      _userId = extractedData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            extractedData['expiresIn'],
          ),
        ),
      );

      notifyListeners();
      print(json.decode(response.body));

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String()
      });
      prefs.setString('userData', userData);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  /* 
  ┌─────────────────────────────────────────────────────────────────────────┐
  │ Logout                                                                  │
  └─────────────────────────────────────────────────────────────────────────┘
 */

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
