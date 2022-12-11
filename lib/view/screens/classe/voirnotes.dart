import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controllers/eleve_controller.dart';
import '../../../controllers/matiere_controller.dart';
import '../../../controllers/note_controller.dart';
import '../../../controllers/trimestre_controller.dart';
import '../../../functions/colors.dart';
import '../../../functions/custom_text.dart';
import '../../../functions/dialoguetoast.dart';
import '../../../functions/fonctions.dart';
import '../../../models/eleve_model.dart';
import '../../../models/matiere_model.dart';
import '../../../models/note_model.dart';
import '../../../models/trimestre_model.dart';

class VoirNotes extends StatefulWidget {
  const VoirNotes({super.key, required this.matiere, required this.classe});
  final String matiere;
  final String classe;

  @override
  State<VoirNotes> createState() => _VoirNotesState();
}

class _VoirNotesState extends State<VoirNotes> {
  late Future<List<ElevesModel>> feedEleve;

  List<MatiereModel> feedMatiere = [];
  List<TrimestreModel> feedTrimestre = [];
  List<ElevesModel> listEleve = [];

  List<List<NoteModel>> listNotes = [];
  List<NoteModel> listNot = [];

  DateTime dateDebut = DateTime.now();
  late String date;

  String choixClasse = "choisir classe";

  final listMatiere = ['-- choisir une matière --'];
  String value = '-- choisir une matière --';
  String choixMatiere = "-- choisir une matière --";
  int idValue = 0;

  String valueTri = '-- choisir un Trimestre --';
  final listTrimestre = ['-- choisir un Trimestre --'];
  String choixTrimestre = "-- choisir un Trimestre --";
  int idTri = 0;

  TextEditingController coefController = TextEditingController();

  int countNoteTrimestre = 0;

  int classeID = 0;
  int anneeID = 0;
  int noteID = 0;
  int matiereID = 0;
  int trimestreID = 0;
  int longueur = 0;
  late SharedPreferences? saveClasseID;
  late SharedPreferences? saveLastAnneeID;
  late SharedPreferences? saveMatiereID;
  late SharedPreferences? saveTrimestreID;
  late SharedPreferences? saveNoteID;

  List<NoteModel> feed1 = [];

//* ********************************************************
  bool loading = false;
  int countNoteTrimestre1 = 0;
//* ********************************************************

  callsearchDialogue() {
    Timer(const Duration(milliseconds: 1000), () {
      searchMatiere(context);
    });
  }

  loadMatiere() async {
    List<MatiereModel> result = await Matiere().listMatiere();
    setState(() {
      feedMatiere = result;
    });

    for (var i = 0; i < feedMatiere.length; i++) {
      setState(() {
        listMatiere.add(feedMatiere[i].libelleMatieres.toString());
      });
    }

    List<TrimestreModel> results = await Trimestre().listTrimestre();

    feedTrimestre = results;

    for (var i = 0; i < feedTrimestre.length; i++) {
      setState(() {
        listTrimestre.add(feedTrimestre[i].libelleTrimestre.toString());
      });
    }
  }

  void checkID() async {
    saveClasseID = await SharedPreferences.getInstance();
    saveLastAnneeID = await SharedPreferences.getInstance();
    saveMatiereID = await SharedPreferences.getInstance();
    saveTrimestreID = await SharedPreferences.getInstance();
    saveNoteID = await SharedPreferences.getInstance();

    matiereID = (saveMatiereID!.getInt('matiereID') ?? 0);
    noteID = (saveNoteID!.getInt('noteID') ?? 0);
    trimestreID = (saveMatiereID!.getInt('trimestreID') ?? 0);
    anneeID = (saveLastAnneeID!.getInt('lastAnneeID') ?? 0);
    classeID = (saveClasseID!.getInt('classeID') ?? 0);
    loadMatiere();
  }

  @override
  void initState() {
    checkID();
    callsearchDialogue();
    choixClasse = widget.classe;
    choixMatiere = widget.matiere;
    longueur = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Voir Notes"),
        actions: [
          IconButton(
              onPressed: () {
                searchMatiere(context);
              },
              icon: const Icon(Icons.filter_center_focus)),
          Container(
            width: 5,
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              color: Colors.grey.shade400,
              child: Column(children: [
                Container(
                  height: 15,
                ),
                CustomText(
                  choixClasse.toUpperCase(),
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
                  choixMatiere.toUpperCase(),
                  tex: 0.85,
                  color: gris(),
                  fontWeight: FontWeight.w600,
                ),
                Container(
                  height: 15,
                ),
                CustomText(
                  choixTrimestre.toUpperCase(),
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
            Container(
              height: 25,
            ),
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

                return cardWidget(
                    item, (listNotes.isNotEmpty) ? listNotes[index] : listNot);
              });
        });
  }

  Widget cardWidget(ElevesModel element, List<NoteModel?> notes) {
    return Card(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Container(
        padding: const EdgeInsets.only(left: 0.5, right: 0.5),
        color: Colors.transparent,
        child: ListTile(
          onTap: () {},
          title: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                padding: const EdgeInsets.all(5.0),
                child: CustomText(
                  "${element.nomEleve}  ${element.prenomEleve}",
                  tex: TailleText(context).soustitre * 0.8,
                  color: noir(),
                  textAlign: TextAlign.left,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                width: 10,
              ),
              (countNoteTrimestre > 0)
                  ? Expanded(
                      child: Container(
                          margin: const EdgeInsets.all(3),
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: amberFone().withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: amberFone(),
                              width: 2.0,
                            ),
                          ),
                          child: CustomText(
                            convert((notes.isNotEmpty)
                                ? notes[0]!.notesEleve.toString()
                                : "00"),
                            tex: TailleText(context).soustitre * 0.8,
                            color: teal(),
                            textAlign: TextAlign.center,
                            fontWeight: FontWeight.w600,
                          )),
                    )
                  : Container(),
              (countNoteTrimestre > 1)
                  ? Expanded(
                      child: Container(
                          margin: const EdgeInsets.all(3),
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: amberFone().withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: amberFone(),
                              width: 2.0,
                            ),
                          ),
                          child: CustomText(
                            convert((notes.isNotEmpty)
                                ? notes[1]!.notesEleve.toString()
                                : "00"),
                            tex: TailleText(context).soustitre * 0.8,
                            color: teal(),
                            textAlign: TextAlign.center,
                            fontWeight: FontWeight.w600,
                          )),
                    )
                  : Container(),
              (countNoteTrimestre > 2)
                  ? Expanded(
                      child: Container(
                          margin: const EdgeInsets.all(3),
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: amberFone().withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: amberFone(),
                              width: 2.0,
                            ),
                          ),
                          child: CustomText(
                            convert((notes.isNotEmpty)
                                ? notes[2]!.notesEleve.toString()
                                : "00"),
                            tex: TailleText(context).soustitre * 0.8,
                            color: teal(),
                            textAlign: TextAlign.center,
                            fontWeight: FontWeight.w600,
                          )),
                    )
                  : Container(),
              (countNoteTrimestre > 3)
                  ? Expanded(
                      child: Container(
                          margin: const EdgeInsets.all(3),
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: amberFone().withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: amberFone(),
                              width: 2.0,
                            ),
                          ),
                          child: CustomText(
                            convert((notes.isNotEmpty)
                                ? notes[3]!.notesEleve.toString()
                                : "00"),
                            tex: TailleText(context).soustitre * 0.8,
                            color: teal(),
                            textAlign: TextAlign.center,
                            fontWeight: FontWeight.w600,
                          )),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> searchMatiere(BuildContext parentContext) async {
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
                          "Choisir une Matiere",
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                          tex: TailleText(context).titre,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            if (choixMatiere == listMatiere[0]) {
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
                            items: listMatiere.map(buildMenuItem).toList(),
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
                            value: valueTri,
                            isExpanded: true,
                            items: listTrimestre.map(buildMenuItem).toList(),
                            iconSize: 30,
                            iconEnabledColor: Colors.blueGrey,
                            onChanged: ((value) {
                              stfsetState(() {
                                valueTri = value!;
                              });
                              setState(() {
                                valueTri = value!;
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

                              if (value == listMatiere[0] ||
                                  valueTri == listTrimestre[0]) {
                                DInfo.toastError("Faites un Choix svp !!");
                              } else {
                                dialogueNote(context, "patientez svp...");
                                Timer(const Duration(milliseconds: 200), () {
                                  setState(() {
                                    choixMatiere = value;
                                    choixTrimestre = valueTri;
                                  });
                                  loadCountNote();
                                  loadData();
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

  searchId() {
    for (var i = 0; i < feedMatiere.length; i++) {
      if (value == feedMatiere[i].libelleMatieres.toString()) {
        setState(() {
          idValue = int.parse(feedMatiere[i].idMatieres.toString());
        });
      }
    }

    for (var i = 0; i < feedTrimestre.length; i++) {
      if (valueTri == feedTrimestre[i].libelleTrimestre.toString()) {
        setState(() {
          idTri = int.parse(feedTrimestre[i].idTrimestre.toString());
        });
      }
    }

    saveMatiereID!.setInt('matiereID', int.parse(idValue.toString()));
    saveTrimestreID!.setInt('trimestreID', int.parse(idTri.toString()));

    setState(() {
      matiereID = (saveMatiereID!.getInt('matiereID') ?? 0);
      trimestreID = (saveMatiereID!.getInt('trimestreID') ?? 0);
      anneeID = (saveLastAnneeID!.getInt('lastAnneeID') ?? 0);
      classeID = (saveClasseID!.getInt('classeID') ?? 0);

      debugPrint(
          " mat : $matiereID .. tri : $trimestreID .. ann : $anneeID ... classe : $classeID ....");
    });

    saveMatiereID!.setInt('matiereID', int.parse(idValue.toString()));
    int newInt = (saveMatiereID!.getInt('matiereID') ?? 0);
    debugPrint("idMatiere : $newInt");
  }

  loadData() async {
    Future<List<ElevesModel>> result =
        Eleve().listEleve(id1: classeID, id2: anneeID);
    listEleve = await result;
    setState(() {
      longueur = listEleve.length;
    });

    for (var i = 0; i < listEleve.length; i++) {
      feed1 = await Notes().listNoteEleve(
          int.parse(listEleve[i].idEleve.toString()),
          trimestreID,
          matiereID,
          anneeID,
          classeID);
      setState(() {
        listNotes.add(feed1);
      });

      if (i == (longueur - 1)) {
        Timer(const Duration(seconds: 5), () {
          loadEleve();
          setState(() {
            loading = true;
          });
          debugPrint(loading.toString());

          setState(() {
            if (loading) {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            }
          });
        });
      }
    }
  }

  loadEleve() async {
    Future<List<ElevesModel>> result =
        Eleve().listEleve(id1: classeID, id2: anneeID);
    feedEleve = result;
  }

  loadCountNote() async {
    String res1 = await Notes()
        .countNoteOfTrismetre(trimestreID, matiereID, anneeID, classeID);
    setState(() {
      countNoteTrimestre = int.parse(res1);
    });
  }

  loadNote() async {
    for (var i = 0; i < listEleve.length; i++) {
      feed1 = await Notes().listNoteEleve(
          int.parse(listEleve[i].idEleve.toString()),
          trimestreID,
          matiereID,
          anneeID,
          classeID);
      setState(() {
        listNotes[i] = feed1;
      });
    }
  }
}
