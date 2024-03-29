import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'api_utils.dart';

final apiClientProvider = Provider((ref) => APIClient());

class APIClient {
  Future<dynamic> get(String url) async {
    final response = await http.get(Uri.parse(url));
    return processResponse(response);
  }

  Future<dynamic> post(String url, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse(url),
      body: json.encode(body),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    return processResponse(response);
  }
}
