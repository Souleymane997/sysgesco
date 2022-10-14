import 'dart:async';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_advanced/sms_advanced.dart';
import 'package:sysgesco/view/screens/messages/sendRetard.dart';

import '../../../controllers/classe_controller.dart';
import '../../../controllers/eleve_controller.dart';
import '../../../controllers/matiere_controller.dart';
import '../../../controllers/trimestre_controller.dart';
import '../../../functions/colors.dart';
import '../../../functions/custom_text.dart';
import '../../../functions/dialoguetoast.dart';
import '../../../functions/fonctions.dart';
import '../../../functions/slidepage.dart';
import '../../../models/classe_model.dart';
import '../../../models/eleve_model.dart';
import '../../../models/matiere_model.dart';
import '../../../models/trimestre_model.dart';
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
  List<ElevesModel> selectList = [];
  bool loading = false;

  SmsSender sender = SmsSender();
  String message = ''' bonjour ''';

  List<ElevesModel> listEleves = [];

  // ignore: non_constant_identifier_names
  List<String> Title = [
    "Envoi de Note aux Eleves",
    "Envoi d'Emploi du temps",
    "Envoi de Convocation",
    "Envoi des Retars & Absences"
  ];

  List<String> buttonTitle = [
    "Envoi Groupé ",
    "Envoi d'Emploi du temps",
    "Envoi de Convocation",
    "Envoi des Retars & Absences"
  ];

  List<ClasseModel> feedClasse = [];
  List<MatiereModel> feedMatiere = [];
  List<TrimestreModel> feedTrimestre = [];

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

  int classeID = 0;
  int anneeID = 0;
  int matiereID = 0;
  int trimestreID = 0;
  late SharedPreferences? saveClasseID;
  late SharedPreferences? saveLastAnneeID;
  late SharedPreferences? saveMatiereID;
  late SharedPreferences? saveTrimestreID;

  bool showSearch = false;
  bool boarding = true;
  String changed = '';
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

  void checkID() async {
    loadClasse();
    saveClasseID = await SharedPreferences.getInstance();
    saveLastAnneeID = await SharedPreferences.getInstance();
    saveMatiereID = await SharedPreferences.getInstance();
    saveTrimestreID = await SharedPreferences.getInstance();

    matiereID = (saveMatiereID!.getInt('matiereID') ?? 0);
    trimestreID = (saveMatiereID!.getInt('trimestreID') ?? 0);
    anneeID = (saveLastAnneeID!.getInt('lastAnneeID') ?? 0);
    classeID = (saveClasseID!.getInt('classeID') ?? 0);
  }

  loadEleve() async {
    Future<List<ElevesModel>> result =
        Eleve().listEleve(id1: classeID, id2: anneeID);

    listEleves = await result;
    setState(() {
      feedEleve = result;
      feedSearchEleve = result;
    });
  }

  @override
  void initState() {
    date1 = formatDate(date);
    heure1 = " ${selectedTime.hour} h ${selectedTime.minute} ";
    checkID();
    Timer(const Duration(milliseconds: 500), () {
      callsearchDialogue();
    });

    super.initState();
  }

  callsearchDialogue() {
    Timer(const Duration(milliseconds: 100), () {
      searchClasse(widget.x);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (selectList.isEmpty)
          ? AppBar(
              title: Text(Title[widget.x]),
              actions: [
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
            )
          : menuAppBar(selectList, context),
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
            Container(
              height: 80.0,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (widget.x == 2) {
            dialogueConvocation();
            //envoiConvocation();
          }

          // Navigator.of(context).push(
          //   SlideRightRoute(child:  const TopPage(), page: const TopPage(), direction: AxisDirection.left),
          // );
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
      ),
    );
  }

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
              "${element.nomEleve}  ${element.prenomEleve}",
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
                          Title[widget.x],
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
                                    debugPrint("num note : $numNote");
                                  });
                                  Navigator.of(context).pop();
                                }
                              } else {
                                if (value == listClasse[0]) {
                                  DInfo.toastError("Faites des Choix svp !!");
                                } else {
                                  setState(() {
                                    choixClasse = value;
                                    choixMatiere = "";
                                    choixTrimestre = "";
                                  });
                                  Navigator.of(context).pop();
                                }
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
    for (var i = 0; i < feedClasse.length; i++) {
      if (value == feedClasse[i].libelleClasse.toString()) {
        setState(() {
          idValue = int.parse(feedClasse[i].idClasse.toString());
          classeID = idValue;
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

    for (var i = 0; i < feedTrimestre.length; i++) {
      if (valueTri == feedTrimestre[i].libelleTrimestre.toString()) {
        setState(() {
          idTri = int.parse(feedTrimestre[i].idTrimestre.toString());
        });
      }
    }

    saveClasseID!.setInt('classeID', int.parse(idValue.toString()));
    saveMatiereID!.setInt('matiereID', int.parse(idMat.toString()));
    saveTrimestreID!.setInt('trimestreID', int.parse(idTri.toString()));

    Timer(const Duration(milliseconds: 200), () {
      loadEleve();
    });

    Timer(const Duration(milliseconds: 500), () {
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
          break;
        }

      case 1:
        {
          debugPrint("1");
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
          " Le Proviseur du lycée Privé Wend Yam convie les Parents de l'élève ${listEleves[i].nomEleve} ${listEleves[i].prenomEleve} a une importante rencontre le $date1 à $heure1 ";

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
                            date1 = dateController.text;
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
                            envoiConvocation();
                          },
                          child: CustomText("Envoyer",
                              color: Colors.white,
                              tex: TailleText(context).soustitre)),
                    ),
                  ],
                )));
  }
}
