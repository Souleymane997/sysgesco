import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sysgesco/controllers/matiere_controller.dart';
import 'package:sysgesco/models/matiere_model.dart';
import 'package:sysgesco/view/screens/classe/statistiques.dart';

import '../../../controllers/classe_controller.dart';
import '../../../functions/colors.dart';
import '../../../functions/custom_text.dart';
import '../../../functions/dialoguetoast.dart';
import '../../../functions/fonctions.dart';
import '../../../functions/slidepage.dart';
import '../../../models/classe_model.dart';
import 'liste.dart';
import 'listing.dart';
import 'moyenne.dart';

class VoirPlusPage extends StatefulWidget {
  const VoirPlusPage({super.key, required this.choix, required this.classe});

  final int choix;
  final ClasseModel classe;

  @override
  State<VoirPlusPage> createState() => _VoirPlusPageState();
}

class _VoirPlusPageState extends State<VoirPlusPage> {
  List<ClasseModel> feedClasse = [];
  List<MatiereModel> feedMatiere = [];
  late SharedPreferences? saveClasseID;
  late SharedPreferences? saveMatiereID;

  final listClasse = ['-- choisir une classe --'];
  String value = '-- choisir une classe --';
  int idValue = 0;
  String choixClasse = "-- choisir une classe --";

  final listMatiere = ['-- choisir une matière --'];
  String mat = '-- choisir une matière --';
  int idMat = 0;
  String choixMatiere = "-- choisir une matière --";

  int choix = 0;
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
  }

  void checkClasseID() async {
    loadClasse();
    saveClasseID = await SharedPreferences.getInstance();
    saveMatiereID = await SharedPreferences.getInstance();

    int newInt = (saveClasseID!.getInt('classeID') ?? 0);
    int newInt1 = (saveMatiereID!.getInt('matiereID') ?? 0);
    debugPrint("idClasse : $newInt");
    debugPrint("idMatiere : $newInt1");
  }

  @override
  void initState() {
    Timer(const Duration(milliseconds: 200), () {
      checkClasseID();
    });

    choix = widget.choix;
    if (choix == 1) {
      value = widget.classe.libelleClasse.toString();
      choixClasse = value;
      callsearchDialogue();
    } else {
      callsearchDialogue();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text("Ma Classe"),
        actions: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    searchClasse(context);
                  },
                  icon: const Icon(Icons.filter_center_focus)),
              Container(
                width: 20,
              ),
            ],
          )
        ],
      ),
      body: Stack(
        children:[ 
          (loading)? buildBody() : Container(),
            (!loading)?Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: blanc(),
            ) : Container(),
          (!loading)? pageLoading(context) : Container(),

      ]),
    );
  }


  Widget buildBody(){
    return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Center(
              child: Column(
                children: [
                  Container(
                    height: 15,
                  ),
                  CustomText(
                    " VOTRE CLASSE ",
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
                  Column(
                    children: [
                      Container(
                        height: 15,
                      ),
                      CustomText(
                        " Classe     :   $value",
                        color: amberFone(),
                        fontWeight: FontWeight.w600,
                      ),
                      Container(
                        height: 3,
                      ),
                      CustomText(
                        "Matière :   $mat",
                        color: noir(),
                        fontWeight: FontWeight.w600,
                      )
                    ],
                  ),
                  Container(
                    height: 50,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 35, right: 35, top: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            classButton(
                                "Liste",
                                Icons.library_books,
                                Colors.teal,
                                AfficheNote(
                                  matiere: mat,
                                )),
                          ],
                        ),
                        Container(
                          height: 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            classButton(
                                "Notes",
                                Icons.import_contacts,
                                Colors.teal,
                                ListingPage(matiere: mat, classe: value)),
                            classButton("Statistiques", Icons.trending_up,
                                Colors.teal, const Statistiques()),
                          ],
                        ),
                        Container(
                          height: 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            classButton(
                                "Moyennes",
                                Icons.equalizer,
                                Colors.amber.shade700,
                                MoyennePage(
                                  matiere: mat,
                                )),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )) ;
  }

  Widget classButton(String nom, IconData icon, Color color, Widget x) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          shadowColor: Colors.blueGrey,
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        onPressed: () {
          Navigator.of(context).push(
            SlideRightRoute(child: x, page: x, direction: AxisDirection.left),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(icon),
            Container(
              width: 5,
            ),
            CustomText(nom,
                color: Colors.white, tex: TailleText(context).soustitre),
          ],
        ));
  }

  callsearchDialogue() {
    Timer(const Duration(milliseconds: 2000), () {
      setState(() {
        loading = true;
      });
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
                            if (choixMatiere == listMatiere[0] ||
                                choixMatiere == listClasse[0]) {
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
                  ) ,
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
                              if (mat == listMatiere[0] ||
                                  value == listClasse[0]) {
                                DInfo.toastError("Faites des Choix svp !!");
                              } else {
                                setState(() {
                                  choixMatiere = mat;
                                  choixClasse = value;
                                });
                                Navigator.of(context).pop();
                                searchId();
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
                  ] ,
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

    for (var i = 0; i < feedMatiere.length; i++) {
      if (mat == feedMatiere[i].libelleMatieres.toString()) {
        setState(() {
          idMat = int.parse(feedMatiere[i].idMatieres.toString());
        });
      }
    }

    saveClasseID!.setInt('classeID', int.parse(idValue.toString()));
    saveMatiereID!.setInt('matiereID', int.parse(idMat.toString()));
  }
}
