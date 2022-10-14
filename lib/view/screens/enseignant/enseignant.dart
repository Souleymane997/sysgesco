import 'package:flutter/material.dart';

class EnseignantPages extends StatefulWidget {
  const EnseignantPages({super.key});

  @override
  State<EnseignantPages> createState() => _EnseignantPagesState();
}

class _EnseignantPagesState extends State<EnseignantPages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestion des Enseignants"),
      ),
      body: Container(),
    );
  }
}
