// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:async';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sysgesco/controllers/ens_controller.dart';
import 'package:sysgesco/controllers/jour_controller.dart';
import 'package:sysgesco/models/enseignant_model.dart';
import 'package:sysgesco/models/seance_model.dart';

import '../../../controllers/classe_controller.dart';
import '../../../controllers/matiere_controller.dart';
import '../../../controllers/seance_controller.dart';
import '../../../functions/colors.dart';
import '../../../functions/custom_text.dart';
import '../../../functions/dialoguetoast.dart';
import '../../../functions/fonctions.dart';
import '../../../models/classe_model.dart';
import '../../../models/jour_model.dart';
import '../../../models/matiere_model.dart';

class CreateEmploi extends StatefulWidget {
  const CreateEmploi({super.key});

  @override
  State<CreateEmploi> createState() => _CreateEmploiState();
}

class _CreateEmploiState extends State<CreateEmploi> {
  List<EnseignantModel> feedEns = [];
  List<ClasseModel> feedClasse = [];
  List<MatiereModel> feedMatiere = [];
  List<JourModel> feedJour = [];

  final listClasse = ['-- choisir une classe --'];
  String value = '-- choisir une classe --';
  int idValue = 0;
  String choixClasse = "-- choisir une classe --";

  final listMatiere = ['-- choisir une matière --'];
  String mat = '-- choisir une matière --';
  int idMat = 0;

  String valueEns = '-- choisir un Enseignant --';
  final listEnseignant = ['-- choisir un Enseignant --'];
  int idEns = 0;

  String valueJour = '-- choisir un Jour --';
  final listJour = ['-- choisir un Jour --'];
  int idJour = 0;

  int anneeID = 0;
  late SharedPreferences? saveLastAnneeID;

  TextEditingController timeDebutController = TextEditingController();
  TimeOfDay selectedTimeDebut = TimeOfDay.now();

  TextEditingController timeFinController = TextEditingController();
  TimeOfDay selectedTimeFin = TimeOfDay.now();

  List<TextEditingController> listController = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  bool loading = false;

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

    for (var i = 0; i < feedMatiere.length; i++) {
      setState(() {
        listMatiere.add(feedMatiere[i].libelleMatieres.toString());
      });
    }

    List<EnseignantModel> results = await Enseignant().listEns();
    setState(() {
      feedEns = results;
    });

    for (var i = 0; i < feedEns.length; i++) {
      setState(() {
        listEnseignant.add("${feedEns[i].nomEns}  ${feedEns[i].prenomEns}");
      });
    }

    List<JourModel> resuls = await Jour().listJour();
    setState(() {
      feedJour = resuls;
    });

    for (var i = 0; i < feedJour.length; i++) {
      setState(() {
        listJour.add(feedJour[i].libelleJour.toString());
      });
    }
  }

  void checkClasseID() async {
    loadClasse();

    saveLastAnneeID = await SharedPreferences.getInstance();
    anneeID = (saveLastAnneeID!.getInt('lastAnneeID') ?? 0);
  }

  @override
  void initState() {
    checkClasseID();
    callsearchDialogue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nouvel Emploi du Temps"), actions: [
        IconButton(
            onPressed: () {
              searchClasse(context);
            },
            icon: const Icon(Icons.filter_center_focus)),
        Container(
          width: 20,
        ),
      ]),
      body: (loading)
          ? SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Center(
                  child: Column(
                children: [
                  Container(
                    height: 15,
                  ),
                  CustomText(
                    " Insertion des Seances de Cours",
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
                          Icons.calendar_month,
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
                    height: 20,
                  ),
                  CustomText(
                    choixClasse,
                    tex: 1.25,
                    color: gris(),
                    fontWeight: FontWeight.w600,
                  ),
                  Container(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    padding:
                        const EdgeInsets.only(left: 10, top: 15, bottom: 15),
                    color: teal(),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomText(
                            "Entrer les Séances de Cours",
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    padding:
                        const EdgeInsets.only(left: 10, top: 15, bottom: 15),
                    color: blanc(),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: expandContainNote(0, listController[0]),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 5,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: teal(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 13.0),
                        shadowColor: Colors.blueGrey,
                        elevation: 8.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () async {
                        searchId();

                        if (idValue != 0 &&
                            idEns != 0 &&
                            idJour != 0 &&
                            idMat != 0 &&
                            anneeID != 0 &&
                            timeDebutController.text.isNotEmpty &&
                            timeFinController.text.isNotEmpty) {
                          debugPrint(timeDebutController.text);
                          debugPrint(timeFinController.text);

                          SeanceModel newSeance = SeanceModel(
                              idAnnee: anneeID.toString(),
                              idClasse: idValue.toString(),
                              idEns: idEns.toString(),
                              idJour: idJour.toString(),
                              idMatieres: idMat.toString(),
                              heureDebut: timeDebutController.text,
                              heureFin: timeFinController.text);

                          bool res =
                              await Seance().insertSeance(newSeance);

                          if (res) {
                            CoolAlert.show(
                              context: context,
                              type: CoolAlertType.success,
                              text: " Seance enregistrée ",
                              loopAnimation: true,
                              confirmBtnText: 'OK',
                              barrierDismissible: false,
                              confirmBtnColor: tealClaire(),
                              backgroundColor: teal(),
                              onConfirmBtnTap: () {
                                Navigator.pop(context);
                                continueInsert();
                              },
                            );
                          } else {
                            DInfo.snackBarError(
                                "Erreur Au Niveau de L'enregistrement !! ",
                                context);
                          }
                        } else {
                          CoolAlert.show(
                            context: context,
                            type: CoolAlertType.error,
                            title: "Erreur !!",
                            text: "Verifier les champs svp ",
                            confirmBtnText: 'OK',
                            confirmBtnColor: Colors.red,
                            backgroundColor: Colors.red.withOpacity(0.4),
                            loopAnimation: true,
                            barrierDismissible: false,
                            onConfirmBtnTap: () {
                              Navigator.pop(context);
                            },
                          );
                        }
                      },
                      child: CustomText("enregistrer",
                          color: Colors.white,
                          tex: TailleText(context).soustitre)),
                ],
              )))
          : pageLoading(context),
    );
  }

  Widget expandContainNote(int i, TextEditingController controller) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            margin: const EdgeInsets.only(left: 15, right: 15),
            padding: const EdgeInsets.only(left: 15),
            height: 50,
            width: MediaQuery.of(context).size.width * 0.85,
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10)),
            child: DropdownButton<String>(
                underline: Container(),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.blueGrey),
                value: mat,
                isExpanded: true,
                items: listMatiere.map(buildMenuItem).toList(),
                iconSize: 30,
                iconEnabledColor: Colors.blueGrey,
                onChanged: ((value) {
                  setState(() {
                    mat = value!;
                  });
                }))),
        Container(
          height: 15,
        ),
        Container(
            margin: const EdgeInsets.only(left: 15, right: 15),
            padding: const EdgeInsets.only(left: 15),
            height: 50,
            width: MediaQuery.of(context).size.width * 0.85,
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10)),
            child: DropdownButton<String>(
                underline: Container(),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.blueGrey),
                value: valueEns,
                isExpanded: true,
                items: listEnseignant.map(buildMenuItem).toList(),
                iconSize: 30,
                iconEnabledColor: Colors.blueGrey,
                onChanged: ((value) {
                  setState(() {
                    valueEns = value!;
                  });
                }))),
        Container(
          height: 15,
        ),
        Container(
            margin: const EdgeInsets.only(left: 15, right: 15),
            padding: const EdgeInsets.only(left: 15),
            height: 50,
            width: MediaQuery.of(context).size.width * 0.85,
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10)),
            child: DropdownButton<String>(
                underline: Container(),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.blueGrey),
                value: valueJour,
                isExpanded: true,
                items: listJour.map(buildMenuItem).toList(),
                iconSize: 30,
                iconEnabledColor: Colors.blueGrey,
                onChanged: ((value) {
                  setState(() {
                    valueJour = value!;
                  });
                }))),
        Container(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () async {
                TimeOfDay? timeOfDay = await showTimePicker(
                    context: context,
                    initialTime: selectedTimeDebut,
                    initialEntryMode: TimePickerEntryMode.dial,
                    cancelText: "retour",
                    confirmText: "valider");

                if (timeOfDay != null) {
                  debugPrint(timeOfDay.toString());
                  setState(() {
                    selectedTimeDebut = timeOfDay;

                    timeDebutController.text =
                        convert(selectedTimeDebut.hour.toString()) +
                            " : " +
                            convert(selectedTimeDebut.minute.toString());
                  });
                }
              },
              child: Container(
                margin: const EdgeInsets.only(left: 15),
                width: MediaQuery.of(context).size.width * 0.3,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: TextFormField(
                    maxLines: 1,
                    enabled: false,
                    controller: timeDebutController,
                    onSaved: (onSavedval) {
                      timeDebutController.text = onSavedval!;
                    },
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          timeDebutController.text.isEmpty) {
                        debugPrint(timeDebutController.text);
                        return "erreur!! ";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Heure Debut",
                      hintText: "Heure Debut",
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal, width: 1),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal, width: 0),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                TimeOfDay? timeOfDay = await showTimePicker(
                    context: context,
                    initialTime: selectedTimeFin,
                    initialEntryMode: TimePickerEntryMode.dial,
                    cancelText: "retour",
                    confirmText: "valider");

                if (timeOfDay != null) {
                  debugPrint(timeOfDay.toString());
                  setState(() {
                    selectedTimeFin = timeOfDay;

                    timeFinController.text =
                        convert(selectedTimeFin.hour.toString()) +
                            " : " +
                            convert(selectedTimeFin.minute.toString());
                  });
                }
              },
              child: Container(
                margin: const EdgeInsets.only(right: 15),
                width: MediaQuery.of(context).size.width * 0.3,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: TextFormField(
                    maxLines: 1,
                    enabled: false,
                    controller: timeFinController,
                    onSaved: (onSavedval) {
                      timeFinController.text = onSavedval!;
                    },
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          timeFinController.text.isEmpty) {
                        debugPrint(timeFinController.text);
                        return "erreur!! ";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Heure Fin ",
                      hintText: "Heure Fin",
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal, width: 1),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal, width: 0),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Container(
          height: 15,
        ),
      ],
    );
  }

  //* verifie l'identifiant et le mot de passe dans la base de donnée

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
                          color: const Color.fromARGB(255, 41, 63, 61),
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
                              if (value == listClasse[0]) {
                                DInfo.toastError("Faites des Choix svp !!");
                              } else {
                                setState(() {
                                  choixClasse = value;
                                  loading = true;
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

    for (var i = 0; i < feedMatiere.length; i++) {
      if (mat == feedMatiere[i].libelleMatieres.toString()) {
        setState(() {
          idMat = int.parse(feedMatiere[i].idMatieres.toString());
        });
      }
    }

    for (var i = 0; i < feedEns.length; i++) {
      if (valueEns == "${feedEns[i].nomEns}  ${feedEns[i].prenomEns}") {
        setState(() {
          idEns = int.parse(feedEns[i].idEns.toString());
        });
      }
    }

    for (var i = 0; i < feedJour.length; i++) {
      if (valueJour == feedJour[i].libelleJour.toString()) {
        setState(() {
          idJour = int.parse(feedJour[i].idJour.toString());
        });
      }
    }

    debugPrint(
        "idClasse : $idValue , idMatiere : $idMat , idEns : $idEns , idJour : $idJour , idAnnee : $anneeID");
  }

  continueInsert() {
    CoolAlert.show(
        context: context,
        type: CoolAlertType.confirm,
        title: "Saisir une Nouvelle Seance",
        loopAnimation: true,
        confirmBtnText: 'OUI',
        cancelBtnText: 'NON',
        barrierDismissible: false,
        confirmBtnColor: bleuClaire(),
        backgroundColor: bleu(),
        onConfirmBtnTap: () {
          setState(() {
            value = '-- choisir une classe --';
            mat = '-- choisir une matière --';
            valueEns = '-- choisir un Enseignant --';
            valueJour = '-- choisir un Jour --';

            timeDebutController.text = "";
            timeFinController.text = "";
          });

          Navigator.pop(context);
        },
        onCancelBtnTap: () {
          Navigator.pop(context);
          Navigator.pop(context);
        });
  }
}
