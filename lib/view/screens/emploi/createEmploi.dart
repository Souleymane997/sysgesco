// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter/material.dart';

import '../../../functions/colors.dart';
import '../../../functions/custom_text.dart';
import '../../../functions/dialoguetoast.dart';
import '../../../functions/fonctions.dart';


class CreateEmploi extends StatefulWidget {
  const CreateEmploi({super.key});

  @override
  State<CreateEmploi> createState() => _CreateEmploiState();
}

class _CreateEmploiState extends State<CreateEmploi> {
  TextEditingController timeController = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();

  final depart = [
    '-- choisir une classe --',
    'Sixième A',
    'Sixième B',
    'Sixième C'
  ];

  final listJour = [
    '-- choisir un jour --',
    'Lundi',
    'Mardi',
    'Mercredi',
    'Jeudi',
    'Vendredi'
  ];

  final matiere = ['-- choisir une matière --', 'Français', 'SVT', 'Hist-Geog'];

  final listEnseignant = [
    '-- choisir un enseignant --',
    'Mr KONE',
    'Mr ZONGO',
    'Mr DEMBELE',
    'Mr ZIDA',
    'Mr SIA'
  ];

  String enseignant = '-- choisir un enseignant --';
  String jour = '-- choisir un jour --';
  String value = '-- choisir une classe --';
  String mat = '-- choisir une matière --';

  int nbreNote = 0;

  List<TextEditingController> listController = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

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
        title: const Text("Nouvel Emploi du Temps"),
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
                " Creation D'emploi du Temps ",
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
                padding: const EdgeInsets.only(left: 10, top: 15, bottom: 15),
                color: teal(),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomText(
                        "Entrer les Séances de Cours",
                        textAlign: TextAlign.left,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          nbreNote++;
                          if (nbreNote > 3) {
                            nbreNote = 3;
                          }
                        });
                      },
                      icon: Icon(
                        Icons.add_circle,
                        color: blanc(),
                      ),
                    ),
                    Container(
                      width: 5,
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          nbreNote--;
                          if (nbreNote < 0) {
                            nbreNote = 0;
                          }
                        });
                      },
                      icon: Icon(
                        Icons.remove_circle,
                        color: blanc(),
                      ),
                    ),
                    Container(
                      width: 10,
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                padding: const EdgeInsets.only(left: 10, top: 15, bottom: 15),
                color: blanc(),
                child: Column(
                  children: [
                    (nbreNote > 0)
                        ? Row(
                            children: [
                              Expanded(
                                child: expandContainNote(
                                    "N°1", listCard[0], 0, listController[0]),
                              ),
                            ],
                          )
                        : Container(),
                    (nbreNote > 0)
                        ? Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: noir(),
                                  endIndent: 10,
                                  indent: 10,
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    (nbreNote > 1)
                        ? Row(
                            children: [
                              Expanded(
                                child: expandContainNote(
                                    "N°2", listCard[1], 1, listController[1]),
                              ),
                            ],
                          )
                        : Container(),
                    (nbreNote > 1)
                        ? Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: noir(),
                                  endIndent: 10,
                                  indent: 10,
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    (nbreNote > 2)
                        ? Row(
                            children: [
                              Expanded(
                                child: expandContainNote(
                                    "N°3", listCard[2], 2, listController[2]),
                              ),
                            ],
                          )
                        : Container(),
                    (nbreNote > 2)
                        ? Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: noir(),
                                  endIndent: 10,
                                  indent: 10,
                                ),
                              ),
                            ],
                          )
                        : Container(),
                  ],
                ),
              ),
              Container(
                height: 5,
              ),
              (nbreNote > 0)? ElevatedButton(
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
                  onPressed: () {},
                  child: CustomText("enregistrer",
                      color: Colors.white, tex: TailleText(context).soustitre)) : Container(),
            ],
          ))),
    );
  }

  Widget expandContainNote(String numero, GlobalKey keyCard, int i,
      TextEditingController controller) {
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
                items: matiere.map(buildMenuItem).toList(),
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
                value: enseignant,
                isExpanded: true,
                items: listEnseignant.map(buildMenuItem).toList(),
                iconSize: 30,
                iconEnabledColor: Colors.blueGrey,
                onChanged: ((value) {
                  setState(() {
                    enseignant = value!;
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
                value: jour,
                isExpanded: true,
                items: listJour.map(buildMenuItem).toList(),
                iconSize: 30,
                iconEnabledColor: Colors.blueGrey,
                onChanged: ((value) {
                  setState(() {
                    jour = value!;
                  });
                }))),
        Container(
          height: 15,
        ),
        InkWell(
          onTap: () async {
            TimeOfDay? timeOfDay = await showTimePicker(
                context: context,
                initialTime: selectedTime,
                initialEntryMode: TimePickerEntryMode.dial,
                cancelText: "retour",
                confirmText: "valider");

            if (timeOfDay != null) {
              debugPrint(timeOfDay.toString());
              setState(() {
                selectedTime = timeOfDay;

                timeController.text =
                    " ${selectedTime.hour} :${selectedTime.minute} ";
              });
            }
          },
          child: Container(
            margin: const EdgeInsets.only(left: 15, right: 15),
            width: MediaQuery.of(context).size.width * 0.85,
            decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: TextFormField(
                maxLines: 1,
                enabled: false,
                controller: timeController,
                onSaved: (onSavedval) {
                  timeController.text = onSavedval!;
                },
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      timeController.text.isEmpty) {
                    debugPrint(timeController.text);
                    return " entrer une heure svp !! ";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Heure de Cours ",
                  hintText: "Heure de Cours ",
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal, width: 0),
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                ),
              ),
            ),
          ),
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
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                          tex: TailleText(context).titre,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            if (mat == matiere[0] || value == depart[0]) {
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
                            items: depart.map(buildMenuItem).toList(),
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
                              if (value == depart[0]) {
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
