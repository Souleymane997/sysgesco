// ignore_for_file: file_names

import 'dart:async';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_advanced/sms_advanced.dart';

import '../../../controllers/note_controller.dart';
import '../../../functions/colors.dart';
import '../../../functions/custom_text.dart';
import '../../../models/config_sms_Model.dart';
import '../../../models/eleve_model.dart';
import '../../../models/note_model.dart';
import '../../../services/database.dart';

class SendNotePage extends StatefulWidget {
  const SendNotePage(
      {super.key,
      required this.eleve,
      required this.matiere,
      required this.classe});

  final ElevesModel eleve;
  final String matiere;
  final String classe;

  @override
  State<SendNotePage> createState() => _SendNotePageState();
}

class _SendNotePageState extends State<SendNotePage> {
  SmsSender sender = SmsSender();
  late ElevesModel eleves;
  List<NoteModel> feed1 = [];
  String textMessage = "";
  bool charge = false;
  bool btn = false;
  int id = 0;

  int classeID = 0;
  int anneeID = 0;
  int noteID = 0;
  int matiereID = 0;
  int trimestreID = 0;
  late SharedPreferences? saveClasseID;
  late SharedPreferences? saveLastAnneeID;
  late SharedPreferences? saveMatiereID;
  late SharedPreferences? saveTrimestreID;
  late SharedPreferences? saveNoteID;

  List<SmsModel> feedConfig = [];
  SmsModel verType = SmsModel(idconfig: 5, poste: "", lycee: "");

  void checkID() async {
    saveClasseID = await SharedPreferences.getInstance();
    saveLastAnneeID = await SharedPreferences.getInstance();
    saveMatiereID = await SharedPreferences.getInstance();
    saveTrimestreID = await SharedPreferences.getInstance();
    saveNoteID = await SharedPreferences.getInstance();

    matiereID = (saveMatiereID!.getInt('matiereID') ?? 0);
    noteID = (saveNoteID!.getInt('noteID') ?? 0);
    trimestreID = (saveMatiereID!.getInt('trimestreID') ?? 0);
    anneeID = (saveLastAnneeID!.getInt('lastAnneeID') ?? 0);
    classeID = (saveClasseID!.getInt('classeID') ?? 0);

    Timer(const Duration(milliseconds: 200), () {
      loadNote(id);
    });
  }

  loadNote(int id) async {
    feed1 = await Notes()
        .listNoteEleve(id, trimestreID, matiereID, anneeID, classeID);

    Timer(const Duration(milliseconds: 1000), () {
      setState(() {
        charge = true;
      });
    });

    Timer(const Duration(milliseconds: 1000), () {
      setState(() {
        btn = true;
      });
    });
  }

  loadConfig() async {
    List<SmsModel> result = await AppDatabase.instance.listConfig();
    setState(() {
      feedConfig = result;
      verType = feedConfig.first;
      debugPrint("Long : ${feedConfig.length}");
    });

    Timer(const Duration(milliseconds: 1000), () {
      setState(() {
        textMessage = '''** ${verType.lycee} **\n''';
      });
    });
  }

  @override
  void initState() {
    loadConfig();
    eleves = widget.eleve;
    setState(() {
      id = int.parse(eleves.idEleve ?? "0");
    });

    debugPrint("id.... $id");
    checkID();

    debugPrint(textMessage);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Envoi de Note "),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(children: [
            Container(
              color: Colors.grey.shade400,
              child: Column(children: [
                Container(
                  height: 15,
                ),
                CustomText(
                  " ${eleves.nomEleve.toString().toUpperCase()}  ${eleves.prenomEleve.toString().toUpperCase()} ",
                  tex: 1.25,
                  color: blanc(),
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
                  height: 10,
                ),
              ]),
            ),
            Container(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  " Classe : ",
                  color: noir(),
                  tex: 1.1,
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.center,
                ),
                CustomText(
                  widget.classe,
                  color: amberFone(),
                  tex: 1.1,
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.center,
                )
              ],
            ),
            Container(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  " Matière : ",
                  color: noir(),
                  tex: 1.1,
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.center,
                ),
                CustomText(
                  widget.matiere,
                  color: amberFone(),
                  tex: 1.1,
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.center,
                )
              ],
            ),
            Container(
              height: 15,
            ),
            (btn)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        " Note : ",
                        color: noir(),
                        tex: 1.1,
                        fontWeight: FontWeight.w700,
                        textAlign: TextAlign.center,
                      ),
                      CustomText(
                        note(),
                        color: amberFone(),
                        tex: 1.1,
                        fontWeight: FontWeight.w700,
                        textAlign: TextAlign.center,
                      )
                    ],
                  )
                : CircularProgressIndicator(
                    color: teal(),
                  ),
            const SizedBox(
              height: 15,
            ),
            Container(
              height: 50,
            ),
            (feed1.length >= noteID && noteID != 0)
                ? ElevatedButton(
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
                    onPressed: () {},
                    child: CustomText("Envoyer",
                        color: Colors.white,
                        tex: TailleText(context).soustitre))
                : CustomText(""),
          ]),
        ),
      ),
    );
  }

  note() {
    return (charge && feed1.length >= noteID)
        ? feed1[noteID - 1].notesEleve
        : " pas de Note ";
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

        String a = note();
        setState(() {
          textMessage =
              '''**L'élève ${eleves.prenomEleve} a eu $a à la note N°$noteID de ${widget.matiere} au trimestre $trimestreID..''';
        });

        //L'élève "${eleves.nomEleve} ${eleves.prenomEleve}" en classe de "${widget.classe}" a eu $a à la ${noteID.toString()} Note de ${widget.matiere} au Trismetre ${trimestreID.toString()}

        SmsMessage message =
            SmsMessage(eleves.phoneParent, textMessage.toString());

        debugPrint(textMessage);

        message.onStateChanged.listen((state) {
          if (state == SmsMessageState.Sent) {
            debugPrint("SMS is sent!");
          } else if (state == SmsMessageState.Delivered) {
            debugPrint("SMS is delivered!");
          }
        });

        sender.sendSms(message);

        //sender.sendSms(message);
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
      },
      onCancelBtnTap: () {
        Navigator.pop(context);
      },
    );
  }
}
