
// ignore_for_file: file_names

import 'dart:async';

import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import '../../../functions/colors.dart';
import '../../../functions/custom_text.dart';
import '../../../functions/dialoguetoast.dart';
import '../../../functions/fonctions.dart';



class AfficheEmploi extends StatefulWidget {
  const AfficheEmploi({super.key});

  @override
  State<AfficheEmploi> createState() => _AfficheEmploiState();
}

class _AfficheEmploiState extends State<AfficheEmploi> {
  final classe = [
    '-- choisir une classe --',
    'Sixième A',
    'Sixième B',
    'Sixième C'
  ];

  String value = '-- choisir une classe --';

  List<GlobalKey> listCard = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
  ];

  String choixClasse = "";

  @override
  void initState() {
    callsearchDialogue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Voir Emploi du Temps"),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              color: grisee(),
              child: Column(children: [
                Container(
                  height: 15,
                ),
                CustomText(
                  choixClasse,
                  tex: 1.25,
                  color: blanc(),
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
                        width: 20,
                        height: 20,
                        child: Image.asset(
                          "assets/images/classroom.png",
                          fit: BoxFit.fill,
                          color: gris(),
                        )),
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
                  height: 15,
                ),
                CustomText(
                  "Emploi du Temps",
                  tex: 0.85,
                  color: gris(),
                  fontWeight: FontWeight.w600,
                ),
                Container(
                  height: 15,
                ),
              ]),
            ),
            Container(
              height: 25,
            ),
            buildExpand(),
          ],
        ),
      )),
    );
  }

  Widget buildExpand() {
    return Column(
      children: [
        expandContain("LUNDI", listCard[0]),
        Container(
          height: 15,
        ),
        expandContain("MARDI", listCard[1]),
        Container(
          height: 15,
        ),
        expandContain("MERCREDI", listCard[2]),
        Container(
          height: 15,
        ),
        expandContain("JEUDI", listCard[3]),
        Container(
          height: 15,
        ),
        expandContain("VENDREDI", listCard[4]),
        Container(
          height: 70,
        )
      ],
    );
  }

  Widget expandContain(String classe, GlobalKey keyCard) {
    return ExpansionTileCard(
      baseColor: grisee(),
      expandedColor: grisee(),
      initiallyExpanded: true,
      animateTrailing: true,
      borderRadius: const BorderRadius.all(Radius.circular(0.0)),
      key: keyCard,
      elevation: 0.0,
      title: Row(
        children: [
          CircleAvatar(
            backgroundColor: bleuClaire(),
            child: Center(
                child: Icon(
              Icons.brightness_1_rounded,
              size: 20,
              color: bleu(),
            )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomText(
              classe,
              tex: TailleText(context).soustitre,
              textAlign: TextAlign.center,
              color: noir(),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      children: <Widget>[
        Container(
          height: 8.0,
        ),
        cardWidget(1),
        cardWidget(2),
        cardWidget(3),
        Container(
          height: 10.0,
        ),
      ],
    );
  }

  Widget cardWidget(int i) {
    return Container(
        color: (i % 2 == 0) ? bleuClaire() : bleu(),
        margin: const EdgeInsets.only(left: 30, right: 30),
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomText(
              " 08:00 - 10:00 ",
              tex: TailleText(context).soustitre * 0.8,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w600,
            ),
            CustomText(
              " : ",
              tex: TailleText(context).soustitre * 0.8,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w500,
            ),
            CustomText(
              " HIST-GEO ",
              tex: TailleText(context).soustitre * 0.8,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w600,
            ),
          ],
        ));
  }

  /* boite de Dialogue de Classe  */
  Future<void> searchClasse(BuildContext parentContext) async {
    return await showDialog(
        context: parentContext,
        barrierDismissible: false,
        builder: (dialogcontext) => StatefulBuilder(
            builder: (stfContext, stfsetState) => SimpleDialog(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  contentPadding: const EdgeInsets.only(top: 2.0),
                  backgroundColor: Colors.white,
                  title: Row(
                    children: [
                      Expanded(
                        child: CustomText(
                          "Choisir une Classe",
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                          tex: TailleText(context).titre,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            if (value == classe[0]) {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            } else {
                              Navigator.of(context).pop();
                            }
                          },
                          icon: Icon(
                            Icons.close,
                            color: teal(),
                          )),
                    ],
                  ),
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                        margin: const EdgeInsets.only(left: 15, right: 15),
                        padding: const EdgeInsets.only(left: 15),
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.4,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10)),
                        child: DropdownButton<String>(
                            underline: Container(),
                            icon: const Icon(Icons.arrow_drop_down,
                                color: Colors.blueGrey),
                            value: value,
                            isExpanded: true,
                            items: classe.map(buildMenuItem).toList(),
                            iconSize: 30,
                            iconEnabledColor: Colors.blueGrey,
                            onChanged: ((value) {
                              stfsetState(() {
                                this.value = value!;
                              });
                              setState(() {
                                this.value = value!;
                              });
                            }))),
                    const SizedBox(
                      height: 25,
                    ),
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.teal,
                              padding:
                                  const EdgeInsets.only(left: 12, right: 12),
                              shadowColor: Colors.teal.shade300,
                              elevation: 5.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            onPressed: () {
                              if (value == classe[0]) {
                                DInfo.toastError("Faites des Choix svp !!");
                              } else {
                                setState(() {
                                  choixClasse = value;
                                });
                                Navigator.of(context).pop();
                              }
                            },
                            child: CustomText(
                              "soumettre",
                              color: Colors.white,
                              tex: 0.85,
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                )));
  }

  callsearchDialogue() {
    Timer(const Duration(milliseconds: 100), () {
      searchClasse(context);
    });
  }
}
