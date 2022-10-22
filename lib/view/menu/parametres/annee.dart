import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sysgesco/controllers/annee_controller.dart';
import 'package:sysgesco/models/annee_model.dart';

import '../../../functions/colors.dart';
import '../../../functions/custom_text.dart';
import '../../../functions/dialoguetoast.dart';
import '../../../functions/fonctions.dart';

class AnneePage extends StatefulWidget {
  const AnneePage({super.key});

  @override
  State<AnneePage> createState() => _AnneePageState();
}

class _AnneePageState extends State<AnneePage> {
  late Future<List<AnneeModel>> feedAnnee;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AnneeModel verType = AnneeModel();

  List<TextEditingController> list = [
    TextEditingController(),
  ];
  bool see = false;
  bool modify = false;
  String labelContainer = "Ajouter une Annee Scolaire ";
  bool loading = false;

  load() {
    setState(() {
      feedAnnee = Annee().listAnnee();
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
        title: const Text("Liste des Années Scolaires"),
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
                  labelContainer = "Enregistrer une Annee Scolaire";
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
    return FutureBuilder<List<AnneeModel>>(
        future: feedAnnee,
        builder:
            (BuildContext context, AsyncSnapshot<List<AnneeModel>> snapshot) {
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
          List<AnneeModel>? data = snapshot.data;
          return ListView.builder(
              itemCount: data!.length,
              itemBuilder: (context, index) {
                AnneeModel item = data[index];
                return cardWidget(item);
              });
        });
  }

  Widget cardWidget(AnneeModel element) {
    return Column(
      children: [
        Container(
          color: Colors.transparent,
          padding: const EdgeInsets.only(left: 0.5, right: 0.5),
          child: ListTile(
            onTap: () {
              setState(() {
                see = true;
                labelContainer = "Modifier l'Annee Scolaire";
                modify = true;
                verType = element;
                ajoutCategorie(verType);
              });
            },
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    element.libelleAnnee.toString(),
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

  Widget ajoutCategorie(AnneeModel elem) {
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
                            ? "Libelle Classe"
                            : " ${elem.libelleAnnee.toString()}",
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

                                Timer(const Duration(milliseconds: 300), () {
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
  Future<void> deleteOne(AnneeModel elem) async {
    await Annee().deleteAnnee(elem);
    DInfo.toastSuccess("Suppression effectuée avec Success");
    Timer(const Duration(milliseconds: 200), () {
      refreshList();
    });
  }

  // modifier un element
  Future<void> modifiyType(AnneeModel elem) async {
    AnneeModel newElem = AnneeModel(
        idAnnee: elem.idAnnee, libelleAnnee: list[0].text.toString());
    await Annee().editAnnee(newElem);
    DInfo.toastSuccess("Modification effectué avec Success");
  }

  // inserer un element
  Future<void> insertType() async {
    AnneeModel newElem = AnneeModel(libelleAnnee: list[0].text.toString());
    await Annee().insertAnnee(newElem);
    DInfo.toastSuccess("Ajout effectué avec Success");
  }

  // rafraichir la liste
  Future<void> refreshList() async {
    setState(() {
      feedAnnee = Annee().listAnnee();
      see = false;
      modify = false;
      clearControler(list);
    });
  }
}
