import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:sysgesco/functions/colors.dart';
import 'package:sysgesco/functions/custom_text.dart';
import 'package:sysgesco/services/database.dart';

import '../../../models/config_sms_Model.dart';

class ConfigSmsPage extends StatefulWidget {
  const ConfigSmsPage({super.key});

  @override
  State<ConfigSmsPage> createState() => _ConfigSmsPageState();
}

class _ConfigSmsPageState extends State<ConfigSmsPage> {
  TextEditingController editController = TextEditingController();

  List<SmsModel> feedConfig = [];
  SmsModel verType = SmsModel(idconfig: 5, poste: "", lycee: "");

  loadConfig() async {
    List<SmsModel> result = await AppDatabase.instance.listConfig();
    setState(() {
      feedConfig = result;
      verType = feedConfig.first;
      debugPrint("Long : ${feedConfig.length}");
    });
  }

  @override
  void initState() {
    loadConfig();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configuration de Message"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              height: 15.0,
            ),
            CustomText(
              "Configuration des Messages",
              color: tealFonce(),
              tex: 1.2,
              textAlign: TextAlign.center,
            ),
            Container(
              height: 30.0,
            ),
            InkWell(
              onTap: () {
                modifyConfig(context, verType.poste, 1);
              },
              child: Column(
                children: [
                  CustomText(
                    "Poste ou Titre",
                    color: amberFone(),
                  ),
                  Container(
                    height: 8,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15, right: 15),
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: 40,
                    decoration: BoxDecoration(
                        color: tealFonce(),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(child: CustomText(verType.poste)),
                  ),
                ],
              ),
            ),
            Container(
              height: 30.0,
            ),
            InkWell(
              onTap: () {
                modifyConfig(context, verType.lycee, 2);
              },
              child: Column(
                children: [
                  CustomText(
                    "Nom du Lycée",
                    color: amberFone(),
                  ),
                  Container(
                    height: 8,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15, right: 15),
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: 40,
                    decoration: BoxDecoration(
                        color: tealFonce(),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(child: CustomText(verType.lycee)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /* boite de Dialogue de Classe  */
  Future<void> modifyConfig(
      BuildContext parentContext, String elem, int num) async {
    String lab = elem;
    bool mod = (lab.isNotEmpty) ? true : false;
    return await showDialog(
        context: parentContext,
        barrierDismissible: true,
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
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                          tex: TailleText(context).titre,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextFormField(
                          cursorColor: Colors.teal,
                          onChanged: (value) {},
                          controller: editController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return " remplir le champ svp !! ";
                            }
                            return null;
                          },
                          maxLines: 2,
                          onSaved: (onSavedval) {
                            editController.text = onSavedval!;
                          },
                          style: const TextStyle(color: Colors.teal),
                          decoration: InputDecoration(
                              focusedBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.teal, width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              labelText: (mod) ? lab : "entrer une valeur",
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)))),
                        ),
                      ),
                    ),
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
                              if (editController.text.isNotEmpty) {
                                SmsModel newType = (num == 1)
                                    ? SmsModel(
                                        idconfig: verType.idconfig,
                                        poste: editController.text.toString(),
                                        lycee: verType.lycee.toString(),
                                      )
                                    : SmsModel(
                                        idconfig: verType.idconfig,
                                        poste: verType.poste.toString(),
                                        lycee: editController.text.toString(),
                                      );

                                debugPrint(newType.idconfig.toString());
                                debugPrint(newType.poste);
                                debugPrint(newType.lycee);

                                AppDatabase.instance.updateConfig(newType);
                                loadConfig();

                                editController.clear();

                                CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.success,
                                  text: "Modification Effectué avec Success",
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
                              } else {
                                CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.error,
                                  title: "Erreur !!",
                                  text: "Verifier le champ  ",
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
