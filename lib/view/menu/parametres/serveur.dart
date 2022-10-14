import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sysgesco/models/http.dart';

import '../../../functions/colors.dart';
import '../../../functions/custom_text.dart';
import '../../../functions/dialoguetoast.dart';
import '../../../functions/fonctions.dart';
import '../../../services/database.dart';

class ServeurPage extends StatefulWidget {
  const ServeurPage({super.key});

  @override
  State<ServeurPage> createState() => _ServeurPageState();
}

class _ServeurPageState extends State<ServeurPage> {
  late Future<List<HttpModel>> feedHtpp;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  HttpModel verType = HttpModel(idHttp: 5, cheminHttp: "newLien");

  late SharedPreferences? saveLienHttp;
  late List<HttpModel> feedHtpps;

  List<TextEditingController> list = [TextEditingController()];
  bool see = false;
  bool modify = false;
  String labelContainer = "Ajouter un Nouveau du Lien ";
  bool loading = false;

  load() {
    setState(() {
      feedHtpp = AppDatabase.instance.listHttp();
    });
  }

  @override
  void initState() {
    load();
    Timer(const Duration(milliseconds: 100), () {
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
        title: const Text("Lien du Serveur "),
      ),
      body: SafeArea(
        child: Stack(children: [
          (loading) ? listGenerate() : pageLoading(context),
          (see)
              ? InkWell(
                  onTap: () {
                    setState(() {
                      see = false;
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
    );
  }

  Widget listGenerate() {
    return FutureBuilder<List<HttpModel>>(
        future: feedHtpp,
        builder:
            (BuildContext context, AsyncSnapshot<List<HttpModel>> snapshot) {
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
          List<HttpModel>? data = snapshot.data;
          return ListView.builder(
              itemCount: data!.length,
              itemBuilder: (context, index) {
                HttpModel item = data[index];
                return cardWidget(item);
              });
        });
  }

  Widget cardWidget(HttpModel element) {
    return Column(
      children: [
        Container(
          color: Colors.transparent,
          padding: const EdgeInsets.only(left: 0.5, right: 0.5),
          child: ListTile(
            onTap: () {
              setState(() {
                see = true;
                labelContainer = "Modifier le Lien du Serveur";
                modify = true;
                verType = element;
                ajoutCategorie(verType);
              });
            },
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    element.cheminHttp,
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

  Widget ajoutCategorie(HttpModel elem) {
    if (modify) {
      list[0].text = elem.cheminHttp;
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
                    // (modify)
                    //     ? IconButton(
                    //         onPressed: () {
                    //           deleteOne(elem);
                    //         },
                    //         icon: const Icon(
                    //           Icons.delete,
                    //           color: Colors.red,
                    //           size: 25,
                    //         ))
                    //     : Container(),
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
                      onSaved: (onSavedval) {
                        list[0].text = onSavedval!;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return " entrer un lien svp !! ";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: "Lien du Serveur",
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

                                refreshList();
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
  Future<void> deleteOne(HttpModel elem) async {
    setState(() {
      AppDatabase.instance.deleteHttp(elem.cheminHttp);
      DInfo.toastSuccess("Suppression effectuée avec Success");
      feedHtpp = AppDatabase.instance.listHttp();
      see = false;
      clearControler(list);
    });
  }

  // modifier un element
  Future<void> modifiyType(HttpModel elem) async {
    HttpModel newElem =
        HttpModel(idHttp: elem.idHttp, cheminHttp: list[0].text.toString());
    AppDatabase.instance.updateHttp(newElem);
    DInfo.toastSuccess("Modification effectué avec Success");

    changeLien();
  }

  void changeLien() async {
    saveLienHttp = await SharedPreferences.getInstance();
    feedHtpps = await AppDatabase.instance.listHttp();

    saveLienHttp!.setString('lienHttp', feedHtpps[0].cheminHttp);
  }

  // inserer un element
  Future<void> insertType() async {
    HttpModel newElem = HttpModel(cheminHttp: list[0].text.toString());
    AppDatabase.instance.insertHttp(newElem);
    DInfo.toastSuccess("Ajout effectué avec Success");
  }

  // rafraichir la liste
  Future<void> refreshList() async {
    setState(() {
      feedHtpp = AppDatabase.instance.listHttp();
      see = false;
      clearControler(list);
    });
  }
}
