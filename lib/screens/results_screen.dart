import 'package:flutter/material.dart';
import '../widgets/qna_tile.dart';

class ResultScreen extends StatelessWidget {
  final List<Map<String, dynamic>> qnaList;
  const ResultScreen({super.key, required this.qnaList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Generated Q&A")),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: qnaList.length,
        itemBuilder: (context, index) {
          final item = qnaList[index];
          return QnATile(
            question: item['question'] ?? "",
            answer: item['answer'] ?? "",
          );
        },
      ),
    );
  }
}
