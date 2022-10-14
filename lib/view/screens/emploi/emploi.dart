import 'package:flutter/material.dart';

import '../../../functions/colors.dart';
import '../../../functions/custom_text.dart';
import '../../../functions/slidepage.dart';
import 'afficheEmploi.dart';
import 'createEmploi.dart';

class EmploiDuTemps extends StatefulWidget {
  const EmploiDuTemps({super.key});

  @override
  State<EmploiDuTemps> createState() => _EmploiDuTempsState();
}

class _EmploiDuTempsState extends State<EmploiDuTemps> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Emploi du temps"),
      ),
      body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Center(
              child: Column(
            children: [
              Container(
                height: 15,
              ),
              CustomText(
                "EMPLOI DU TEMPS",
                tex: 1.25,
                color: gris(),
                fontWeight: FontWeight.w600,
              ),
              Container(
                height: 10,
              ),
              Row(
                children: [
                  Container(
                    width: 40,
                  ),
                  Expanded(
                    child: Divider(
                      color: gris(),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: Icon(
                      Icons.person,
                      color: gris(),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: gris(),
                    ),
                  ),
                  Container(
                    width: 40,
                  ),
                ],
              ),
              Container(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  cardMenu("assets/images/cedit.png", "Nouvel Emploi du temps",
                      Colors.blue, const CreateEmploi()),
                  cardMenu("assets/images/cal.png", "Voir les Emploi du temps",
                      amberFone(), const AfficheEmploi()),
                ],
              ),
            ],
          ))),
    );
  }

  cardMenu(String chemin, String option, Color color, Widget x) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.35,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            SlideRightRoute(child: x, page: x, direction: AxisDirection.left),
          );
        },
        child: Column(
          children: [
            Card(
              elevation: 10.0,
              margin: const EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13.0),
                side: BorderSide(
                  color: color,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: blanc(),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Image.asset(
                  chemin,
                ),
              ),
            ),
            CustomText(
              option,
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
      ),
    );
  }
}
