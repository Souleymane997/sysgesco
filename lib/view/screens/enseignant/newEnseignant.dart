// ignore_for_file: use_build_context_synchronously, file_names

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:sysgesco/controllers/ens_controller.dart';
import 'package:sysgesco/models/enseignant_model.dart';
import '../../../functions/colors.dart';
import '../../../functions/custom_text.dart';
import '../../../functions/dialoguetoast.dart';
import '../../../functions/fonctions.dart';
import '../../../models/classe_model.dart';

class NewEnseignantPages extends StatefulWidget {
  const NewEnseignantPages({super.key});

  @override
  State<NewEnseignantPages> createState() => _NewEnseignantPagesState();
}

class _NewEnseignantPagesState extends State<NewEnseignantPages> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nomController = TextEditingController();
  TextEditingController prenomController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController numeroController = TextEditingController();

  DateTime date = DateTime(2022, 12, 24);

  List<ClasseModel> feedClasse = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(" Nouvel Enseignant "),
      ),
      body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Center(
              child: Column(
            children: [
              Container(
                height: 15,
              ),
              CustomText(
                " ENREGISTREMENT ",
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
                height: 50,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 15, right: 15),
                      width: MediaQuery.of(context).size.width * 0.75,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: TextFormField(
                          maxLines: 1,
                          controller: nomController,
                          onSaved: (onSavedval) {
                            nomController.text = onSavedval!;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return " entrer un Nom svp !! ";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: "Nom ",
                            hintText: "Nom ",
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
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 15, right: 15),
                      width: MediaQuery.of(context).size.width * 0.75,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: TextFormField(
                          maxLines: 1,
                          controller: prenomController,
                          onSaved: (onSavedval) {
                            prenomController.text = onSavedval!;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return " entrer un Prenom svp !! ";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: "Prenom ",
                            hintText: "Prenom ",
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
                    const SizedBox(
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

                            dateController.text =
                                " ${date.day} / ${date.month} / ${date.year} ";
                          });
                        }
                      },
                      child: Column(
                        children: [
                          Container(
                            margin:
                                const EdgeInsets.only(left: 15, right: 15),
                            width: MediaQuery.of(context).size.width * 0.75,
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
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 15, right: 15),
                      width: MediaQuery.of(context).size.width * 0.75,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: TextFormField(
                          maxLines: 1,
                          keyboardType: TextInputType.phone,
                          controller: numeroController,
                          onSaved: (onSavedval) {
                            numeroController.text = onSavedval!;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return " entrer un Numero svp !! ";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: "Numero de Telephone",
                            hintText: "Numero de Telephone",
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
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
              Container(
                height: 5,
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
                  onPressed: () async {
                    if (validateAndSave()) {
                      String date1 = formatDate(date);

                      EnseignantModel newEns = EnseignantModel(
                          nomEns: nomController.text.toString(),
                          prenomEns: prenomController.text.toString(),
                          dateNaissance: date1,
                          phone: numeroController.text.toString());

                      bool insert = await Enseignant().insertEleve(newEns);

                      if (insert) {
                        CoolAlert.show(
                          context: context,
                          type: CoolAlertType.success,
                          text: "Enregistrement Effectué avec Success",
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
                        // DInfo.snackBarSuccess(
                        //     "Enregistrement effecué Avec Success", context);
                      } else {
                        DInfo.snackBarError(
                            "Erreur Au Niveau de L'enregistrement !! ",
                            context);
                      }
                    } else {
                      CoolAlert.show(
                        context: context,
                        type: CoolAlertType.error,
                        title: "Erreur !!",
                        text: "Verifier les champs svp ",
                        confirmBtnText: 'OK',
                        confirmBtnColor: Colors.red,
                        backgroundColor: Colors.red.withOpacity(0.4),
                        loopAnimation: true,
                        barrierDismissible: false,
                        onConfirmBtnTap: () {
                          Navigator.pop(context);
                        },
                      );
                    }
                  },
                  child: CustomText("enregistrer",
                      color: Colors.white,
                      tex: TailleText(context).soustitre)),
            ],
          ))),
    );
  }

  bool validateAndSave() {
    final form = _formKey.currentState;

    if (form!.validate() && dateController.text.isNotEmpty) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

 
}
