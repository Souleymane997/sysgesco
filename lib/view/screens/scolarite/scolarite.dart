import 'package:flutter/material.dart';

class ScolaritePage extends StatefulWidget {
  const ScolaritePage({super.key});

  @override
  State<ScolaritePage> createState() => _ScolaritePageState();
}

class _ScolaritePageState extends State<ScolaritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scolarite"),
      ),
      body: Container(),
    );
  }
}
