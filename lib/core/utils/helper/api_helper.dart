import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiHelper {
  Future<dynamic> get({required String url,@required String? token}) async {
    Map<String, String> headers = {};

    if (token != null) {
      headers.addAll({'Authorization': 'Bearer $token'});
    }
    http.Response response = await http.get(Uri.parse(url),headers: headers);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'we found a problem when try to conect server ${response.statusCode}');
    }
  }

  Future<dynamic> post({
    required String url,
    required dynamic body,
    String? token,
  }) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    };

    if (token != null) {
      headers.addAll({'Authorization': 'Bearer $token'});
    }

    try {
      final String requestBody = jsonEncode(body);
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: requestBody,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);

      } else {
        print('Failed to add branch: ${response.statusCode}');

        throw Exception('Failed to connect to server: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error sending POST request: $e');
    }
  }

  Future<dynamic> put(
      {required String url,
        @required dynamic body,
        @required String? token}) async {
    Map<String, String> headers = {};
    if (token != null) {
      headers.addAll({'Authorization': 'Bearer $token'});
    }
    print('url =$url body =$body  ');
    http.Response response = await http.post(
      Uri.parse(url),
      body: body,
    );
    if(response.statusCode ==200) {
      Map<String, dynamic>data = jsonDecode(response.body);
      print(data);
      return data;
    }else{
      throw
      Exception( 'we found a problem when try to conect server ${response.statusCode}');
    }
  }

}
