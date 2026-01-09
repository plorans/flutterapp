import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tournament_stat.dart';

class ApiService {
  static const String baseUrl =
      'https://geekcollector.com/wp-json/geekcollector/v1';

  static Future<List<TournamentStat>> fetchTournamentStats({
    required String tcg,
    required String mes,
    String tipo = 'torneos',
  }) async {
    final uri = Uri.parse(
      '$baseUrl/tournament-stats'
      '?tcg=$tcg&mes=$mes&tipo=$tipo',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Error loading stats');
    }

    final json = jsonDecode(response.body);

    if (json['success'] != true) {
      throw Exception('API error');
    }

    return (json['data'] as List)
        .map((e) => TournamentStat.fromJson(e))
        .toList();
  }
}
