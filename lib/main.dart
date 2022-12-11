import 'package:flutter/material.dart';

import 'view/screens/homes/launch.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SYSGESCO',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const Launch(),
      debugShowCheckedModeBanner: false,
    );
  }
}
