import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qna_maker/providers/qna_provider.dart';
import 'package:qna_maker/screens/results_screen.dart';
import '../services/api_service.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _textController = TextEditingController();
  bool _isLoading = false;


  List<Map<String, String>> parseQnA(String generatedText) {
    // Simple parser: assumes each Q&A separated by newline and starts with "Q:" / "A:"
    final lines = generatedText.split('\n');
    List<Map<String, String>> qnaList = [];
    String? currentQ;
    String? currentA;

    for (var line in lines) {
      line = line.trim();
      if (line.startsWith("Q:")) {
        currentQ = line.substring(2).trim();
      } else if (line.startsWith("A:")) {
        currentA = line.substring(2).trim();
      }

      if (currentQ != null && currentA != null) {
        qnaList.add({"question": currentQ, "answer": currentA});
        currentQ = null;
        currentA = null;
      }
    }

    // If no structured Q&A found, fallback to single entry
    if (qnaList.isEmpty) {
      qnaList.add({"question": "Generated Content", "answer": generatedText});
    }

    return qnaList;
  }


  void _generateQA() async {
    final text = _textController.text;
    if (text.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final generatedText = await ApiService.generateContent(text);

      // Parse Gemini text into Q&A
      final qnaList = parseQnA(generatedText);

      // Save to history
      Provider.of<QnAProvider>(context,listen: false)
          .addHistory(qnaList, text);

      // Navigate to Result Screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(qnaList: qnaList),
        ),
      );
      setState(() => _isLoading = false);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to generate content")),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Q&A Maker"),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => HistoryScreen()),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              maxLines: 10,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Paste your story, lesson, or topic here",
              ),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _generateQA,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 20),
                child: Text(
                  "Generate Q&A",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
