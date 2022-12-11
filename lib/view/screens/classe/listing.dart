// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'dart:async';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sysgesco/controllers/eleve_controller.dart';
import 'package:sysgesco/controllers/matiere_controller.dart';
import '../../../controllers/note_controller.dart';
import '../../../controllers/trimestre_controller.dart';
import '../../../functions/colors.dart';
import '../../../functions/custom_text.dart';
import '../../../functions/dialoguetoast.dart';
import '../../../functions/fonctions.dart';

import '../../../models/eleve_model.dart';
import '../../../models/matiere_model.dart';
import '../../../models/trimestre_model.dart';

class ListingPage extends StatefulWidget {
  const ListingPage({super.key, required this.matiere, required this.classe});

  final String matiere;
  final String classe;

  @override
  State<ListingPage> createState() => _ListingPageState();
}

class _ListingPageState extends State<ListingPage> {
  late Future<List<ElevesModel>> feedEleve;

  List<MatiereModel> feedMatiere = [];
  List<TrimestreModel> feedTrimestre = [];
  List<ElevesModel> listEleve = [];
  List<ElevesModel> selectList = [];

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
  String coeff = "0";

  List<String> numeroNote = ["-- choisir numero --", "1", "2", "3", "4"];
  String numeroValue = "-- choisir numero --";
  int numNote = 0;
  int countNoteTrimestre = 0;

  int classeID = 0;
  int anneeID = 0;
  int noteID = 0;
  int matiereID = 0;
  int trimestreID = 0;
  late SharedPreferences? saveClasseID;
  late SharedPreferences? saveLastAnneeID;
  late SharedPreferences? saveMatiereID;
  late SharedPreferences? saveTrimestreID;
  late SharedPreferences? saveNoteID;

//* ********************************************************

  bool loading = false;
  List<TextEditingController> editController = [];
  List<FocusNode> listFocus = [];
  TextEditingController gController = TextEditingController();

  loadEleve() async {
    Future<List<ElevesModel>> result =
        Eleve().listEleve(id1: classeID, id2: anneeID);
    feedEleve = result;
    listEleve = await result;
    debugPrint(listEleve.length.toString());

    setState(() {
      for (var i = 0; i < listEleve.length; i++) {
        editController.add(TextEditingController());
      }
      debugPrint(editController.length.toString());
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
    setState(() {
      feedTrimestre = results;
    });

    for (var i = 0; i < feedTrimestre.length; i++) {
      setState(() {
        listTrimestre.add(feedTrimestre[i].libelleTrimestre.toString());
      });
    }
  }

  void checkID() async {
    loadMatiere();
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
  }

  @override
  void initState() {
    loadEleve();
    checkID();
    callsearchDialogue();
    choixClasse = widget.classe;
    choixMatiere = widget.matiere;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Notes"),
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
              Expanded(
                  child: (loading) ? elemntInList() : pageLoading(context)),
              Container(
                height: 25,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            debugPrint(editController.length.toString());
            date = formatDate(dateDebut);
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
            debugPrint("coefff est $coeff");
            if (pass) {
              for (var i = 0; i < editController.length; i++) {
                debugPrint(editController[i].text);

                int numNote = int.parse(numeroValue);
                int id = int.parse(listEleve[i].idEleve ?? "0");
                if (editController[i].text.isNotEmpty) {
                  await Notes().insertNote(
                      editController[i].text.toString(),
                      date,
                      id,
                      anneeID,
                      numNote,
                      idTri,
                      matiereID,
                      coeff.toString());
                }
              }
            } else {
              DInfo.toastError(
                  " Oupps!!!! vous avez oublié de remplir $forget note(s) !!");
            }

            if (pass) {
              dialogueNote(context, "enregistrement en cours..");
              Timer(const Duration(milliseconds: 2000), () {
                CoolAlert.show(
                  context: context,
                  type: CoolAlertType.success,
                  title: "Insertion de Note",
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

  callsearchDialogue() {
    Timer(const Duration(milliseconds: 1000), () {
      setState(() {
        loading = true;
      });
      searchMatiere(context);
    });
  }

  /* boite de Dialogue de Classe  */
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
                            value: numeroValue,
                            isExpanded: true,
                            items: numeroNote.map(buildMenuItem).toList(),
                            iconSize: 30,
                            iconEnabledColor: Colors.blueGrey,
                            onChanged: ((value) {
                              stfsetState(() {
                                numeroValue = value!;
                              });
                              setState(() {
                                numeroValue = value!;
                              });
                            }))),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 15, right: 15),
                      //padding: const EdgeInsets.only(left: 15),
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: TextFormField(
                          maxLines: 1,
                          controller: coefController,
                          keyboardType: TextInputType.number,
                          onSaved: (onSavedval) {
                            coefController.text = onSavedval!;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return " entrer un coeff svp !! ";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: "Coefficient",
                            hintText: "Coefficient",
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.teal, width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.teal, width: 0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                          ),
                        ),
                      ),
                    ),
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
                                  valueTri == listTrimestre[0] ||
                                  numeroValue == numeroNote[0] ||
                                  coefController.text.isEmpty) {
                                DInfo.toastError("Faites un Choix svp !!");
                              } else {
                                Timer(const Duration(milliseconds: 500), () {
                                  setState(() {});
                                  setState(() {
                                    loading = true;
                                    choixMatiere = value;
                                    choixTrimestre = valueTri;
                                    coeff = coefController.text;
                                  });
                                  Navigator.of(context).pop();
                                  loadEleve();
                                });
                                setState(() {
                                  choixMatiere = value;
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
    saveNoteID!.setInt('noteID', int.parse(numeroValue.toString()));

    setState(() {
      matiereID = (saveMatiereID!.getInt('matiereID') ?? 0);
      trimestreID = (saveMatiereID!.getInt('trimestreID') ?? 0);
      anneeID = (saveLastAnneeID!.getInt('lastAnneeID') ?? 0);
      classeID = (saveClasseID!.getInt('classeID') ?? 0);

      debugPrint(
          " mat : $matiereID .. tri : $trimestreID .. ann : $anneeID ... classe : $classeID .... note : $numeroValue");
    });

    saveMatiereID!.setInt('matiereID', int.parse(idValue.toString()));
    int newInt = (saveMatiereID!.getInt('matiereID') ?? 0);
    debugPrint("idMatiere : $newInt");
  }

  CardEleveNote(ElevesModel eleve, TextEditingController controller) {
    return Card(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.only(left: 0.5, right: 0.5),
        child: ListTile(
          onTap: () {
          },
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
}
