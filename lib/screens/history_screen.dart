import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qna_maker/screens/results_screen.dart';
import '../providers/qna_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final history = Provider.of<QnAProvider>(context).history;

    return Scaffold(
      appBar: AppBar(title: const Text("History")),
      body: history.isEmpty
          ? Center(child: Text("No history yet"))
          : ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          final record = history[index];
          final qnaList = List<Map<String, dynamic>>.from(record['qna']);
          final inputText = record['input'] ?? "";
          final preview = inputText.split("\n").take(3).join(" ");
          final date = DateTime.parse(record['date']).toLocal().toString().split('.')[0];

          return Dismissible(
            key: Key(record['date']), // unique key
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
              Provider.of<QnAProvider>(context, listen: false).removeHistory(index);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("History deleted")),
              );
            },
            child: ListTile(
              contentPadding: EdgeInsets.only(left: 20),
              title: Text(
                preview,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(date),
              trailing: IconButton(
                  onPressed: (){
                    Provider.of<QnAProvider>(context, listen: false).removeHistory(index);
                  },
                  icon: Icon(Icons.delete_forever, color: Colors.red,)
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ResultScreen(qnaList: qnaList),
                  ),
                );
              },
            ),
          );
        },
      ),

    );
  }
}
