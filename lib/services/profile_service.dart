import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfileService {
  final String base = 'https://geekcollector.com/wp-json/geekcollector/v1';

  Future<Map<String, dynamic>> fetchProfile(String token) async {
    final url = Uri.parse('$base/profile');
    final resp = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    if (resp.statusCode == 200) {
      return jsonDecode(resp.body) as Map<String, dynamic>;
    } else {
      throw Exception('Error fetching profile: ${resp.statusCode} ${resp.body}');
    }
  }
}
