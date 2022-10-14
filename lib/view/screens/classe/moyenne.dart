import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sysgesco/controllers/trimestre_controller.dart';
import 'package:sysgesco/models/trimestre_model.dart';

import '../../../controllers/eleve_controller.dart';
import '../../../functions/colors.dart';
import '../../../functions/custom_text.dart';
import '../../../functions/dialoguetoast.dart';
import '../../../functions/fonctions.dart';
import '../../../models/eleve_model.dart';

class MoyennePage extends StatefulWidget {
  const MoyennePage({super.key, required this.matiere});

  final String matiere;

  @override
  State<MoyennePage> createState() => _MoyennePageState();
}

class _MoyennePageState extends State<MoyennePage> {
  late Future<List<ElevesModel>> feedEleve;
  List<TrimestreModel> feedTrimestre = [];

  int idValue = 0;
  String value = '-- choisir un Trimestre --';
  final listTrimestre = ['-- choisir un Trimestre --'];
  String choixTrimestre = "-- choisir un Trimestre --";

  int classeID = 0;
  int anneeID = 0;

  late SharedPreferences? saveClasseID;
  late SharedPreferences? saveLastAnneeID;

  bool loading = false;
  

  loadEleve() {
    Future<List<ElevesModel>> result = Eleve().listEleve(id1: classeID, id2: anneeID);
    setState(() {
      feedEleve = result;
    });
  }

  void checkID() async {
    saveClasseID = await SharedPreferences.getInstance();
    saveLastAnneeID = await SharedPreferences.getInstance();

    anneeID = (saveLastAnneeID!.getInt('lastAnneeID') ?? 0);
    classeID = (saveClasseID!.getInt('classeID') ?? 0);

    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        loading = true;
      });
      loadEleve();
    });
  }

  loadTrimestre() async {
    List<TrimestreModel> result = await Trimestre().listTrimestre();

    setState(() {
      feedTrimestre = result;
    });

    for (var i = 0; i < feedTrimestre.length; i++) {
      setState(() {
        listTrimestre.add(feedTrimestre[i].libelleTrimestre.toString());
      });
    }
  }

  @override
  void initState() {
    loadTrimestre();
    checkID();
    callsearchDialogue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Moyenne"),
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
        child: Column(
          children: [
            Container(
              color: Colors.grey.shade400,
              child: Column(children: [
                Container(
                  height: 15,
                ),
                CustomText(
                  widget.matiere,
                  tex: 1.25,
                  color: blanc(),
                  fontWeight: FontWeight.w600,
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
                      width: 40,
                    ),
                  ],
                ),
                CustomText(
                  " $choixTrimestre ",
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
              height: 5,
            ),
            Expanded(child: (loading) ? elemntInList() : pageLoading(context)),
          ],
        ),
      ),
    );
  }

  Widget elemntInList() {
    return FutureBuilder<List<ElevesModel>>(
        future: feedEleve,
        builder:
            (BuildContext context, AsyncSnapshot<List<ElevesModel>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text("No Connection"),
            );
          }
          if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No data"),
            );
          }
          List<ElevesModel>? data = snapshot.data;

          return ListView.builder(
              itemCount: data!.length,
              itemBuilder: (context, index) {
                ElevesModel item = data[index];
                return cardWidget(item);
              });
        });
  }

  Widget cardWidget(ElevesModel element) {
    return Card(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.only(left: 0.5, right: 0.5),
        child: ListTile(
          leading: Stack(children: [
            CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Center(
                  child: Icon(
                Icons.account_circle,
                size: 40,
                color: gris(),
              )),
            ),
          ]),
          title: Row(
            children: [
              Expanded(
                child: CustomText(
                  "${element.nomEleve}  ${element.prenomEleve}",
                  tex: TailleText(context).soustitre * 0.8,
                  color: noir(),
                  textAlign: TextAlign.left,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomText(
                    '  10  ',
                    color: amberFone(),
                    tex: TailleText(context).titre * 0.95,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /* boite de DiColor.fromARGB(255, 100, 75, 73)Classe  */
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
                          "Choisir un Trimestre ",
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                          tex: TailleText(context).titre,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            if (choixTrimestre == listTrimestre[0]) {
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
                            items: listTrimestre.map(buildMenuItem).toList(),
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
                              if (value == listTrimestre[0]) {
                                DInfo.toastError("Faites un Choix svp !!");
                              } else {
                                setState(() {
                                  choixTrimestre = value;
                                });
                                searchId();
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
    Timer(const Duration(milliseconds: 500), () {
      searchClasse(context);
    });
  }

  searchId() {
    for (var i = 0; i < feedTrimestre.length; i++) {
      if (value == feedTrimestre[i].libelleTrimestre.toString()) {
        setState(() {
          idValue = int.parse(feedTrimestre[i].idTrimestre.toString());
        });
      }
    }

    debugPrint("  trimestre : $idValue ");
  }
}
