import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class NetworkApp {
  static String? token;
  static final Dio _dio = Dio()..options.connectTimeout = 30000;

  static String baseurl = "";

  NetworkApp._();

  static final NetworkApp _instance = NetworkApp._();

  factory NetworkApp() {
    return _instance;
  }

  static Future<Response> get({
    Map<String, dynamic>? data,
    String? url,
    Map<String, dynamic>? customHeader,
    @required String? path,
  }) async {
    try {
      token = await _getToken();
      final Response res = await _dio.get((url ?? baseurl),
          queryParameters: data,
          options: Options(
              headers: {HttpHeaders.authorizationHeader: 'Bearer $token'}));

      debugPrint("CALLING HEADERS " + res.requestOptions.headers.toString());
      debugPrint("CALIING METHOD " + res.requestOptions.method.toString());
      debugPrint("CALLING PATH " + res.requestOptions.path);

      return res;
    } on DioError catch (e) {
      _errorCatch(e);
      try {
        // ignore: use_rethrow_when_possible
        throw e;
      } catch (e) {
        rethrow;
      }
    } catch (e) {
      throw "Something Went Wrong";
    }
  }

  static void _errorCatch(DioError e) {
    try {
      if (e.response != null) {
        debugPrint("Error HEADERS " + e.requestOptions.headers.toString());
        debugPrint("Error METHOD " + e.requestOptions.method.toString());
        debugPrint("Error CALLING " + e.requestOptions.path.toString());
        debugPrint("Error Status Code " + e.response!.statusCode.toString());
        debugPrint(
            "Error Response " + e.response!.data['error_code'].toString());
        debugPrint('Error Message ' + e.response!.data['message'].toString());
        debugPrint(
            "Error QUERY " + e.requestOptions.queryParameters.toString());
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        debugPrint("CALLING " + e.requestOptions.toString());
        // ignore: avoid_print
        print(e.message);
      }
    } on Exception catch (e) {
      debugPrint("Exception $e");
    }
  }

  static Future<String> _getToken() async {
    // final UserController _controller = controller.Get.find();
    // String _token = await StorageSecure().readValue("token");
    // // String _token;
    // // String userID;
    // // String tokenFcm;
    // // // String _mitraToken;
    // // // debugPrint('user login = ${_controller.isUserLogin()}');
    // // // debugPrint('user login = ${_controller.isMitraLogin()}');

    // // _token = await _storage.read(key: "token");
    // debugPrint('user token = $_token');

    return '';
  }
}
