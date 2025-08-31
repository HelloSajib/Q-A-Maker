import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qna_maker/providers/qna_provider.dart';
import '../widgets/qna_tile.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final history = Provider.of<QnAProvider>(context).history;

    return Scaffold(
      appBar: AppBar(title: Text("History")),
      body: history.isEmpty
          ? Center(child: Text("No history yet"))
          : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: history.length,
        itemBuilder: (context, index) {
          final qna = history[index]['text'] ?? "";
          return QnATile(
            question: "Past Q&A #${index + 1}",
            answer: qna,
          );
        },
      ),
    );
  }
}
