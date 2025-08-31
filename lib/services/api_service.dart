import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiKey = "AIzaSyDsVYyILAzY2TQqDSl1XZp4QBIpDf0kcKk";
  static const String endpoint =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  static Future<String> generateContent(String text) async {
    try {
      final body = jsonEncode({
        "contents": [
          {
            "parts": [
              {
                "text": "($text) Generate short questions and answers or mcq type question from the text."
                    " Just give me main text. don't need say me okay. "
                    "here are some short question etc. "
                    "Just give me main content and give me with numbering questions"
                    "And give me nice and interactive way"
                    "don't need to Q: Generated Content etc"
                    "1. Question then the next line will answer like that Answer: ?",
              }
            ],
          },
        ]
      });

      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'X-goog-api-key': apiKey,
        },
        body: body,
      );

      debugPrint('Status: ${response.statusCode}');
      debugPrint('Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Gemini returns output in a structure like:
        // data['candidates'][0]['content'][0]['text']
        if (data['candidates'] != null &&
            data['candidates'].isNotEmpty &&
            data['candidates'][0]['content'] != null &&
            data['candidates'][0]['content']['parts'] != null &&
            data['candidates'][0]['content']['parts'].isNotEmpty) {
          return data['candidates'][0]['content']['parts'][0]['text'] ?? "";
        } else {
          return "No content generated";
        }

      } else {
        throw Exception('Failed to generate content');
      }
    } catch (e) {
      print('Request Error: $e');
      throw Exception('Failed to generate content');
    }
  }
}
