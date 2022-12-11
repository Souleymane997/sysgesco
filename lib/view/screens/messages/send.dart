// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:async';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_advanced/sms_advanced.dart';
import 'package:sysgesco/view/screens/messages/sendEmploi.dart';
import 'package:sysgesco/view/screens/messages/sendNote.dart';
import 'package:sysgesco/view/screens/messages/sendRetard.dart';

import '../../../controllers/classe_controller.dart';
import '../../../controllers/eleve_controller.dart';
import '../../../controllers/matiere_controller.dart';
import '../../../controllers/note_controller.dart';
import '../../../controllers/seance_controller.dart';
import '../../../controllers/trimestre_controller.dart';
import '../../../functions/colors.dart';
import '../../../functions/custom_text.dart';
import '../../../functions/dialoguetoast.dart';
import '../../../functions/fonctions.dart';
import '../../../functions/slidepage.dart';
import '../../../models/classe_model.dart';
import '../../../models/config_sms_Model.dart';
import '../../../models/eleve_model.dart';
import '../../../models/matiere_model.dart';
import '../../../models/note_model.dart';
import '../../../models/seance_model.dart';
import '../../../models/trimestre_model.dart';
import '../../../services/database.dart';
import 'sendConvocation.dart';

class EnvoiPage extends StatefulWidget {
  const EnvoiPage({super.key, required this.x});
  final int x;

  @override
  State<EnvoiPage> createState() => _EnvoiPageState();
}

class _EnvoiPageState extends State<EnvoiPage> {
  late Future<List<ElevesModel>> feedEleve;
  late Future<List<ElevesModel>> feedSearchEleve;
  List<ClasseModel> feedClasse = [];
  List<MatiereModel> feedMatiere = [];
  List<TrimestreModel> feedTrimestre = [];
  List<ElevesModel> selectList = [];
  List<ElevesModel> listEleves = [];
  List<NoteModel> feed1 = [];

  List<String> title = [
    "Envoi de Note",
    "Envoi d'Emploi du temps",
    "Envoi de Convocation",
    "Envoi des Retars & Absences"
  ];

  List<SmsModel> feedConfig = [];
  SmsModel verType = SmsModel(idconfig: 5, poste: "", lycee: "");

  SmsSender sender = SmsSender();
  String textMessage = ''' bonjour ''';
  String message = ''' bonjour ''';

  // ignore: non_constant_identifier_names
  //* ********************************************************

  final listClasse = ['-- choisir une classe --'];
  String value = '-- choisir une classe --';
  int idValue = 0;
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
//* ********************************************************

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
          text = "$text${list[i].heureDebut} à ${list[i].heureFin} ==> " +
              searchNombyID(list[i].idMatieres.toString()) +
              "\n";
        });
      }
    } else {
      setState(() {
        text = text + "pas de Programme";
      });
    }

    return text;
  }

  searchNombyID(String j) {
    for (var i = 0; i < feedMatiere.length; i++) {
      if (j == feedMatiere[i].idMatieres.toString()) {
        return feedMatiere[i].libelleMatieres.toString();
      }
    }
    return "defaut";
  }

  loadSeance() async {
    List<SeanceModel> result1 = await Seance().listSeance(1, classeID, anneeID);
    setState(() {
      seanceListingLundi = result1;
      debugPrint(seanceListingLundi.length.toString());
      Timer(const Duration(milliseconds: 1000), () {
        textMessageEmp1 = charge(seanceListingLundi, textMessageEmp1);
      });
    });

    List<SeanceModel> result2 = await Seance().listSeance(2, classeID, anneeID);
    setState(() {
      seanceListingMardi = result2;
      debugPrint(seanceListingMardi.length.toString());
      Timer(const Duration(milliseconds: 1000), () {
        textMessageEmp2 = charge(seanceListingMardi, textMessageEmp2);
      });
    });

    List<SeanceModel> result3 = await Seance().listSeance(3, classeID, anneeID);
    setState(() {
      seanceListingMercredi = result3;
      debugPrint(seanceListingMercredi.length.toString());
      Timer(const Duration(milliseconds: 1000), () {
        textMessageEmp3 = charge(seanceListingMercredi, textMessageEmp3);
      });
    });

    List<SeanceModel> result4 = await Seance().listSeance(4, classeID, anneeID);
    setState(() {
      seanceListingJeudi = result4;
      debugPrint(seanceListingJeudi.length.toString());
      Timer(const Duration(milliseconds: 1000), () {
        textMessageEmp4 = charge(seanceListingJeudi, textMessageEmp4);
      });
    });

    List<SeanceModel> result5 = await Seance().listSeance(5, classeID, anneeID);
    setState(() {
      seanceListingVendredi = result5;
      debugPrint(seanceListingVendredi.length.toString());
      Timer(const Duration(milliseconds: 1000), () {
        textMessageEmp5 = charge(seanceListingVendredi, textMessageEmp5);
      });
    });
  }

//* ********************************************************
  bool showSearch = false;
  bool boarding = true;
  String changed = '';
  bool loading = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController editingController = TextEditingController();

  bool hide = false;
  bool valide = false;

  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime date = DateTime.now();

  String date1 = "";
  String heure1 = "";

//* Fin des Variables  //* Fin des Variables  //* Fin des Variables
//* Fin des Variables  //* Fin des Variables  //* Fin des Variables
//* Fin des Variables  //* Fin des Variables  //* Fin des Variables
//* Fin des Variables  //* Fin des Variables  //* Fin des Variables

  loadConfig() async {
    List<SmsModel> result = await AppDatabase.instance.listConfig();
    setState(() {
      feedConfig = result;
      verType = feedConfig.first;
      debugPrint("Long : ${feedConfig.length}");
    });
  }

  @override
  void initState() {
    loadConfig();
    initializeDateFormatting();
    date1 = formatDate(date);
    heure1 = " ${selectedTime.hour} h ${selectedTime.minute} ";
    checkID();
    Timer(const Duration(milliseconds: 1500), () {
      callsearchDialogue();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title[widget.x]),
        actions: [
          IconButton(
              onPressed: () {
                searchClasse(widget.x);
              },
              icon: const Icon(Icons.filter_center_focus)),
          Container(
            width: 20,
          ),
          InkWell(
            onTap: () {
              debugPrint("show zone search");
              setState(() {
                showSearch = !showSearch;
                changed = "";
                editingController.text = "";
                boarding = true;
              });
            },
            child: (!showSearch)
                ? const Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 25.0,
                  )
                : const Icon(
                    Icons.cancel,
                    color: Colors.white,
                    size: 25.0,
                  ),
          ),
          Container(
            width: 20,
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
                  choixClasse,
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
                  height: 10,
                ),
                CustomText(
                  (widget.x == 0)
                      ? "$choixMatiere     $choixTrimestre  Note $numNote"
                      : "",
                  tex: 0.85,
                  color: gris(),
                  fontWeight: FontWeight.w300,
                ),
                Container(
                  height: 15,
                ),
              ]),
            ),
            Container(
              height: 5,
            ),
            (showSearch)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.02,
                              right: MediaQuery.of(context).size.width * 0.02),
                          child: TextField(
                            controller: editingController,
                            onChanged: (value) {
                              changed = value;
                              if (changed.isNotEmpty) {
                                setState(() {
                                  feedSearchEleve = Eleve().listEleve(
                                      id1: classeID,
                                      id2: anneeID,
                                      query: changed);
                                  boarding = false;
                                });
                              } else {
                                setState(() {
                                  boarding = true;
                                });
                              }
                            },
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 0.0),
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: changed.isNotEmpty
                                  ? GestureDetector(
                                      child: const Icon(Icons.close),
                                      onTap: () {
                                        setState(() {
                                          editingController.clear();
                                          changed = '';
                                          boarding = true;
                                        });

                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                      },
                                    )
                                  : null,
                              hintText: " rechercher un Eleve",
                              // border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(),
            Container(
              height: 25.0,
            ),
            Expanded(child: (loading) ? elemntInList() : pageLoading(context)),
          ],
        ),
      ),
      floatingActionButton: (widget.x != 3 && widget.x != 1)
          ? FloatingActionButton.extended(
              onPressed: () {
                if (widget.x == 2) {
                  dialogueConvocation();
                  //envoiConvocation();
                }

                if (widget.x == 0) {
                  confirm();
                }
              },
              elevation: 10.0,
              backgroundColor: amberFone(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              label: CustomText(
                "Envoi Groupé",
                fontWeight: FontWeight.w600,
              ),
              icon: const Icon(Icons.send),
            )
          : Container(),
    );
  }

//* List for Eleves and Widget Card
//* List for Eleves and Widget Card
//* List for Eleves and Widget Card

  Widget elemntInList() {
    return FutureBuilder<List<ElevesModel>>(
        future: (boarding) ? feedEleve : feedSearchEleve,
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
        color: Colors
            .transparent, //(element.isSelected) ? grisee() : Colors.transparent,
        padding: const EdgeInsets.only(left: 0.5, right: 0.5),
        child: ListTile(
          onTap: () {
            openPage(widget.x, element);
          },
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
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomText(
              "${element.nomEleve.toString().toUpperCase()}  ${element.prenomEleve.toString().toUpperCase()}",
              tex: TailleText(context).soustitre * 0.8,
              color: noir(),
              textAlign: TextAlign.left,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomText(
                    'Contact Parents : ${element.phoneParent}',
                    tex: TailleText(context).contenu * 0.8,
                    color: noir(),
                    textAlign: TextAlign.left,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//* Functions
//* Functions
//* Functions
/* boite de Dialogue de Classe  */
  Future<void> searchClasse(int i) async {
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
                          title[widget.x],
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
                    (i == 0)
                        ? Container(
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
                                })))
                        : Container(),
                    (i == 0)
                        ? const SizedBox(
                            height: 25,
                          )
                        : Container(),
                    (i == 0)
                        ? Container(
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
                                items:
                                    listTrimestre.map(buildMenuItem).toList(),
                                iconSize: 30,
                                iconEnabledColor: Colors.blueGrey,
                                onChanged: ((value) {
                                  stfsetState(() {
                                    valueTri = value!;
                                  });
                                  setState(() {
                                    valueTri = value!;
                                  });
                                })))
                        : Container(),
                    (i == 0)
                        ? const SizedBox(
                            height: 25,
                          )
                        : Container(),
                    (i == 0)
                        ? Container(
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
                                })))
                        : Container(),
                    (i == 0)
                        ? const SizedBox(
                            height: 25,
                          )
                        : Container(),
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
                              if (widget.x == 1) {
                                loadSeance();
                              }
                              if (i == 0) {
                                numNote = int.parse(numeroValue);
                                if (mat == listMatiere[0] ||
                                    value == listClasse[0] ||
                                    valueTri == listTrimestre[0]) {
                                  DInfo.toastError("Faites des Choix svp !!");
                                } else {
                                  setState(() {
                                    choixClasse = value;
                                    choixMatiere = mat;
                                    choixTrimestre = valueTri;
                                  });
                                  Navigator.of(context).pop();
                                }
                              } else {
                                if (value == listClasse[0]) {
                                  DInfo.toastError("Faites des Choix svp !!");
                                } else {
                                  if (i == 1) {
                                    choixClasse = value;
                                    confirm2();
                                  } else {
                                    setState(() {
                                      choixClasse = value;
                                      choixMatiere = "";
                                      choixTrimestre = "";
                                    });
                                    Navigator.of(context).pop();
                                  }
                                }
                              }
                            },
                            child: CustomText(
                              (i != 1) ? "soumettre" : "envoyer",
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
    for (var i = 0; i < feedClasse.length; i++) {
      if (value == feedClasse[i].libelleClasse.toString()) {
        setState(() {
          idValue = int.parse(feedClasse[i].idClasse.toString());
          classeID = idValue;
        });
      }
    }

    saveClasseID!.setInt('classeID', int.parse(idValue.toString()));

    if (widget.x == 0) {
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
    }

    setState(() {
      matiereID = (saveMatiereID!.getInt('matiereID') ?? 0);
      trimestreID = (saveMatiereID!.getInt('trimestreID') ?? 0);
      anneeID = (saveLastAnneeID!.getInt('lastAnneeID') ?? 0);
      classeID = (saveClasseID!.getInt('classeID') ?? 0);

      debugPrint(
          " mat : $matiereID .. tri : $trimestreID .. ann : $anneeID ... classe : $classeID .... note : $numeroValue");
    });

    Timer(const Duration(milliseconds: 100), () {
      loadEleve();
      loadCountNote();
    });

    Timer(const Duration(milliseconds: 2000), () {
      setState(() {
        loading = true;
      });
    });
  }

  openPage(int i, ElevesModel eleve) {
    switch (i) {
      case 0:
        {
          debugPrint("0");
          Navigator.of(context).push(
            SlideRightRoute(
                child: SendNotePage(
                  eleve: eleve,
                  matiere: choixMatiere,
                  classe: choixClasse,
                ),
                page: SendNotePage(
                  eleve: eleve,
                  matiere: choixMatiere,
                  classe: choixClasse,
                ),
                direction: AxisDirection.left),
          );
          break;
        }

      case 1:
        {
          debugPrint("1");
          Navigator.of(context).push(
            SlideRightRoute(
                child: SendEmploiPage(
                  eleve: eleve,
                  classe: choixClasse,
                ),
                page: SendEmploiPage(
                  eleve: eleve,
                  classe: choixClasse,
                ),
                direction: AxisDirection.left),
          );
          break;
        }

      case 2:
        {
          debugPrint("2");
          Navigator.of(context).push(
            SlideRightRoute(
                child: SendConvocation(
                  eleve: eleve,
                  classe: choixClasse,
                ),
                page: SendConvocation(
                  eleve: eleve,
                  classe: choixClasse,
                ),
                direction: AxisDirection.left),
          );
          break;
        }

      case 3:
        {
          Navigator.of(context).push(
            SlideRightRoute(
                child: SendRetard(
                  eleve: eleve,
                  classe: choixClasse,
                ),
                page: SendRetard(
                  eleve: eleve,
                  classe: choixClasse,
                ),
                direction: AxisDirection.left),
          );
          debugPrint("3");
          break;
        }

      default:
    }
  }

  envoiConvocation() {
    for (var i = 0; i < listEleves.length; i++) {
      message =
          " Le ${verType.poste} du ${verType.lycee} convie les Parents de l'élève ${listEleves[i].nomEleve.toString().toUpperCase()} ${listEleves[i].prenomEleve.toString().toUpperCase()} a une importante rencontre le ${date1.toString().toUpperCase()} à ${heure1.toString().toUpperCase()} ";

      sender.sendSms(SmsMessage(listEleves[i].phoneParent, message));
    }

    Timer(const Duration(milliseconds: 10), () {
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
        },
      );
    });
  }

  envoiNotes() async {
    for (var i = 0; i < listEleves.length; i++) {
      int id = int.parse(listEleves[i].idEleve.toString());

      await loadNote(id);
      //sender.sendSms(SmsMessage(listEleves[i].phoneParent, message));

      String a = note();

      textMessage = (a.length <= 2)
          ? '''**L'élève ${listEleves[i].prenomEleve.toString()} a eu $a à la note N°$noteID de ${choixMatiere.toString()} au trimestre $trimestreID.'''
          : '''**\n\nL'élève ${listEleves[i].prenomEleve.toString()} n'a pas eu de Note N°$noteID en ${choixMatiere.toString().toUpperCase()} au Trismetre $trimestreID.''';

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

  envoiEmploi() async {
    for (var i = 0; i < listEleves.length; i++) {
      //sender.sendSms(SmsMessage(listEleves[i].phoneParent, message));
      SmsMessage message1 =
          SmsMessage(listEleves[i].phoneParent, textMessageEmp1);
      sender.sendSms(message1);

      SmsMessage message2 =
          SmsMessage(listEleves[i].phoneParent, textMessageEmp2);
      sender.sendSms(message2);

      SmsMessage message3 =
          SmsMessage(listEleves[i].phoneParent, textMessageEmp3);
      sender.sendSms(message3);

      SmsMessage message4 =
          SmsMessage(listEleves[i].phoneParent, textMessageEmp4);
      sender.sendSms(message4);

      SmsMessage message5 =
          SmsMessage(listEleves[i].phoneParent, textMessageEmp5);
      sender.sendSms(message5);
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

/* boite de Dialogue de Classe  */
  Future<void> dialogueConvocation() async {
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
                          " Choississez la date et l'heure ",
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                          tex: TailleText(context).contenu * 1.2,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      IconButton(
                          onPressed: () {
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
                      height: 10,
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
                            String day = convert(date.day.toString());
                            String month = convert(date.month.toString());
                            String year = convert(date.year.toString());

                            dateController.text = " $day / $month / $year ";
                            //date1 = dateController.text;
                            date1 = DateFormat.yMMMMEEEEd('fr')
                                .format(date)
                                .toString();
                          });
                        }
                      },
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 15, right: 15),
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: TextFormField(
                                maxLines: 1,
                                enabled: false,
                                controller: dateController,
                                onSaved: (onSavedval) {
                                  dateController.text = onSavedval!;
                                },
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      dateController.text.isEmpty) {
                                    debugPrint(dateController.text);
                                    return " entrer une date de rencontre svp !! ";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  labelText: "Date de la rencontre",
                                  hintText: "Date de la rencontre",
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
                        ],
                      ),
                    ),
                    const SizedBox(
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
                            String minute =
                                convert(selectedTime.minute.toString());
                            String heure =
                                convert(selectedTime.hour.toString());
                            timeController.text = " $heure : $minute ";
                            heure1 = timeController.text;
                          });
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 15, right: 15),
                        width: MediaQuery.of(context).size.width * 0.9,
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
                              labelText: "Heure de la Rencontre",
                              hintText: "Heure de la Rencontre",
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
                    ),
                    Container(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: teal(),
                            shadowColor: Colors.blueGrey,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40.0, vertical: 15.0),
                            elevation: 8.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: () {
                            confirm1();
                          },
                          child: CustomText("Envoyer",
                              color: Colors.white,
                              tex: TailleText(context).soustitre)),
                    ),
                  ],
                )));
  }

  callsearchDialogue() {
    Timer(const Duration(milliseconds: 100), () {
      searchClasse(widget.x);
    });
  }

//* load Classe , eleves , id etc......
//* load Classe , eleves , id etc......
//* load Classe , eleves , id etc......
//* load Classe , eleves , id etc......

//* load Classe
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

//* load ID for All
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
  }

//* load eleves for Classe

  loadEleve() async {
    Future<List<ElevesModel>> result =
        Eleve().listEleve(id1: classeID, id2: anneeID);

    listEleves = await result;
    setState(() {
      feedEleve = result;
      feedSearchEleve = result;
    });
  }

  loadCountNote() async {
    String res1 = await Notes()
        .countNoteOfTrismetre(trimestreID, matiereID, anneeID, classeID);

    setState(() {
      countNoteTrimestre = int.parse(res1);
      debugPrint("nombre de Note $countNoteTrimestre");
    });
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

  confirm() {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.confirm,
      title: "ENVOI DE MESSAGE",
      text: "Etes vous sur de vouloir envoyer ces messages?",
      loopAnimation: true,
      confirmBtnText: 'OUI',
      cancelBtnText: 'NON',
      barrierDismissible: false,
      confirmBtnColor: bleu(),
      backgroundColor: bleu(),
      onConfirmBtnTap: () async {
        Navigator.pop(context);
        dialogueNote();
        envoiNotes();
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
            },
          );
        });
      },
      onCancelBtnTap: () {
        Navigator.pop(context);
      },
    );
  }

  confirm1() {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.confirm,
      title: "ENVOI DE MESSAGE",
      text: "Etes vous sur de vouloir envoyer ces messages?",
      loopAnimation: true,
      confirmBtnText: 'OUI',
      cancelBtnText: 'NON',
      barrierDismissible: false,
      confirmBtnColor: bleu(),
      backgroundColor: bleu(),
      onConfirmBtnTap: () async {
        Navigator.pop(context);
        envoiConvocation();
      },
      onCancelBtnTap: () {
        Navigator.pop(context);
      },
    );
  }

  confirm2() {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.confirm,
      title: "ENVOI DE MESSAGE",
      text: "Etes vous sur de vouloir envoyer ces messages?",
      loopAnimation: true,
      confirmBtnText: 'OUI',
      cancelBtnText: 'NON',
      barrierDismissible: false,
      confirmBtnColor: bleu(),
      backgroundColor: bleu(),
      onConfirmBtnTap: () async {
        Navigator.pop(context);
        Timer(const Duration(milliseconds: 2000), () {
          envoiEmploi();
        });

        //dialogueNote();

        Navigator.of(context).pop();
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
            },
          );
        });
      },
      onCancelBtnTap: () {
        Navigator.pop(context);
      },
    );
  }
}
