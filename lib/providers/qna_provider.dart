import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class QnAProvider with ChangeNotifier {
  List<Map<String, dynamic>> _history = [];

  List<Map<String, dynamic>> get history => _history;

  QnAProvider() {
    loadFromPrefs();
  }

  void addHistory(List<Map<String, String>> qna, String input) {
    _history.add({
      "input": input,
      "qna": qna,
      "date": DateTime.now().toIso8601String(),
    });
    saveToPrefs();
    notifyListeners(); // 🔑 this is required to update UI
  }


  void saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> encoded = _history.map((e) => jsonEncode(e)).toList();
    await prefs.setStringList('qna_history', encoded);
  }

  void loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? encoded = prefs.getStringList('qna_history');
    if (encoded != null) {
      _history = encoded.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
      notifyListeners();
    }
  }

  void removeHistory(int index) {
    _history.removeAt(index);
    saveToPrefs();
    notifyListeners();
  }

  void clearHistory() {
    _history.clear();
    notifyListeners();
  }


}
