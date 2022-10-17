// ignore_for_file: file_names, unrelated_type_equality_checks

import 'dart:async';

import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sysgesco/controllers/seance_controller.dart';
import '../../../controllers/classe_controller.dart';
import '../../../controllers/matiere_controller.dart';
import '../../../functions/colors.dart';
import '../../../functions/custom_text.dart';
import '../../../functions/dialoguetoast.dart';
import '../../../functions/fonctions.dart';
import '../../../models/classe_model.dart';
import '../../../models/matiere_model.dart';
import '../../../models/seance_model.dart';

class AfficheEmploi extends StatefulWidget {
  const AfficheEmploi({super.key});

  @override
  State<AfficheEmploi> createState() => _AfficheEmploiState();
}

class _AfficheEmploiState extends State<AfficheEmploi> {
  List<ClasseModel> feedClasse = [];
  List<MatiereModel> feedMatiere = [];

  final listClasse = ['-- choisir une classe --'];
  String value = '-- choisir une classe --';
  int idValue = 0;
  String choixClasse = "-- choisir une classe --";

  String choixMatiere = "-- matière --";

  List<GlobalKey> listCard = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
  ];

  late SharedPreferences? saveClasseID;
  late SharedPreferences? saveLastAnneeID;
  late SharedPreferences? saveMatiereID;

  List<SeanceModel> seanceListingLundi = [];
  List<SeanceModel> seanceListingMardi = [];
  List<SeanceModel> seanceListingMercredi = [];
  List<SeanceModel> seanceListingJeudi = [];
  List<SeanceModel> seanceListingVendredi = [];

  int classeID = 0;
  int anneeID = 0;

  bool loading = false;

  loadSeance() async {
    List<SeanceModel> result1 = await Seance().listSeance(1, classeID, anneeID);
    setState(() {
      seanceListingLundi = result1;
    });

    List<SeanceModel> result2 = await Seance().listSeance(2, classeID, anneeID);
    setState(() {
      seanceListingMardi = result2;
    });

    List<SeanceModel> result3 = await Seance().listSeance(3, classeID, anneeID);
    setState(() {
      seanceListingMercredi = result3;
    });

    List<SeanceModel> result4 = await Seance().listSeance(4, classeID, anneeID);
    setState(() {
      seanceListingJeudi = result4;
    });

    List<SeanceModel> result5 = await Seance().listSeance(5, classeID, anneeID);
    setState(() {
      seanceListingVendredi = result5;
    });
  }

  loadClasse() async {
    List<ClasseModel> result = await Classe().listClasse();
    setState(() {
      feedClasse = result;
    });

    for (var i = 0; i < feedClasse.length; i++) {
      setState(() {
        listClasse.add(feedClasse[i].libelleClasse.toString());
      });
    }

    List<MatiereModel> res = await Matiere().listMatiere();
    setState(() {
      feedMatiere = res;
    });
  }

  void checkID() async {
    loadClasse();
    saveClasseID = await SharedPreferences.getInstance();
    saveLastAnneeID = await SharedPreferences.getInstance();

    setState(() {
      anneeID = (saveLastAnneeID!.getInt('lastAnneeID') ?? 0);
      classeID = (saveClasseID!.getInt('classeID') ?? 0);
    });
  }

  @override
  void initState() {
    checkID();
    callsearchDialogue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Voir Emploi du Temps"),
        actions: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    searchClasse(context);
                  },
                  icon: const Icon(Icons.filter_center_focus)),
              Container(
                width: 20,
              ),
            ],
          )
        ],
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
            (loading) ? buildExpand() : pageLoading(context),
          ],
        ),
      )),
    );
  }

  Widget buildExpand() {
    return Column(
      children: [
        expandContain("LUNDI", listCard[0], seanceListingLundi),
        Container(
          height: 15,
        ),
        expandContain("MARDI", listCard[1], seanceListingMardi),
        Container(
          height: 15,
        ),
        expandContain("MERCREDI", listCard[2], seanceListingMercredi),
        Container(
          height: 15,
        ),
        expandContain("JEUDI", listCard[3], seanceListingJeudi),
        Container(
          height: 15,
        ),
        expandContain("VENDREDI", listCard[4], seanceListingVendredi),
        Container(
          height: 70,
        )
      ],
    );
  }

  Widget expandContain(
      String classe, GlobalKey keyCard, List<SeanceModel> listSeance) {
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
        seanceListView(listSeance),
        Container(
          height: 10.0,
        ),
      ],
    );
  }

  seanceListView(List<SeanceModel> listSeance) {
    return (listSeance.isNotEmpty)
        ? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: listSeance.length,
            itemBuilder: (context, index) {
              SeanceModel item = listSeance[index];
              return cardWidget(index, item);
            })
        : Center(
            child: CustomText(
              "Pas de seance dans ce jour",
              color: bleu(),
            ),
          );
  }

  Widget cardWidget(int i, SeanceModel seance) {
    return Container(
        color: (i % 2 == 0) ? bleuClaire() : bleu(),
        margin: const EdgeInsets.only(left: 30, right: 30),
        padding: const EdgeInsets.all(10),
        child: Container(
          margin: const EdgeInsets.only(left: 30, right: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                " ${seance.heureDebut} - ${seance.heureFin} ",
                tex: TailleText(context).soustitre * 0.8,
                textAlign: TextAlign.left,
                fontWeight: FontWeight.w600,
              ),
              CustomText(
                searchNombyID(seance.idMatieres.toString()),
                tex: TailleText(context).soustitre * 0.8,
                textAlign: TextAlign.left,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
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
                            if (value == listClasse[0]) {
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
                            items: listClasse.map(buildMenuItem).toList(),
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
                              searchId();
                              if (value == listClasse[0]) {
                                DInfo.toastError("Faites des Choix svp !!");
                              } else {
                                setState(() {
                                  choixClasse = value;
                                });
                                Timer(const Duration(milliseconds: 200), () {
                                  setState(() {
                                    loading = true;
                                  });
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
    Timer(const Duration(milliseconds: 1000), () {
      searchClasse(context);
    });
  }

  searchId() {
    for (var i = 0; i < feedClasse.length; i++) {
      if (value == feedClasse[i].libelleClasse.toString()) {
        setState(() {
          idValue = int.parse(feedClasse[i].idClasse.toString());
        });
      }
    }

    saveClasseID!.setInt('classeID', int.parse(idValue.toString()));

    setState(() {
      anneeID = (saveLastAnneeID!.getInt('lastAnneeID') ?? 0);
      classeID = (saveClasseID!.getInt('classeID') ?? 0);
    });

    debugPrint(" idClasse : $classeID , idAnnee $anneeID");

    Timer(const Duration(milliseconds: 100), () {
      loadSeance();
    });
  }

  searchNombyID(String j) {
    for (var i = 0; i < feedMatiere.length; i++) {
      if (j == feedMatiere[i].idMatieres.toString()) {
        return feedMatiere[i].libelleMatieres.toString();
      }
    }
    return "defaut";
  }
}
