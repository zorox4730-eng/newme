import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/app_models.dart';

class GeminiService {
  static Future<String> getGeminiResponse(
    String apiKey, 
    String message, 
    List<Task> tasks, 
    List<JournalEntry> journal,
    String aiName,
    String language
  ) async {
    try {
      // استخدام النهاية المستقرة v1 وموديل 1.5-flash
      final url = Uri.parse('https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent?key=$apiKey');
      
      final String langContext = language == "ar" ? "باللغة العربية" : "in English";
      final context = "أنت مساعد ذكي اسمه '$aiName'. أنت تعمل داخل تطبيق 'أنا الجديد'. المهام: ${tasks.map((t) => t.title).join(", ")}. الرد $langContext.";

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': context + "\n\nالمستخدم: " + message}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        final error = jsonDecode(response.body);
        return "خطأ من جوجل (${response.statusCode}): ${error['error']['message'] ?? 'فشل الاتصال'}";
      }
    } catch (e) {
      return "خطأ في الاتصال: $e";
    }
  }
}
