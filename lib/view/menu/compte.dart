import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sysgesco/controllers/compte_controller.dart';
import 'package:sysgesco/models/comptes_models.dart';

import '../../functions/colors.dart';
import '../../functions/custom_text.dart';
import '../../functions/dialoguetoast.dart';
import '../../functions/fonctions.dart';

class AjoutComptePage extends StatefulWidget {
  const AjoutComptePage({super.key});

  @override
  State<AjoutComptePage> createState() => _AjoutComptePageState();
}

class _AjoutComptePageState extends State<AjoutComptePage> {
  late Future<List<ComptesModels>> feedComptes;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ComptesModels verType =
      ComptesModels(idCompte: 0, username: "", password: "", role: 0);

  List<TextEditingController> list = [
    TextEditingController(),
    TextEditingController(),
  ];
  bool see = false;
  bool modify = false;
  String labelContainer = "Nouveau Compte ";
  bool loading = false;

  int idRadio = 1;

  load() {
    setState(() {
      feedComptes = Comptes().listCompte();
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
        title: const Text("Liste des Comptes"),
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
                      idRadio = 1;
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
                  labelContainer = "Nouveau Compte ";
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
    return FutureBuilder<List<ComptesModels>>(
        future: feedComptes,
        builder: (BuildContext context,
            AsyncSnapshot<List<ComptesModels>> snapshot) {
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
          List<ComptesModels>? data = snapshot.data;
          return ListView.builder(
              itemCount: data!.length,
              itemBuilder: (context, index) {
                ComptesModels item = data[index];
                return cardWidget(item);
              });
        });
  }

  Widget cardWidget(ComptesModels element) {
    return Column(
      children: [
        Container(
          color: Colors.transparent,
          padding: const EdgeInsets.only(left: 0.5, right: 0.5),
          child: ListTile(
            onTap: () {
              setState(() {
                see = true;
                labelContainer = "Modifier le Compte";
                modify = true;
                verType = element;
                ajoutCategorie(verType);
              });
            },
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    element.username.toString(),
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

  Widget ajoutCategorie(ComptesModels elem) {
    String statut = "";
    if (modify) {
      // list[0].text = elem.libelleMatieres.toString();
      int i = int.parse(elem.role.toString());
      statut = (i == 1) ? "proviseur" : "sécrétaire";
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
                          return " entrer un Identifiant svp !! ";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: (!modify)
                            ? "Identifiant"
                            : " ${elem.username.toString()}",
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
                  height: 5,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: TextFormField(
                      maxLines: 1,
                      controller: list[1],
                      onFieldSubmitted: (value) async {
                        FocusScope.of(context).unfocus();
                        list[1].text = value;
                      },
                      onSaved: (onSavedval) {
                        list[1].text = onSavedval!;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return " entrer un mot de passe svp !! ";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: (!modify)
                            ? "Mot de Passe"
                            : " ${elem.password.toString()}",
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
                  height: 5,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 15, right: 15),
                  width: MediaQuery.of(context).size.width * 0.85,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: CustomText(
                          (modify)
                              ? "Changer de Statut ($statut)"
                              : "Choississez un Statut",
                          textAlign: TextAlign.left,
                          color: teal(),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: [
                              Radio(
                                value: 1,
                                activeColor: teal(),
                                groupValue: idRadio,
                                onChanged: (val) {
                                  setState(() {
                                    idRadio = 1;
                                  });
                                },
                              ),
                              CustomText(
                                'Proviseur',
                                color: noir(),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                value: 2,
                                activeColor: amber(),
                                groupValue: idRadio,
                                onChanged: (val) {
                                  setState(() {
                                    idRadio = 2;
                                  });
                                },
                              ),
                              CustomText(
                                'Sécrétaire',
                                color: noir(),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
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
                                dialogueNote(
                                    context, "enregistrement en cours");

                                Timer(const Duration(milliseconds: 300), () {
                                  Navigator.pop(context);
                                  (modify)
                                      ? DInfo.toastSuccess(
                                          "Modification effectué avec Success")
                                      : DInfo.toastSuccess(
                                          "Ajout effectué avec Success");

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
  Future<void> deleteOne(ComptesModels elem) async {
    setState(() {
      Comptes().deleteComptes(elem);
      dialogueNote(context, "Suppression en cours");
      Timer(const Duration(milliseconds: 200), () {
        Navigator.pop(context);
        DInfo.toastSuccess("Suppression effectuée avec Success");
        refreshList();
      });
    });
  }

  // modifier un element
  Future<void> modifiyType(ComptesModels elem) async {
    ComptesModels newElem = ComptesModels(
        idCompte: elem.idCompte,
        username: list[0].text.toString(),
        password: list[1].text.toString(),
        role: idRadio);
    Comptes().editComptes(newElem);
  }

  // inserer un element
  Future<void> insertType() async {
    ComptesModels newElem = ComptesModels(
        username: list[0].text.toString(),
        password: list[1].text.toString(),
        role: idRadio);

    Comptes().insertComptes(newElem);
  }

  // rafraichir la liste
  Future<void> refreshList() async {
    setState(() {
      feedComptes = Comptes().listCompte();
      see = false;
      modify = false;
      idRadio = 1;
      clearControler(list);
    });
  }
}
