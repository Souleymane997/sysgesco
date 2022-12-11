// ignore_for_file: file_names, prefer_interpolation_to_compose_strings

import 'dart:async';

import 'package:cool_alert/cool_alert.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_advanced/sms_advanced.dart';
import 'package:sysgesco/controllers/ens_controller.dart';
import 'package:sysgesco/models/enseignant_model.dart';

import '../../../controllers/classe_controller.dart';
import '../../../controllers/matiere_controller.dart';
import '../../../controllers/seance_controller.dart';
import '../../../functions/colors.dart';
import '../../../functions/custom_text.dart';
import '../../../functions/dialoguetoast.dart';
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
  SmsSender sender = SmsSender();
  List<ClasseModel> feedClasse = [];
  List<MatiereModel> feedMatiere = [];

  List<TextEditingController> listController = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];

  DateTime date = DateTime(2022, 12, 24);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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

  String textMessageEmp1 = "LUNDI \n";
  String textMessageEmp2 = "MARDI \n";
  String textMessageEmp3 = "MERCREDI \n";
  String textMessageEmp4 = "JEUDI \n";
  String textMessageEmp5 = "VENDREDI \n";

  charge(List<SeanceModel> list, String text) {
    if (list.isNotEmpty) {
      for (var i = 0; i < list.length; i++) {
        setState(() {
          text =
              "${"${"$text${list[i].heureDebut} à ${list[i].heureFin} => " + searchMatierebyID(list[i].idMatieres.toString())}=>" + searchClassebyID(list[i].idClasse.toString())}\n";
        });
      }
    } else {
      setState(() {
        text = "${text}pas de Programme";
      });
    }
    debugPrint(text);
    return text;
  }

  int profID = 0;
  int anneeID = 0;
  bool modify = false;
  bool loading = false;

  loadSeance() async {
    List<SeanceModel> result1 =
        await Seance().listSeanceProf(1, profID, anneeID);
    setState(() {
      seanceListingLundi = result1;
      debugPrint(seanceListingLundi.length.toString());
      Timer(const Duration(milliseconds: 1000), () {
        textMessageEmp1 = charge(seanceListingLundi, textMessageEmp1);
      });
    });

    List<SeanceModel> result2 =
        await Seance().listSeanceProf(2, profID, anneeID);
    setState(() {
      seanceListingMardi = result2;
      debugPrint(seanceListingMardi.length.toString());
      Timer(const Duration(milliseconds: 1000), () {
        textMessageEmp2 = charge(seanceListingMardi, textMessageEmp2);
      });
    });

    List<SeanceModel> result3 =
        await Seance().listSeanceProf(3, profID, anneeID);
    setState(() {
      seanceListingMercredi = result3;
      debugPrint(seanceListingMercredi.length.toString());
      Timer(const Duration(milliseconds: 1000), () {
        textMessageEmp3 = charge(seanceListingMercredi, textMessageEmp3);
      });
    });

    List<SeanceModel> result4 =
        await Seance().listSeanceProf(4, profID, anneeID);
    setState(() {
      seanceListingJeudi = result4;
      debugPrint(seanceListingJeudi.length.toString());
      Timer(const Duration(milliseconds: 1000), () {
        textMessageEmp4 = charge(seanceListingJeudi, textMessageEmp4);
      });
    });

    List<SeanceModel> result5 =
        await Seance().listSeanceProf(5, profID, anneeID);
    setState(() {
      seanceListingVendredi = result5;
      debugPrint(seanceListingVendredi.length.toString());
      Timer(const Duration(milliseconds: 1000), () {
        textMessageEmp5 = charge(seanceListingVendredi, textMessageEmp5);
      });
    });
  }

//* ********************************************************

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

  late SharedPreferences? saveDataUser;

  int statut = 0;

  void checkUserLogin() async {
    saveDataUser = await SharedPreferences.getInstance();

    setState(() {
      statut = saveDataUser!.getInt("role") ?? -1;
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

    checkUserLogin();
    checkID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details Enseignants"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (modify) {
              Navigator.pop(context, true);
            } else {
              Navigator.pop(context, false);
            }
          },
        ),
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
                  height: 10,
                ),
                CustomText(
                  " Telephone : ${enseig.phone} ",
                  tex: 1.25,
                  color: blanc(),
                  fontWeight: FontWeight.w600,
                ),
                Container(
                  height: 5,
                ),
                CustomText(
                  " Date de Naissance : ${enseig.dateNaissance} ",
                  tex: 1.25,
                  color: blanc(),
                  fontWeight: FontWeight.w600,
                ),
                Container(
                  height: 10,
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
      floatingActionButton: (loading)
          ? SpeedDial(
              icon: Icons.person,
              backgroundColor: tealFonce(),
              children: [
                  SpeedDialChild(
                    child: SizedBox(
                        width: 30,
                        height: 20,
                        child: Icon(
                          Icons.send,
                          color: blanc(),
                        )),
                    label: 'Envoi Emploi du temps',
                    backgroundColor: bleuClaire(),
                    onTap: () {
                      dialogueNote();
                      Timer(const Duration(milliseconds: 2000), () {
                        envoiEmploi();
                      });

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
                  ),
                  SpeedDialChild(
                    child: SizedBox(
                        width: 30,
                        height: 20,
                        child: Icon(
                          Icons.edit,
                          color: blanc(),
                        )),
                    label: 'Modifier',
                    backgroundColor: tealFonce(),
                    onTap: () {
                      dialogEleve(context, enseig);
                    },
                  ),
                  // SpeedDialChild(
                  //   child: SizedBox(
                  //       width: 30,
                  //       height: 20,
                  //       child: Icon(
                  //         Icons.delete,
                  //         color: blanc(),
                  //       )),
                  //   label: 'Supprimer',
                  //   backgroundColor: Colors.red,
                  //   onTap: () {
                  //     DInfo.toastError("supprimer un élève");
                  //   },
                  // ),
                ])
          : Container(),
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
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 3.0),
              child: CustomText(
                "${seance.heureDebut} - ${seance.heureFin}",
                tex: TailleText(context).soustitre * 0.8,
                textAlign: TextAlign.left,
                fontWeight: FontWeight.w600,
              ),
            ),
            Expanded(
              child: CustomText(
                searchMatierebyID(seance.idMatieres.toString()),
                tex: TailleText(context).soustitre * 0.8,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w600,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 3.0),
              child: CustomText(
                searchClassebyID(seance.idClasse.toString()),
                tex: TailleText(context).soustitre * 0.8,
                textAlign: TextAlign.left,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
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

  envoiEmploi() async {
    //sender.sendSms(SmsMessage(listEleves[i].phoneParent, message));
    SmsMessage message1 = SmsMessage(widget.enseignant.phone, textMessageEmp1);
    sender.sendSms(message1);

    SmsMessage message2 = SmsMessage(widget.enseignant.phone, textMessageEmp2);
    sender.sendSms(message2);

    SmsMessage message3 = SmsMessage(widget.enseignant.phone, textMessageEmp3);
    sender.sendSms(message3);

    SmsMessage message4 = SmsMessage(widget.enseignant.phone, textMessageEmp4);
    sender.sendSms(message4);

    SmsMessage message5 = SmsMessage(widget.enseignant.phone, textMessageEmp5);
    sender.sendSms(message5);
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

  Future<void> dialogEleve(
      BuildContext parentContext, EnseignantModel element) async {
    setState(() {
      listController[0].text = element.nomEns.toString();
      listController[1].text = element.prenomEns.toString();
      listController[2].text = element.phone.toString();
      listController[3].text = element.dateNaissance.toString();
    });

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
                          "Modification",
                          color: teal(),
                          fontWeight: FontWeight.bold,
                          tex: TailleText(parentContext).titre,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                            clearControler(listController);
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.red,
                            size: 25,
                          )),
                    ],
                  ),
                  children: [
                    Container(
                      height: 15,
                    ),
                    Form(
                      key: formKey,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin:
                                    const EdgeInsets.only(left: 15, right: 15),
                                child: TextFormField(
                                  cursorColor: teal(),
                                  onChanged: (value) {},
                                  controller: listController[0],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return " entrer un nom !! ";
                                    }
                                    return null;
                                  },
                                  maxLines: 1,
                                  onSaved: (onSavedval) {
                                    listController[0].text = onSavedval!;
                                  },
                                  style: TextStyle(
                                    color: teal(),
                                  ),
                                  decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: teal(), width: 1),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10.0))),
                                      hintText: "Nom",
                                      labelText: "Nom",
                                      labelStyle: TextStyle(
                                        color: teal(),
                                      ),
                                      border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)))),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin:
                                    const EdgeInsets.only(left: 15, right: 15),
                                child: TextFormField(
                                  cursorColor: teal(),
                                  onChanged: (value) {},
                                  controller: listController[1],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return " entrer un prenom !! ";
                                    }
                                    return null;
                                  },
                                  maxLines: 1,
                                  onSaved: (onSavedval) {
                                    listController[1].text = onSavedval!;
                                  },
                                  style: TextStyle(
                                    color: teal(),
                                  ),
                                  decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: teal(), width: 1),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10.0))),
                                      hintText: "Prenom(s)",
                                      labelText: "Prenom(s)",
                                      labelStyle: TextStyle(
                                        color: teal(),
                                      ),
                                      border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)))),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin:
                                    const EdgeInsets.only(left: 15, right: 15),
                                child: TextFormField(
                                  cursorColor: teal(),
                                  onChanged: (value) {},
                                  controller: listController[2],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return " entrer un telephone !! ";
                                    }
                                    return null;
                                  },
                                  maxLines: 1,
                                  keyboardType: TextInputType.phone,
                                  onSaved: (onSavedval) {
                                    listController[2].text = onSavedval!;
                                  },
                                  style: TextStyle(
                                    color: teal(),
                                  ),
                                  decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: teal(), width: 1),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10.0))),
                                      hintText: "Telephone",
                                      labelText: "Telephone",
                                      labelStyle: TextStyle(
                                        color: teal(),
                                      ),
                                      border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)))),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () async {
                            DateTime? newDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1990),
                              lastDate: DateTime(2025),
                              initialDatePickerMode: DatePickerMode.day,
                              cancelText: "retour",
                              confirmText: "valider",
                            );

                            if (newDate != null) {
                              setState(() {
                                date = newDate;

                                listController[3].text =
                                    " ${date.day} / ${date.month} / ${date.year} ";
                              });
                            }
                          },
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 15, right: 15),
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: TextFormField(
                                      maxLines: 1,
                                      enabled: false,
                                      controller: listController[3],
                                      onSaved: (onSavedval) {
                                        listController[3].text = onSavedval!;
                                      },
                                      validator: (value) {
                                        if (value == null ||
                                            value.isEmpty ||
                                            listController[3].text.isEmpty) {
                                          debugPrint(listController[3].text);
                                          return " entrer une date de naissance svp !! ";
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        labelText: "Date de Naissance ",
                                        hintText: "Date de Naissance ",
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.teal, width: 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.teal, width: 0),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: blanc(),
                              backgroundColor: teal(),
                              padding:
                                  const EdgeInsets.only(left: 12, right: 12),
                              shadowColor: teal().withAlpha(200),
                              elevation: 5.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            onPressed: () async {
                              if (validateAndSave(formKey)) {
                                setState(() {
                                  modify = true;
                                });
                                dialogueNote();
                                EnseignantModel newEns = EnseignantModel(
                                  idEns: element.idEns,
                                  nomEns: listController[0].text.toString(),
                                  prenomEns: listController[1].text.toString(),
                                  phone: listController[2].text.toString(),
                                  dateNaissance:
                                      listController[3].text.toString(),
                                );

                                bool b = await Enseignant().editEns(newEns);
                                if (b) {
                                  // ElevesModel el = (await Eleve().oneEleve(
                                  //     id1: int.parse(eleve.idEleve ?? "0")))!;

                                  setState(() {
                                    enseig = newEns;
                                  });

                                  CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.success,
                                    text: "Modification Effectuée avec Success",
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
                                  DInfo.toastError(
                                      " Erreur au niveau de la modification, verifiez lz numero !!");
                                }
                              } else {
                                DInfo.toastError(" Remplissez les champs SVP ");
                              }
                            },
                            child: CustomText(
                              "soumettre",
                              color: blanc(),
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
}
