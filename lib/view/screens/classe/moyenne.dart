// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'dart:async';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sysgesco/controllers/moyenne_controller.dart';
import 'package:sysgesco/controllers/trimestre_controller.dart';
import 'package:sysgesco/models/trimestre_model.dart';

import '../../../controllers/eleve_controller.dart';
import '../../../controllers/matiere_controller.dart';
import '../../../functions/colors.dart';
import '../../../functions/custom_text.dart';
import '../../../functions/dialoguetoast.dart';
import '../../../functions/fonctions.dart';
import '../../../models/eleve_model.dart';
import '../../../models/matiere_model.dart';

class MoyennePage extends StatefulWidget {
  const MoyennePage({super.key});

  @override
  State<MoyennePage> createState() => _MoyennePageState();
}

class _MoyennePageState extends State<MoyennePage> {
  late Future<List<ElevesModel>> feedEleve;
  List<TrimestreModel> feedTrimestre = [];
  List<MatiereModel> feedMatiere = [];
  List<ElevesModel> listEleve = [];
  List<TextEditingController> editController = [];

  int idValue = 0;
  String value = '-- choisir un Trimestre --';
  final listTrimestre = ['-- choisir un Trimestre --'];
  String choixTrimestre = "-- choisir un Trimestre --";

  final listMatiere = ['-- choisir une matière --'];
  String valueMat = '-- choisir une matière --';
  String choixMatiere = "-- choisir une matière --";
  int idValueMat = 0;

  int classeID = 0;
  int anneeID = 0;

  late SharedPreferences? saveClasseID;
  late SharedPreferences? saveLastAnneeID;

  bool loading = false;

  loadEleve() async {
    Future<List<ElevesModel>> result =
        Eleve().listEleve(id1: classeID, id2: anneeID);
    setState(() {
      feedEleve = result;
    });

    listEleve = await result;
    debugPrint(listEleve.length.toString());

    editController.clear();

    setState(() {
      for (var i = 0; i < listEleve.length; i++) {
        editController.add(TextEditingController());
      }
      debugPrint(editController.length.toString());
    });
  }

  void checkID() async {
    saveClasseID = await SharedPreferences.getInstance();
    saveLastAnneeID = await SharedPreferences.getInstance();

    saveClasseID = await SharedPreferences.getInstance();
    saveLastAnneeID = await SharedPreferences.getInstance();

    setState(() {
      anneeID = (saveLastAnneeID!.getInt('lastAnneeID') ?? 0);
      classeID = (saveClasseID!.getInt('classeID') ?? 0);
      anneeID = (saveLastAnneeID!.getInt('lastAnneeID') ?? 0);
      classeID = (saveClasseID!.getInt('classeID') ?? 0);
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

    List<MatiereModel> results = await Matiere().listMatiere();
    setState(() {
      feedMatiere = results;
    });

    for (var i = 0; i < feedMatiere.length; i++) {
      setState(() {
        listMatiere.add(feedMatiere[i].libelleMatieres.toString());
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
                    choixMatiere,
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
              Expanded(
                  child: (loading) ? elemntInList() : pageLoading(context)),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            debugPrint(editController.length.toString());
            bool pass = true;
            int forget = 0;

            for (var i = 0; i < editController.length; i++) {
              if (editController[i].text.isEmpty) {
                setState(() {
                  pass = false;
                  forget++;
                });
              }
            }

            if (pass) {
              for (var i = 0; i < editController.length; i++) {
                debugPrint(editController[i].text);
                int id = int.parse(listEleve[i].idEleve ?? "0");

                if (editController[i].text.isNotEmpty) {
                  await Moyenne().insertMoyenne(
                      editController[i].text.toString(),
                      id,
                      anneeID,
                      classeID,
                      idValue,
                      idValueMat
                      );
                }
              }
            } else {
              DInfo.toastError(
                  " Oupps!!!! vous avez oublié de remplir $forget note(s) !!");
              setState(() {
                forget = 0;
              });
            }

            if (pass) {
              dialogueNote(context, "enregistrement en cours..");
              Timer(const Duration(milliseconds: 2000), () {
                CoolAlert.show(
                  context: context,
                  type: CoolAlertType.success,
                  title: "Insertion de Moyenne",
                  text: "Enregistrement Effectué avec Success",
                  loopAnimation: true,
                  confirmBtnText: 'OK',
                  barrierDismissible: false,
                  confirmBtnColor: tealClaire(),
                  backgroundColor: teal(),
                  onConfirmBtnTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                );
              });
            }
          },
          elevation: 10.0,
          backgroundColor: amberFone(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          label: CustomText(
            "enregistrer",
            fontWeight: FontWeight.w600,
          ),
          icon: const Icon(Icons.save),
        ));
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
                return CardEleveNote(item, editController[index]);
              });
        });
  }

  CardEleveNote(ElevesModel eleve, TextEditingController controller) {
    return Card(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.only(left: 0.5, right: 0.5),
        child: ListTile(
          onTap: () {},
          title: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: CustomText(
                    "${eleve.nomEleve}  ${eleve.prenomEleve}",
                    tex: TailleText(context).soustitre * 0.8,
                    color: noir(),
                    textAlign: TextAlign.left,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                  child: Container(
                      color: teal().withOpacity(0.3),
                      child: TextField(
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        controller: controller,
                      )))
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
                          "Selectionnez....",
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
                            value: valueMat,
                            isExpanded: true,
                            items: listMatiere.map(buildMenuItem).toList(),
                            iconSize: 30,
                            iconEnabledColor: Colors.blueGrey,
                            onChanged: ((value) {
                              stfsetState(() {
                                valueMat = value!;
                              });
                              setState(() {
                                valueMat = value!;
                              });
                            }))),
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
                              if (value == listTrimestre[0] ||
                                  valueMat == listMatiere[0]) {
                                DInfo.toastError("Faites un Choix svp !!");
                              } else {
                                setState(() {
                                  choixTrimestre = value;
                                  choixMatiere = valueMat;
                                });
                                searchId();

                                Timer(const Duration(milliseconds: 1000), () {
                                  setState(() {
                                    loading = true;
                                  });
                                  loadEleve();
                                  Navigator.of(context).pop();
                                });
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
    for (var i = 0; i < feedMatiere.length; i++) {
      if (valueMat == feedMatiere[i].libelleMatieres.toString()) {
        setState(() {
          idValueMat = int.parse(feedMatiere[i].idMatieres.toString());
        });
      }
    }

    for (var i = 0; i < feedTrimestre.length; i++) {
      if (value == feedTrimestre[i].libelleTrimestre.toString()) {
        setState(() {
          idValue = int.parse(feedTrimestre[i].idTrimestre.toString());
        });
      }
    }

    debugPrint("  trimestre : $idValue , matiere : $idValueMat ");
  }
}
