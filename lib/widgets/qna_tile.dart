import 'package:flutter/material.dart';

class QnATile extends StatelessWidget {
  final String question;
  final String answer;
  const QnATile({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Q: $question",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 6),
            Text("A: $answer", style: TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
