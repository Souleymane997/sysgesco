import 'package:flutter/material.dart';

import '../../functions/fonctions.dart';
import 'parametres/annee.dart';
import 'parametres/classe.dart';
import 'parametres/jour.dart';
import 'parametres/matiere.dart';
import 'parametres/migration.dart';
import 'parametres/serveur.dart';
import 'parametres/trimestre.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ParametrePage extends StatefulWidget {
  const ParametrePage({super.key});

  @override
  State<ParametrePage> createState() => _ParametrePageState();
}

class _ParametrePageState extends State<ParametrePage> {
  late SharedPreferences? saveDataUser;

  int statut = 0;

  void checkUserLogin() async {
    saveDataUser = await SharedPreferences.getInstance();

    setState(() {
      statut = saveDataUser!.getInt("role") ?? -1;
    });
  }

  @override
  void initState() {
    checkUserLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Paramètres"),
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
            cardOption("Gestion des Trismestres", const TrismetrePage(),
                context, Icons.settings),
            Container(
              height: 20.0,
            ),
            cardOption("Gestion des Jours ", const JourPage(), context,
                Icons.settings),
            Container(
              height: 20.0,
            ),
            cardOption("Migration des élèves", const MigrationElevePage(), context,
                Icons.settings),
            Container(
              height: 20.0,
            ),
            (statut == 0)
                ? cardOption("Gestion du Serveur", const ServeurPage(), context,
                    Icons.settings)
                : Container(),
            Container(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
