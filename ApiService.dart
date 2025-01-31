import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // لێرە لینکی باک ئێندەکە دانێ: http://localhost:7200/
  static const String _baseUrl = 'https://your-api-url.com';

  
  // ئەمە بەکاربێنە بۆ ئەوانەی کە
  // GET
  Future<Map<String, dynamic>> get(String endpoint) async {
    final url = Uri.parse('$_baseUrl$endpoint');

    try {
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to make request: $e');
    }
  }

    // ئەمە بەکاربێنە بۆ ئەوانەی کە
  // POST
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$_baseUrl/$endpoint');

    try {
      final response = await http.post(
        url,
        headers: {
            'Content-Type': 'application/json'
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to post data');
      }
    } catch (e) {
      throw Exception('Failed to make request: $e');
    }
  }

  // ئەمە بەکاربێنە بۆ ئەوانەی کە
  // PUT
  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$_baseUrl/$endpoint');

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to update data');
      }
    } catch (e) {
      throw Exception('Failed to make request: $e');
    }
  }

  // ئەمە بەکاربێنە بۆ ئەوانەی کە
  // DELETE
  Future<Map<String, dynamic>> delete(String endpoint) async {
    final url = Uri.parse('$_baseUrl/$endpoint');

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to delete data');
      }
    } catch (e) {
      throw Exception('Failed to make request: $e');
    }
  }
}
