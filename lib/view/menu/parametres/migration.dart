import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../controllers/annee_controller.dart';
import '../../../controllers/eleve_controller.dart';
import '../../../functions/colors.dart';
import '../../../functions/custom_text.dart';
import '../../../functions/dialoguetoast.dart';
import '../../../functions/fonctions.dart';
import '../../../models/annee_model.dart';
import '../../../models/classe_model.dart';
import '../../../controllers/classe_controller.dart';
import '../../../models/eleve_model.dart';

class MigrationElevePage extends StatefulWidget {
  const MigrationElevePage({super.key});

  @override
  State<MigrationElevePage> createState() => _MigrationElevePageState();
}

class _MigrationElevePageState extends State<MigrationElevePage> {
  late Future<List<ElevesModel>> feedEleve;
  int classeID = 0;
  int anneeID = 0;
  bool loading = false;
  List<AnneeModel> feedAnnee = [];
  late SharedPreferences? saveClasseID;
  late SharedPreferences? saveLastAnneeID;
  List<ClasseModel> feedClasse = [];

  final listAnnee = ['-- choisir une annee --'];
  String valueAnnee = '-- choisir une annee --';
  int idValueAnnee = 0;

  final listClasse = ['-- choisir une classe --'];
  String value = '-- choisir une classe --';
  int idValue = 0;

  final listClasse1 = ['-- choisir une classe --'];
  String value1 = '-- choisir une classe --';
  int idValue1 = 0;

  String choixClasse = "-- choisir une classe --";

  List<ElevesModel> selectList = [];

  loadClasse() async {
    List<ClasseModel> result = await Classe().listClasse();
    setState(() {
      feedClasse = result;
    });

    for (var i = 0; i < feedClasse.length; i++) {
      setState(() {
        listClasse.add(feedClasse[i].libelleClasse.toString());
        listClasse1.add(feedClasse[i].libelleClasse.toString());
      });
    }

    List<AnneeModel> resultss = await Annee().listAnnee();
    setState(() {
      feedAnnee = resultss;
    });

    for (var i = 0; i < feedAnnee.length; i++) {
      setState(() {
        listAnnee.add(feedAnnee[i].libelleAnnee.toString());
      });
    }
  }

  void checkID() async {
    saveClasseID = await SharedPreferences.getInstance();
    saveLastAnneeID = await SharedPreferences.getInstance();

    setState(() {
      anneeID = (saveLastAnneeID!.getInt('lastAnneeID') ?? 0);
      classeID = (saveClasseID!.getInt('classeID') ?? 0);
    });

    loadClasse();
  }

  @override
  void initState() {
    checkID();
    callsearchDialogue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (selectList.isEmpty)
          ? AppBar(
              title: const Text("Migration des Eleves "),
            )
          : menuAppBar(selectList, context),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 15.0,
            ),
            CustomText(
              " Classe     :   ${value.toUpperCase()}",
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
              height: 40,
            ),
            Expanded(child: (loading) ? elemntInList() : pageLoading(context)),
          ],
        ),
      ),
      floatingActionButton: (selectList.isNotEmpty)
          ? FloatingActionButton.extended(
              onPressed: () {
                migreClasse(context);
              },
              elevation: 10.0,
              backgroundColor: amberFone(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              label: CustomText(
                "Migrer",
                fontWeight: FontWeight.w600,
              ),
              icon: const Icon(Icons.send),
            )
          : Container(),
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

                return cardWidget(item);
              });
        });
  }

  Widget cardWidget(ElevesModel element) {
    return Card(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Container(
        padding: const EdgeInsets.only(left: 0.5, right: 0.5),
        color: (!addElement(element))
            ? tealClaire().withOpacity(0.4)
            : Colors.transparent,
        child: ListTile(
          onTap: () {
            if (selectList.isNotEmpty) {
              if (addElement(element)) {
                setState(() {
                  selectList.add(element);
                });
              } else {
                setState(() {
                  selectList.remove(element);
                });
              }
            }
          },
          onLongPress: () {
            if (addElement(element)) {
              setState(() {
                selectList.add(element);
              });
            }
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

  bool addElement(ElevesModel eleves) {
    for (var i = 0; i < selectList.length; i++) {
      if (eleves.idEleve.toString() == selectList[i].idEleve.toString()) {
        return false;
      }
    }
    return true;
  }

  callsearchDialogue() {
    Timer(const Duration(milliseconds: 300), () {
      searchClasse(context);
    });
  }

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
                            if (choixClasse == listClasse[0]) {
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
                                });
                                searchId();
                                Timer(const Duration(milliseconds: 200),
                                    () async {
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

  searchId() {
    for (var i = 0; i < feedClasse.length; i++) {
      if (value == feedClasse[i].libelleClasse.toString()) {
        setState(() {
          idValue = int.parse(feedClasse[i].idClasse.toString());
        });
      }
    }

    saveClasseID!.setInt('classeID', int.parse(idValue.toString()));

    setState(() {
      classeID = idValue;
    });

    Future<List<ElevesModel>> result =
        Eleve().listEleve(id1: classeID, id2: anneeID);

    feedEleve = result;

    Timer(const Duration(milliseconds: 1500), () {
      setState(() {
        loading = true;
      });
    });
  }

  searchId1() async {
    for (var i = 0; i < feedClasse.length; i++) {
      if (value1 == feedClasse[i].libelleClasse.toString()) {
        setState(() {
          idValue1 = int.parse(feedClasse[i].idClasse.toString());
        });
      }
    }

    for (var i = 0; i < feedAnnee.length; i++) {
      if (valueAnnee == feedAnnee[i].libelleAnnee.toString()) {
        setState(() {
          idValueAnnee = int.parse(feedAnnee[i].idAnnee.toString());
        });
      }
    }

    for (var i = 0; i < selectList.length; i++) {
      debugPrint(selectList[i].idEleve.toString());

      await Eleve().insertLien(
          int.parse(selectList[i].idEleve.toString()), idValue1, idValueAnnee);

      if (i == (selectList.length - 1)) {
        Timer(const Duration(milliseconds: 2000), () {
          DInfo.toastSuccess("Migration effectuée avec succes");
          Navigator.pop(context);
        });
      }
    }
  }

/* boite de Dialogue de Classe  */
  Future<void> migreClasse(BuildContext parentContext) async {
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
                            if (choixClasse == listClasse[0]) {
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
                            value: value1,
                            isExpanded: true,
                            items: listClasse1.map(buildMenuItem).toList(),
                            iconSize: 30,
                            iconEnabledColor: Colors.blueGrey,
                            onChanged: ((value) {
                              stfsetState(() {
                                value1 = value!;
                              });
                              setState(() {
                                value1 = value!;
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
                            value: valueAnnee,
                            isExpanded: true,
                            items: listAnnee.map(buildMenuItem).toList(),
                            iconSize: 30,
                            iconEnabledColor: Colors.blueGrey,
                            onChanged: ((value) {
                              stfsetState(() {
                                valueAnnee = value!;
                              });
                              setState(() {
                                valueAnnee = value!;
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
                            onPressed: () async {
                              if (value1 == listClasse1[0] ||
                                  valueAnnee == listAnnee[0]) {
                                DInfo.toastError("Faites des Choix svp !!");
                              } else {
                                Navigator.pop(context);
                                searchId1();
                                dialogueNote(context, "Migration en cours ...");
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
}
