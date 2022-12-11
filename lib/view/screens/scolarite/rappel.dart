import 'dart:async';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_advanced/sms_advanced.dart';
import 'package:sysgesco/functions/dialoguetoast.dart';

import '../../../controllers/classe_controller.dart';
import '../../../controllers/eleve_controller.dart';
import '../../../functions/colors.dart';
import '../../../functions/custom_text.dart';
import '../../../functions/fonctions.dart';
import '../../../models/classe_model.dart';
import '../../../models/eleve_model.dart';

class RappelPage extends StatefulWidget {
  const RappelPage({super.key});

  @override
  State<RappelPage> createState() => _RappelPageState();
}

class _RappelPageState extends State<RappelPage> {
  TextEditingController editingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Future<List<ElevesModel>> feedEleve;
  List<ElevesModel> listEleves = [];
  List<ElevesModel> selectList = [];

  SmsSender sender = SmsSender();

  List<ClasseModel> feedClasse = [];
  final listClasse = ['-- choisir une classe --'];
  String value = '-- choisir une classe --';
  int idValue = 0;
  String choixClasse = "-- choisir une classe --";

  int choix = 0;
  bool loading = false;
  int anneeID = 0;
  late SharedPreferences? saveLastAnneeID;

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
  }

  void checkID() async {
    saveLastAnneeID = await SharedPreferences.getInstance();

    setState(() {
      anneeID = (saveLastAnneeID!.getInt('lastAnneeID') ?? 0);
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
      appBar: AppBar(
        title: const Text("Message de Rappel"),
        actions: [
          Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomText(
              "${selectList.length}",
              fontWeight: FontWeight.w700,
            ),
          ))
        ],
      ),
      body: (loading)
          ? Column(
              children: [
                Container(
                  height: 35.0,
                ),
                CustomText(
                  "Zone des Messages",
                  color: tealFonce(),
                  tex: 1.2,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w700,
                ),
                Container(
                  height: 30.0,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 15, right: 15),
                        width: MediaQuery.of(context).size.width * 0.85,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: TextFormField(
                            maxLines: 3,
                            controller: editingController,
                            onSaved: (onSavedval) {
                              editingController.text = onSavedval!;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return " entrer un message svp !! ";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              hintText: " Saisir le message",
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
                    ],
                  ),
                ),
                Container(
                  height: 50.0,
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
                      if (validateAndSave(_formKey)) {
                        confirm();
                      }
                    },
                    child: CustomText(
                        (selectList.isNotEmpty) ? "Envoyer" : "Envoi Groupé",
                        color: Colors.white,
                        tex: TailleText(context).soustitre)),
                Container(
                  height: 30,
                ),
                Expanded(
                  child: elemntInList(),
                ),
              ],
            )
          : Center(
              child: pageLoading(context),
            ),
    );
  }

  confirm() {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.confirm,
      title: "ENVOI DE MESSAGE",
      text: "Etes vous sur de vouloir envoyer ce message?",
      loopAnimation: true,
      confirmBtnText: 'OUI',
      cancelBtnText: 'NON',
      barrierDismissible: false,
      confirmBtnColor: bleu(),
      backgroundColor: bleu(),
      onConfirmBtnTap: () async {
        Navigator.pop(context);
        dialogueNote(context, "envoi en cours");
        if (selectList.isEmpty) {
          for (var i = 0; i < listEleves.length; i++) {
            SmsMessage message = SmsMessage(
                listEleves[i].phoneParent, editingController.text.toString());

            message.onStateChanged.listen((state) {
              if (state == SmsMessageState.Sent) {
                debugPrint("SMS is sent!");
              } else if (state == SmsMessageState.Delivered) {
                debugPrint("SMS is delivered!");
              }
            });
            sender.sendSms(message);
          }
        } else {
          for (var i = 0; i < selectList.length; i++) {
            SmsMessage message = SmsMessage(
                selectList[i].phoneParent, editingController.text.toString());

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

        Timer(const Duration(milliseconds: 1000), () {
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

//* boite de Dialogue de Classe  */
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
                            onPressed: () async {
                              if (value == listClasse[0]) {
                                DInfo.toastError("Faites des Choix svp !!");
                              } else {
                                setState(() {
                                  choixClasse = value;
                                });
                                Navigator.of(context).pop();
                                searchId();

                                Future<List<ElevesModel>> result = Eleve()
                                    .listEleve(id1: idValue, id2: anneeID);
                                setState(() {
                                  feedEleve = result;
                                });
                                listEleves = await result;

                                Timer(const Duration(milliseconds: 2500), () {
                                  setState(() {
                                    loading = true;
                                  });
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
  }

  callsearchDialogue() {
    Timer(const Duration(milliseconds: 500), () {
      searchClasse(context);
    });
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
}
