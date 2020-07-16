import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testtask/Models/AddWishListRequestModel.dart';
import 'package:testtask/Models/AddWishListResponseModel.dart';
import 'package:testtask/Models/LoginRequestModel.dart';
import 'package:testtask/Models/LoginResponseModel.dart';
import 'package:testtask/Common/Globals.dart' as Globals;

class Webservice {

  Future<LoginResponse> login(LoginRequest request) async {
    final http.Response response = await http.post(
      'http://kard-user.herokuapp.com/user/login',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': request.email,
        'password': request.password
      }),
    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return LoginResponse.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception(response.reasonPhrase);
    }
  }

  Map<String, dynamic> parseJwtPayLoad(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    return payloadMap;
  }

//  Map<String, dynamic> parseJwtHeader(String token) {
//    final parts = token.split('.');
//    if (parts.length != 3) {
//      throw Exception('invalid token');
//    }
//
//    final payload = _decodeBase64(parts[0]);
//    final payloadMap = json.decode(payload);
//    if (payloadMap is! Map<String, dynamic>) {
//      throw Exception('invalid payload');
//    }
//
//    return payloadMap;
//  }

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }


  Future<AddWishListResponseModel> addWishList(AddWishListRequestModel request) async {

    final AppPreference = await SharedPreferences.getInstance();

    String token = AppPreference.getString(Globals.AppToken);
    Map<String, dynamic> tokenData = parseJwtPayLoad(token);
    String sessionId = tokenData["sub"];

    final http.Response response = await http.post(
      'http://kard-wishlist.herokuapp.com/wishlist',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': request.name,
        'image': request.image,
        "price" : request.price,
        "code" : request.code,
        "sessionId" : sessionId,
        "url" : request.url
      }),
    );

    if (response.statusCode == 201) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return AddWishListResponseModel.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception(response.reasonPhrase);
    }
  }

}