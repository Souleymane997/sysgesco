// ignore_for_file: file_names

import 'dart:async';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_advanced/sms_advanced.dart';

import '../../../controllers/matiere_controller.dart';
import '../../../controllers/note_controller.dart';
import '../../../controllers/trimestre_controller.dart';
import '../../../functions/colors.dart';
import '../../../functions/custom_text.dart';
import '../../../functions/dialoguetoast.dart';
import '../../../functions/fonctions.dart';
import '../../../models/config_sms_Model.dart';
import '../../../models/eleve_model.dart';
import '../../../models/matiere_model.dart';
import '../../../models/note_model.dart';
import '../../../models/trimestre_model.dart';
import '../../../services/database.dart';

class SendNotePageList extends StatefulWidget {
  const SendNotePageList(
      {super.key, required this.eleve, required this.classe});

  final List<ElevesModel> eleve;
  final String classe;

  @override
  State<SendNotePageList> createState() => _SendNotePageListState();
}

class _SendNotePageListState extends State<SendNotePageList> {
  SmsSender sender = SmsSender();
  List<ElevesModel> listEleves = [];
  List<NoteModel> feed1 = [];
  String textMessage = "";
  bool charge = false;
  bool btn = false;
  int id = 0;

  List<MatiereModel> feedMatiere = [];
  List<TrimestreModel> feedTrimestre = [];

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

  List<SmsModel> feedConfig = [];
  SmsModel verType = SmsModel(idconfig: 5, poste: "", lycee: "");
  //* ********************************************************

  String choixClasse = "-- choisir une classe --";

  final listMatiere = ['-- choisir une matière --'];
  String mat = '-- choisir une matière --';
  int idMat = 0;
  String choixMatiere = "-- choisir une matière --";

  String valueTri = '-- choisir un Trimestre --';
  final listTrimestre = ['-- choisir un Trimestre --'];
  String choixTrimestre = "-- choisir un Trimestre --";
  int idTri = 0;

  List<String> numeroNote = ["-- choisir numero --", "1", "2", "3", "4"];
  String numeroValue = "-- choisir numero --";
  int numNote = 0;
  int countNoteTrimestre = 0;
  bool loadPage = false;
//* ********************************************************

  void checkID() async {
    loadClasse();
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

    Timer(const Duration(milliseconds: 200), () {
      loadNote(id);
    });
  }

  loadConfig() async {
    List<SmsModel> result = await AppDatabase.instance.listConfig();
    setState(() {
      feedConfig = result;
      verType = feedConfig.first;
      debugPrint("Long : ${feedConfig.length}");
    });

    Timer(const Duration(milliseconds: 1000), () {
      setState(() {
        textMessage = '''** ${verType.lycee} **\n''';
      });
    });
  }

  callsearchDialogue() {
    Timer(const Duration(milliseconds: 100), () {
      searchClasse();
    });
  }

  @override
  void initState() {
    loadConfig();
    listEleves = widget.eleve;
    checkID();
    debugPrint(textMessage);
    Timer(const Duration(milliseconds: 1500), () {
      callsearchDialogue();
    });
    choixClasse = widget.classe;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Envoi de Note "),
      ),
      body: SafeArea(
        child: (loadPage)
            ? Column(children: [
                Container(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      " Classe : ",
                      color: noir(),
                      tex: 1.1,
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.center,
                    ),
                    CustomText(
                      widget.classe,
                      color: amberFone(),
                      tex: 1.1,
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
                Container(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      " Matière : ",
                      color: noir(),
                      tex: 1.1,
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.center,
                    ),
                    CustomText(
                      mat,
                      color: amberFone(),
                      tex: 1.1,
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
                Container(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      " Trimestre : ",
                      color: noir(),
                      tex: 1.1,
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.center,
                    ),
                    CustomText(
                      choixTrimestre,
                      color: amberFone(),
                      tex: 1.1,
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
                Container(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      " Note : ",
                      color: noir(),
                      tex: 1.1,
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.center,
                    ),
                    CustomText(
                      numeroValue,
                      color: amberFone(),
                      tex: 1.1,
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
                Container(
                  height: 25,
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
                    onPressed: () {
                      dialogueNote();
                      envoiNotes();

                      //sender.sendSms(message);
                      Timer(const Duration(milliseconds: 2000), () {
                        CoolAlert.show(
                          context: context,
                          type: CoolAlertType.success,
                          text: "Message Envoyé avec Success",
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
                    },
                    child: CustomText("Envoyer",
                        color: Colors.white,
                        tex: TailleText(context).soustitre)),
                Container(
                  height: 30,
                ),
                Expanded(
                  child: listNomEleves(),
                ),
              ])
            : pageLoading(context),
      ),
    );
  }

  envoiNotes() async {
    for (var i = 0; i < listEleves.length; i++) {
      int id = int.parse(listEleves[i].idEleve.toString());
      await loadNote(id);
      String a = note();
      //String numero = number(noteID);
      a = convert(a);

      textMessage = (a.length < 3)
          ? '''L'élève ${listEleves[i].prenomEleve} a eu $a à la note $noteID de $choixMatiere au trimestre $trimestreID'''
          : '''L'élève ${listEleves[i].prenomEleve} n'a pas eu de note $noteID de $choixMatiere au trimestre $trimestreID''';

      debugPrint(textMessage);

      SmsMessage message =
          SmsMessage(listEleves[i].phoneParent, textMessage.toString());

      debugPrint(textMessage);

      message.onStateChanged.listen((state) {
        if (state == SmsMessageState.Sent) {
          debugPrint("SMS is sent!");
        } else if (state == SmsMessageState.Delivered) {
          debugPrint("SMS is delivered!");
        }
      });

      sender.sendSms(message);
    }
  }

  loadNote(int id) async {
    feed1 = await Notes()
        .listNoteEleve(id, trimestreID, matiereID, anneeID, classeID);
    debugPrint("long : ${feed1.length}");
  }

  note() {
    return (feed1.length >= noteID)
        ? feed1[noteID - 1].notesEleve
        : " pas de Note ";
  }

  Future<void> dialogueNote() async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogcontext) => StatefulBuilder(
            builder: (stfContext, stfsetState) => SimpleDialog(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  contentPadding: const EdgeInsets.only(top: 2.0),
                  backgroundColor: Colors.white,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: CircularProgressIndicator(
                        color: teal(),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomText(
                      "Patientez svp ... envoi en cours ",
                      color: teal(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                )));
  }


  /* boite de Dialogue de Classe  */
  Future<void> searchClasse() async {
    return await showDialog(
        context: context,
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
                          "Envoi des Notes",
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                          tex: TailleText(context).titre,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.close,
                            color: teal(),
                          )),
                    ],
                  ),
                  children: [
                    const SizedBox(
                      height: 25,
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
                            value: mat,
                            isExpanded: true,
                            items: listMatiere.map(buildMenuItem).toList(),
                            iconSize: 30,
                            iconEnabledColor: Colors.blueGrey,
                            onChanged: ((value) {
                              stfsetState(() {
                                mat = value!;
                              });
                              setState(() {
                                mat = value!;
                              });
                            }))),
                    const SizedBox(
                      height: 25,
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

                              numNote = int.parse(numeroValue);
                              if (mat == listMatiere[0] ||
                                  valueTri == listTrimestre[0]) {
                                DInfo.toastError("Faites des Choix svp !!");
                              } else {
                                setState(() {
                                  choixMatiere = mat;
                                  choixTrimestre = valueTri;
                                  loadPage = true;
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

  loadClasse() async {
    List<MatiereModel> res = await Matiere().listMatiere();
    setState(() {
      feedMatiere = res;
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

  searchId() {
    for (var i = 0; i < feedMatiere.length; i++) {
      if (mat == feedMatiere[i].libelleMatieres.toString()) {
        setState(() {
          idMat = int.parse(feedMatiere[i].idMatieres.toString());
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

    saveMatiereID!.setInt('matiereID', int.parse(idMat.toString()));
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
  }

  listNomEleves() {
    return ListView.builder(
        itemCount: listEleves.length,
        itemBuilder: (context, index) {
          ElevesModel elem = listEleves[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
            child: Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: amberFone(), //<-- SEE HERE
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 0.0,
              child: ListTile(
                onTap: () {},
                title: CustomText(
                  " ${elem.nomEleve}  ${elem.prenomEleve} ",
                  tex: 1.1,
                  color: teal(),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        });
  }
}
