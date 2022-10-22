import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sysgesco/controllers/matiere_controller.dart';
import 'package:sysgesco/models/matiere_model.dart';

import '../../../functions/colors.dart';
import '../../../functions/custom_text.dart';
import '../../../functions/dialoguetoast.dart';
import '../../../functions/fonctions.dart';

class MatierePage extends StatefulWidget {
  const MatierePage({super.key});

  @override
  State<MatierePage> createState() => _MatierePageState();
}

class _MatierePageState extends State<MatierePage> {
  late Future<List<MatiereModel>> feedMatiere;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  MatiereModel verType = MatiereModel();



  List<TextEditingController> list = [
    TextEditingController(),
  ];
  bool see = false;
  bool modify = false;
  String labelContainer = "Ajouter une Nouvelle Matiere ";
  bool loading = false;

  load() {
    setState(() {
      feedMatiere = Matiere().listMatiere();
    });
  }

  @override
  void initState() {
    load();
    Timer(const Duration(milliseconds: 1000), () {
      setState(() {
        loading = true;
      });
      refreshList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des Matieres"),
      ),
      body: SafeArea(
        child: Stack(children: [
          (loading) ? listGenerate() : pageLoading(context),
          (see)
              ? InkWell(
                  onTap: () {
                    setState(() {
                      see = false;
                      modify = false;
                      clearControler(list);
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.black87.withOpacity(0.3),
                  ),
                )
              : Container(),
          (see) ? ajoutCategorie(verType) : Container()
        ]),
      ),
      floatingActionButton: (!see)
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  see = true;
                  modify = false;
                  labelContainer = "Enregistrer une Nouvelle Matiere ";
                });
              },
              elevation: 10.0,
              backgroundColor: Colors.teal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              child: const Icon(Icons.add))
          : Container(),
    );
  }

  Widget listGenerate() {
    return FutureBuilder<List<MatiereModel>>(
        future: feedMatiere,
        builder:
            (BuildContext context, AsyncSnapshot<List<MatiereModel>> snapshot) {
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
          List<MatiereModel>? data = snapshot.data;
          return ListView.builder(
              itemCount: data!.length,
              itemBuilder: (context, index) {
                MatiereModel item = data[index];
                return cardWidget(item);
              });
        });
  }

  Widget cardWidget(MatiereModel element) {
    return Column(
      children: [
        Container(
          color: Colors.transparent,
          padding: const EdgeInsets.only(left: 0.5, right: 0.5),
          child: ListTile(
            onTap: () {
              setState(() {
                see = true;
                labelContainer = "Modifier la Matiere";
                modify = true;
                verType = element;
                ajoutCategorie(verType);
              });
            },
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    element.libelleMatieres.toString(),
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                    textScaleFactor: 1.1,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(
          color: Colors.black87,
        ),
      ],
    );
  }

  Widget ajoutCategorie(MatiereModel elem) {
    if (modify) {
      // list[0].text = elem.libelleMatieres.toString();

    }
    return Align(
        alignment: Alignment.bottomCenter,
        child: ClipRRect(
          clipBehavior: Clip.hardEdge,
          child: Card(
            color: blanc(),
            elevation: 30.0,
            shadowColor: Colors.black87,
            margin: const EdgeInsets.all(0.0),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              side: BorderSide(color: Colors.transparent, width: 1.0),
            ),
            child: Form(
              key: formKey,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: CustomText(
                          labelContainer,
                          tex: TailleText(context).titre,
                          color: teal(),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    (modify)
                        ? IconButton(
                            onPressed: () {
                              deleteOne(elem);
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 25,
                            ))
                        : Container(),
                    Container(
                      width: 15,
                    )
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 15, bottom: 15),
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: TextFormField(
                      maxLines: 1,
                      controller: list[0],
                      onFieldSubmitted: (value) async {
                        FocusScope.of(context).unfocus();
                        list[0].text = value;
                      },
                      onSaved: (onSavedval) {
                        list[0].text = onSavedval!;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return " entrer un Libelle svp !! ";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: (!modify)
                            ? "Libelle Matiere"
                            : " ${elem.libelleMatieres.toString()}",
                        focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.teal, width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        border: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.teal, width: 0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 15,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.teal.shade700,
                              shadowColor: Colors.teal.shade300,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40.0, vertical: 15.0),
                              elevation: 5.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            onPressed: () {
                              if (validateAndSave(formKey)) {
                                (modify) ? modifiyType(elem) : insertType();
                                Timer(const Duration(milliseconds: 200), () {
                                  refreshList();
                                });
                              } else {
                                DInfo.toastError(" Remplissez les champs SVP ");
                              }
                            },
                            child: const Text(
                              "enregistrer",
                              style: TextStyle(fontSize: 20),
                            )),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 15,
                ),
              ]),
            ),
          ),
        ));
  }

  //supprimer un element
  Future<void> deleteOne(MatiereModel elem) async {
    setState(() {
      Matiere().deleteMatiere(elem);
      DInfo.toastSuccess("Suppression effectuée avec Success");
      Timer(const Duration(milliseconds: 200), () {
        refreshList();
      });
    });
  }

  // modifier un element
  Future<void> modifiyType(MatiereModel elem) async {
    MatiereModel newElem = MatiereModel(
        idMatieres: elem.idMatieres, libelleMatieres: list[0].text.toString());
    Matiere().editMatiere(newElem);
    DInfo.toastSuccess("Modification effectué avec Success");
  }

  // inserer un element
  Future<void> insertType() async {
    MatiereModel newElem =
        MatiereModel(libelleMatieres: list[0].text.toString());
    Matiere().insertMatiere(newElem);
    DInfo.toastSuccess("Ajout effectué avec Success");
  }

  // rafraichir la liste
  Future<void> refreshList() async {
    setState(() {
      feedMatiere = Matiere().listMatiere();
      see = false;
      modify = false;
      clearControler(list);
    });
  }
}
