import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'https://api.dify.ai/v1'; // Arkadaşından doğrula
  static const String apiKey = 'app-sSUEH7mJmlsecDJEdbPcbckt'; // Verdiğin API key
  static String? token;

  // Token'ı SharedPreferences'tan yükle (opsiyonel, API key ile çalışabiliriz)
  static Future<void> _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
  }

  // Giriş yapma (eğer Dify'da login endpoint'i varsa)
  static Future<bool> login(String email, String password) async {
    await _loadToken();
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'), // Endpoint'i arkadaşından doğrula
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey', // API key ile yetkilendirme
      },
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      token = data['token']; // Eğer token dönerse sakla
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token!);
      return true;
    }
    print('Login hatası: ${response.statusCode} - ${response.body}');
    return false;
  }

  // Diyet planını alma
  static Future<List<Map<String, String>>> getDietPlan() async {
    await _loadToken();
    final response = await http.get(
      Uri.parse('$baseUrl/dietplan'), // Endpoint'i arkadaşından doğrula
      headers: {
        'Authorization': 'Bearer $apiKey', // API key ile yetkilendirme
      },
    );

    if (response.statusCode == 200) {
      return List<Map<String, String>>.from(jsonDecode(response.body));
    }
    print('Diyet planı hatası: ${response.statusCode} - ${response.body}');
    throw Exception('Diyet planı yüklenemedi');
  }

  // Chatbot’a soru sorma
  static Future<String> askChatbot(String question) async {
    await _loadToken();
    final response = await http.post(
      Uri.parse('$baseUrl/chatbot'), // Endpoint'i arkadaşından doğrula
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey', // API key ile yetkilendirme
      },
      body: jsonEncode({'question': question}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['answer'] as String; // Dify'dan gelen yanıtı döndür (alan adı değişebilir)
    }
    print('Chatbot hatası: ${response.statusCode} - ${response.body}');
    throw Exception('Chatbot yanıtı alınamadı');
  }
}