import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qna_maker/providers/qna_provider.dart';
import 'package:qna_maker/screens/home_screen.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QnAProvider()),
      ],
      child: QnAMakerApp(),
    ),
  );
}

class QnAMakerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Q&A Maker",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
