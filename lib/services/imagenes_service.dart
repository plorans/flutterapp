import 'dart:typed_data';
import 'package:http/http.dart' as http;

class ImageService {
  // Método para limpiar URLs de WordPress
  static String cleanUrl(String url) {
    return url.replaceAll(r'\', '');
  }
  
  // Método simple para descargar imágenes
  static Future<Uint8List?> downloadImage(String url) async {
    try {
      final cleanedUrl = cleanUrl(url);
      
      final response = await http.get(
        Uri.parse(cleanedUrl),
        headers: {
          'User-Agent': 'Mozilla/5.0',
          'Accept': 'image/*',
        },
      );
      
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
      print('Error HTTP ${response.statusCode} para imagen: $cleanedUrl');
      return null;
    } catch (e) {
      print('Error descargando imagen: $e');
      return null;
    }
  }
}