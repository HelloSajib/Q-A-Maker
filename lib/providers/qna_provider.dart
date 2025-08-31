import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QnAProvider with ChangeNotifier {
  List<Map<String, String>> _history = [];

  List<Map<String, String>> get history => _history;

  void addHistory(List<Map<String, String>> qna) {
    _history.add({"text": qna.toString(), "date": DateTime.now().toString()});
    saveToPrefs();
    notifyListeners();
  }

  void saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('history', _history.map((e) => e.toString()).toList());
  }

  void loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _history = prefs.getStringList('history')?.map((e) => {"text": e}).toList() ?? [];
    notifyListeners();
  }
}
