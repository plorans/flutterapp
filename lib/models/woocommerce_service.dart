class WooCommerceService {
  // ... métodos existentes ...

  Future<UserProfile> getUserProfile(String token) async {
    try {
      final url = Uri.parse('$baseUrl/custom/v1/user-profile');
      
      final response = await client.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserProfile.fromJson(data);
      } else {
        throw Exception('Error obteniendo perfil: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<double> getUserCredit(String token) async {
    try {
      final url = Uri.parse('$baseUrl/custom/v1/user-wallet');
      
      final response = await client.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return double.tryParse(data['credit']?.toString() ?? '0') ?? 0;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }
}