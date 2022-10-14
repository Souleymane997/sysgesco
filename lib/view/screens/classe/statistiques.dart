import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controllers/eleve_controller.dart';
import '../../../functions/colors.dart';
import '../../../functions/custom_text.dart';

class Statistiques extends StatefulWidget {
  const Statistiques({super.key});

  @override
  State<Statistiques> createState() => _StatistiquesState();
}

class _StatistiquesState extends State<Statistiques> {
  int classeID = 0;
  int anneeID = 0;
  late SharedPreferences? saveClasseID;
  late SharedPreferences? saveLastAnneeID;

  int effectifClasse = 0;

  void checkID() async {
    saveClasseID = await SharedPreferences.getInstance();
    saveLastAnneeID = await SharedPreferences.getInstance();

    anneeID = (saveLastAnneeID!.getInt('lastAnneeID') ?? 0);
    classeID = (saveClasseID!.getInt('classeID') ?? 0);

    Timer(const Duration(milliseconds: 100), () async {
      String res = await Eleve().countEleve(classeID, anneeID);

      setState(() {
        effectifClasse = int.parse(res);
      });
    });
  }

  @override
  void initState() {
    checkID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistiques"),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            cardMenu("Effectifs", effectifClasse, "assets/stats/eff.png"),
            Container(
              height: 30,
            ),
            cardMenu("Elèves Admis", 00, "assets/stats/admis.png"),
            Container(
              height: 30,
            ),
            cardMenu("Eleves Ajournés", 00, "assets/stats/ajour.png"),
            Container(
              height: 30,
            ),
            cardMenu("Moyenne de la classe", 00, "assets/stats/moy.png"),
            Container(
              height: 30,
            ),
            cardMenu("Plus Forte Moyenne", 00, "assets/stats/fort.png"),
            Container(
              height: 30,
            ),
            cardMenu(" Plus Faible Moyenne", 00, "assets/stats/faible.png"),
            Container(
              height: 30,
            ),
          ],
        ),
      )),
    );
  }

  cardMenu(String option, int nombre, String path) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.18,
      child: Card(
        elevation: 10.0,
        margin: const EdgeInsets.all(5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(
            color: Colors.white,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Image.asset(path),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            option,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: noir(),
                                fontSize: 20 * TailleText(context).soustitre,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 15,
                    ),
                    Text(
                      "$nombre",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: amberFone(),
                          fontSize: 35 * TailleText(context).contenu,
                          fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
