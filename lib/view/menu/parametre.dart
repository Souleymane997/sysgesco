import 'package:flutter/material.dart';

import '../../functions/fonctions.dart';
import 'parametres/annee.dart';
import 'parametres/classe.dart';
import 'parametres/matiere.dart';
import 'parametres/serveur.dart';

class ParametrePage extends StatefulWidget {
  const ParametrePage({super.key});

  @override
  State<ParametrePage> createState() => _ParametrePageState();
}

class _ParametrePageState extends State<ParametrePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Parametre"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              height: 15.0,
            ),
            cardOption("Gestion des Matieres", const MatierePage(), context,
                Icons.settings),
            Container(
              height: 20.0,
            ),
            cardOption("Gestion des Classes", const ClassePage(), context,
                Icons.settings),
            Container(
              height: 20.0,
            ),
            cardOption("Gestion des Années Scolaires", const AnneePage(),
                context, Icons.settings),
            Container(
              height: 20.0,
            ),
            cardOption("Gestion des Trismestres", const MatierePage(), context,
                Icons.settings),
            Container(
              height: 20.0,
            ),
            cardOption("Gestion des Jours ", const ServeurPage(), context,
                Icons.settings),
            Container(
              height: 20.0,
            ),
            cardOption("Gestion du Serveur", const ServeurPage(), context,
                Icons.settings),
            Container(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
