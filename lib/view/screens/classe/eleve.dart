// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sysgesco/controllers/eleve_controller.dart';

import '../../../functions/colors.dart';
import '../../../functions/custom_text.dart';
import '../../../functions/dialoguetoast.dart';
import '../../../functions/fonctions.dart';
import '../../../models/eleve_model.dart';

class ViewElevePage extends StatefulWidget {
  const ViewElevePage({super.key, required this.eleve});
  final ElevesModel eleve;
  @override
  State<ViewElevePage> createState() => _ViewElevePageState();
}

class _ViewElevePageState extends State<ViewElevePage> {
  late ElevesModel element;

  List<TextEditingController> listController = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];

  DateTime date = DateTime(2022, 12, 24);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool modify = false;

  late SharedPreferences? saveDataUser;

  int statut = 0;

  void checkUserLogin() async {
    saveDataUser = await SharedPreferences.getInstance();

    setState(() {
      statut = saveDataUser!.getInt("role") ?? -1;
    });
  }

  @override
  void initState() {
    element = widget.eleve;
    checkUserLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: const Text("Gestion Eleve"),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              height: 15,
            ),
            CustomText(
              "Informations de l'éleve",
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
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 15,
                ),
                CustomText(
                  "Nom : ",
                  tex: TailleText(context).soustitre,
                  color: tealFonce(),
                  fontWeight: FontWeight.w600,
                ),
                Container(
                  width: 15,
                ),
                Expanded(
                  child: CustomText(
                    element.nomEleve!.toUpperCase(),
                    tex: TailleText(context).soustitre * 1.15,
                    color: gris(),
                    textAlign: TextAlign.right,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  width: 25,
                ),
              ],
            ),
            Container(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 15,
                ),
                CustomText(
                  "Prenom(s) : ",
                  tex: TailleText(context).soustitre,
                  color: tealFonce(),
                  fontWeight: FontWeight.w600,
                ),
                Container(
                  width: 15,
                ),
                Expanded(
                  child: CustomText(
                    element.prenomEleve!.toUpperCase(),
                    tex: TailleText(context).soustitre * 1.15,
                    color: gris(),
                    textAlign: TextAlign.right,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  width: 25,
                ),
              ],
            ),
            Container(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 15,
                ),
                CustomText(
                  "Date de Naissance : ",
                  tex: TailleText(context).soustitre,
                  color: tealFonce(),
                  fontWeight: FontWeight.w600,
                ),
                Container(
                  width: 15,
                ),
                Expanded(
                  child: CustomText(
                    element.dateNaissance!.toUpperCase(),
                    tex: TailleText(context).soustitre * 1.15,
                    color: gris(),
                    textAlign: TextAlign.right,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  width: 25,
                ),
              ],
            ),
            Container(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 15,
                ),
                CustomText(
                  "Matricule : ",
                  tex: TailleText(context).soustitre,
                  color: tealFonce(),
                  fontWeight: FontWeight.w600,
                ),
                Container(
                  width: 15,
                ),
                Expanded(
                  child: CustomText(
                    element.matriculeEleve!.toUpperCase(),
                    tex: TailleText(context).soustitre * 1.15,
                    color: gris(),
                    textAlign: TextAlign.right,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  width: 25,
                ),
              ],
            ),
            Container(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 15,
                ),
                CustomText(
                  "Telephone des Parents : ",
                  tex: TailleText(context).soustitre,
                  color: tealFonce(),
                  fontWeight: FontWeight.w600,
                ),
                Container(
                  width: 15,
                ),
                Expanded(
                  child: CustomText(
                    element.phoneParent!.toUpperCase(),
                    tex: TailleText(context).soustitre * 1.15,
                    color: gris(),
                    textAlign: TextAlign.right,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  width: 25,
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
          icon: Icons.admin_panel_settings,
          backgroundColor: amberFone(),
          children: [
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
                dialogEleve(context, element);
              },
            ),
            (statut == 1 || statut == 0)
              ? SpeedDialChild(
              child: SizedBox(
                  width: 30,
                  height: 20,
                  child: Icon(
                    Icons.delete,
                    color: blanc(),
                  )),
              label: 'Supprimer',
              backgroundColor: Colors.red,
              onTap: () {
                CoolAlert.show(
                  context: context,
                  type: CoolAlertType.confirm,
                  title: "SUPPRESSION",
                  text: "Etes vous sur de vouloir supprimer cet élève?",
                  loopAnimation: true,
                  confirmBtnText: 'OUI',
                  cancelBtnText: 'NON',
                  barrierDismissible: false,
                  confirmBtnColor: bleu(),
                  backgroundColor: bleu(),
                  onConfirmBtnTap: () async {
                    Navigator.pop(context);
                    dialogueNote(context, "Suppression en cours");
                    int id = int.parse(element.idEleve.toString());
                    await Eleve().deleteEleve(id: id);

                    Timer(const Duration(milliseconds: 2000), () {
                      Navigator.pop(context);
                      CoolAlert.show(
                        context: context,
                        type: CoolAlertType.success,
                        text: "Etes vous sur de vouloir supprimer cet élève?",
                        loopAnimation: true,
                        confirmBtnText: 'OK',
                        barrierDismissible: false,
                        confirmBtnColor: tealClaire(),
                        backgroundColor: tealClaire(),
                        onConfirmBtnTap: () {
                          Navigator.pop(context);
                          Navigator.pop(context, true);
                        },
                      );
                    });
                  },
                  onCancelBtnTap: () {
                    Navigator.pop(context);
                  },
                );
              },
            ) : SpeedDialChild(),
          ]),
    );
  }

  Future<void> dialogEleve(
      BuildContext parentContext, ElevesModel eleve) async {
    setState(() {
      listController[0].text = eleve.nomEleve.toString();
      listController[1].text = eleve.prenomEleve.toString();
      listController[2].text = eleve.matriculeEleve.toString();
      listController[3].text = eleve.phoneParent.toString();
      listController[4].text = eleve.dateNaissance.toString();
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
                                      return " entrer un matricule !! ";
                                    }
                                    return null;
                                  },
                                  maxLines: 1,
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
                                      hintText: "Matricule",
                                      labelText: "Matricule",
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
                                  controller: listController[3],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return " entrer un telephone !! ";
                                    }
                                    return null;
                                  },
                                  maxLines: 1,
                                  keyboardType: TextInputType.phone,
                                  onSaved: (onSavedval) {
                                    listController[3].text = onSavedval!;
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

                                listController[4].text =
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
                                      controller: listController[4],
                                      onSaved: (onSavedval) {
                                        listController[4].text = onSavedval!;
                                      },
                                      validator: (value) {
                                        if (value == null ||
                                            value.isEmpty ||
                                            listController[4].text.isEmpty) {
                                          debugPrint(listController[4].text);
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
                                dialogueNote(
                                    context, "Enregistrement en cours");
                                ElevesModel newEleve = ElevesModel(
                                  idEleve: eleve.idEleve,
                                  nomEleve: listController[0].text.toString(),
                                  prenomEleve:
                                      listController[1].text.toString(),
                                  matriculeEleve:
                                      listController[2].text.toString(),
                                  phoneParent:
                                      listController[3].text.toString(),
                                  dateNaissance:
                                      listController[4].text.toString(),
                                );

                                bool b = await Eleve().editEleve(newEleve);
                                if (b) {
                                  // ElevesModel el = (await Eleve().oneEleve(
                                  //     id1: int.parse(eleve.idEleve ?? "0")))!;

                                  setState(() {
                                    element = newEleve;
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
                                      " Erreur au niveau de la modification, verifiez le Matricule !!");
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
