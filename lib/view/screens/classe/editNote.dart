// ignore_for_file: use_build_context_synchronously, file_names

import 'dart:async';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sysgesco/controllers/note_controller.dart';

import '../../../controllers/trimestre_controller.dart';
import '../../../functions/colors.dart';
import '../../../functions/custom_text.dart';
import '../../../functions/dialoguetoast.dart';
import '../../../functions/fonctions.dart';
import '../../../models/eleve_model.dart';
import '../../../models/trimestre_model.dart';

class EditNotePage extends StatefulWidget {
  const EditNotePage(
      {super.key,
      required this.eleve,
      required this.matiere,
      required this.note,
      required this.idTrimestre,
      required this.numNote});
  final ElevesModel eleve;
  final String matiere;
  final String note;
  final int idTrimestre;
  final int numNote;

  @override
  State<EditNotePage> createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  late ElevesModel element;
  List<TrimestreModel> feedTrimestre = [];
  final GlobalKey cardA = GlobalKey();
  TextEditingController noteController = TextEditingController();

  int eleveID = 0;
  int anneeID = 0;
  int matiereID = 0;
  int trismetreID = 0;
  int idNote = 0;
  late SharedPreferences? saveLastAnneeID;
  late SharedPreferences? saveMatiereID;

  DateTime dateDebut = DateTime.now();
  late String date;

  String value = '-- choisir un Trimestre --';
  final listTrimestre = ['-- choisir un Trimestre --'];
  String choixTrimestre = "-- choisir un Trimestre --";

  List<String> numeroNote = ["-- choisir numero --", "1", "2", "3", "4"];
  String numeroValue = "-- choisir numero --";

  void checkID() async {
    saveLastAnneeID = await SharedPreferences.getInstance();
    saveMatiereID = await SharedPreferences.getInstance();

    setState(() {
      anneeID = (saveLastAnneeID!.getInt('lastAnneeID') ?? 0);
      matiereID = (saveMatiereID!.getInt('matiereID') ?? 0);
      eleveID = int.parse(widget.eleve.idEleve.toString());
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

    Timer(const Duration(milliseconds: 500), () {
      loadData();
    });
  }

  loadData() async {
    setState(() {
      numeroValue = numeroNote[widget.numNote];
      value = listTrimestre[widget.idTrimestre];
      noteController.text = widget.note;
    });

    String nt = await Notes().getNoteOfID(
        eleveID, anneeID, widget.numNote, widget.idTrimestre, matiereID);

    setState(() {
      idNote = int.parse(nt);
    });

    debugPrint("idNote : $idNote");
  }

  @override
  void initState() {
    loadTrimestre();
    checkID();
    element = widget.eleve;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modifier Note "),
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
                "${element.nomEleve}  ${element.prenomEleve}",
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
                height: 15,
              ),
              CustomText(
                widget.matiere,
                tex: 0.85,
                color: gris(),
                fontWeight: FontWeight.w300,
              ),
              Container(
                height: 25,
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.first_page,
                      color: teal(),
                      size: 25,
                    ),
                    CustomText(
                      "Trimestre",
                      color: noir(),
                      tex: 1.15,
                      textAlign: TextAlign.center,
                    ),
                    Expanded(
                      child: Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          padding: const EdgeInsets.only(left: 10),
                          height: 50,
                          //width: MediaQuery.of(context).size.width * 0.5,
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
                                setState(() {
                                  this.value = value!;
                                });
                              }))),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              ),
              Container(
                height: 20,
              ),
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    padding:
                        const EdgeInsets.only(left: 10, top: 15, bottom: 15),
                    color: teal(),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomText(
                            "Composition - Ecrit",
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
                    color: grisee(),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CustomText("Numero de Note : ", color: noir()),
                            Expanded(
                              child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  padding: const EdgeInsets.only(left: 10),
                                  height: 50,
                                  //width: MediaQuery.of(context).size.width * 0.5,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: DropdownButton<String>(
                                      underline: Container(),
                                      icon: const Icon(Icons.arrow_drop_down,
                                          color: Colors.blueGrey),
                                      value: numeroValue,
                                      isExpanded: true,
                                      items: numeroNote
                                          .map(buildMenuItem)
                                          .toList(),
                                      iconSize: 30,
                                      iconEnabledColor: Colors.blueGrey,
                                      onChanged: ((value) {
                                        setState(() {
                                          numeroValue = value!;
                                        });
                                      }))),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Row(
                          children: [
                            CustomText("Saisir la Note ici : ", color: noir()),
                            Expanded(
                              child: Container(
                                margin:
                                    const EdgeInsets.only(left: 15, right: 15),
                                // width: MediaQuery.of(context).size.width * 0.3,
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: TextFormField(
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    controller: noteController,
                                    onSaved: (onSavedval) {
                                      noteController.text = onSavedval!;
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return " entrer une note svp !! ";
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                        hintText: "note",
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)))),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 15,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.teal,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40.0, vertical: 15.0),
                                shadowColor: Colors.blueGrey,
                                elevation: 8.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              onPressed: () async {
                                searchId();
                                if (noteController.text.isEmpty ||
                                    numeroValue == numeroNote[0] ||
                                    value == listTrimestre[0]) {
                                  DInfo.snackBarError(
                                      "Erreur , Verifer tous les champs",
                                      context);
                                } else {
                                  date = formatDate(dateDebut);
                                  int numNote = int.parse(numeroValue);

                                  bool res = await Notes().editNote(
                                      noteController.text.toString(),
                                      date,
                                      trismetreID,
                                      numNote,
                                      idNote);

                                  if (res) {
                                    // DInfo.snackBarSuccess(
                                    //     , context);

                                    CoolAlert.show(
                                      context: context,
                                      type: CoolAlertType.success,
                                      title: "${widget.eleve.nomEleve} ${widget.eleve.prenomEleve}",
                                      text:
                                          "\nLa note $numNote a été Modifiée avec Success",
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
                                  } else {
                                    DInfo.snackBarError(
                                        " Erreur !! Verifier les Champs svp.", context);
                                  }
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText(" Modifier la note ",
                                      color: Colors.white,
                                      tex: TailleText(context).soustitre),
                                  Icon(
                                    Icons.edit,
                                    color: blanc(),
                                  )
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ))),
    );
  }

  searchId() {
    for (var i = 0; i < feedTrimestre.length; i++) {
      if (value == feedTrimestre[i].libelleTrimestre.toString()) {
        setState(() {
          trismetreID = int.parse(feedTrimestre[i].idTrimestre.toString());
        });
      }
    }
  }
}
