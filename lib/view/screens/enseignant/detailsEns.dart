// ignore_for_file: file_names

import 'dart:async';

import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sysgesco/models/enseignant_model.dart';

import '../../../controllers/classe_controller.dart';
import '../../../controllers/matiere_controller.dart';
import '../../../controllers/seance_controller.dart';
import '../../../functions/colors.dart';
import '../../../functions/custom_text.dart';
import '../../../functions/fonctions.dart';
import '../../../models/classe_model.dart';
import '../../../models/matiere_model.dart';
import '../../../models/seance_model.dart';

class DetailsEnseignants extends StatefulWidget {
  const DetailsEnseignants({super.key, required this.enseignant});

  final EnseignantModel enseignant;
  @override
  State<DetailsEnseignants> createState() => _DetailsEnseignantsState();
}

class _DetailsEnseignantsState extends State<DetailsEnseignants> {
  late EnseignantModel enseig;

  List<ClasseModel> feedClasse = [];
  List<MatiereModel> feedMatiere = [];

  String choixClasse = "-- choisir une classe --";
  String choixMatiere = "-- matière --";

  List<GlobalKey> listCard = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
  ];

  late SharedPreferences? saveLastAnneeID;

  List<SeanceModel> seanceListingLundi = [];
  List<SeanceModel> seanceListingMardi = [];
  List<SeanceModel> seanceListingMercredi = [];
  List<SeanceModel> seanceListingJeudi = [];
  List<SeanceModel> seanceListingVendredi = [];

  int profID = 0;
  int anneeID = 0;

  bool loading = false;

  loadSeance() async {
    List<SeanceModel> result1 =
        await Seance().listSeanceProf(1, profID, anneeID);
    setState(() {
      seanceListingLundi = result1;
    });

    List<SeanceModel> result2 =
        await Seance().listSeanceProf(2, profID, anneeID);
    setState(() {
      seanceListingMardi = result2;
    });

    List<SeanceModel> result3 =
        await Seance().listSeanceProf(3, profID, anneeID);
    setState(() {
      seanceListingMercredi = result3;
    });

    List<SeanceModel> result4 =
        await Seance().listSeanceProf(4, profID, anneeID);
    setState(() {
      seanceListingJeudi = result4;
    });

    List<SeanceModel> result5 =
        await Seance().listSeanceProf(5, profID, anneeID);
    setState(() {
      seanceListingVendredi = result5;
    });
  }

  loadClasse() async {
    List<ClasseModel> result = await Classe().listClasse();
    setState(() {
      feedClasse = result;
    });

    List<MatiereModel> res = await Matiere().listMatiere();
    setState(() {
      feedMatiere = res;
    });
  }

  void checkID() async {
    loadClasse();
    saveLastAnneeID = await SharedPreferences.getInstance();

    setState(() {
      anneeID = (saveLastAnneeID!.getInt('lastAnneeID') ?? 0);
    });

    Timer(const Duration(milliseconds: 2000), () {
      loadSeance();
    });

    Timer(const Duration(milliseconds: 3000), () {
      setState(() {
        loading = true;
      });
    });
  }

  @override
  void initState() {
    enseig = widget.enseignant;
    setState(() {
      profID = int.parse(enseig.idEns.toString());
    });

    checkID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details Enseignants"),
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
                  " ${enseig.nomEns} ${enseig.prenomEns} ",
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
                          "assets/images/scol.png",
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
                  " Telephone : ${enseig.phone} ",
                  tex: 1.25,
                  color: blanc(),
                  fontWeight: FontWeight.w600,
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
      floatingActionButton:(loading) ? FloatingActionButton.extended(
        onPressed: () {
          // Navigator.of(context).push(
          //   SlideRightRoute(child:  const TopPage(), page: const TopPage(), direction: AxisDirection.left),
          // );
        },
        elevation: 10.0,
        backgroundColor: teal(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        label: CustomText(
          "Envoi",
          fontWeight: FontWeight.w600,
        ),
        icon: const Icon(Icons.send),
      ) : Container(),
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
                searchMatierebyID(seance.idMatieres.toString()),
                tex: TailleText(context).soustitre * 0.8,
                textAlign: TextAlign.left,
                fontWeight: FontWeight.w600,
              ),
              CustomText(
                searchClassebyID(seance.idClasse.toString()),
                tex: TailleText(context).soustitre * 0.8,
                textAlign: TextAlign.left,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ));
  }

  searchMatierebyID(String j) {
    for (var i = 0; i < feedMatiere.length; i++) {
      if (j == feedMatiere[i].idMatieres.toString()) {
        return feedMatiere[i].libelleMatieres.toString();
      }
    }
    return "defaut";
  }

  searchClassebyID(String j) {
    for (var i = 0; i < feedClasse.length; i++) {
      if (j == feedClasse[i].idClasse.toString()) {
        return feedClasse[i].libelleClasse.toString();
      }
    }
    return "defaut";
  }
}
