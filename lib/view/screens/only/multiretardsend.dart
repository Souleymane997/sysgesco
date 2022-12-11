// ignore_for_file: file_names, avoid_print, non_constant_identifier_names

import 'dart:async';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:sms_advanced/sms_advanced.dart';

import '../../../functions/colors.dart';
import '../../../functions/custom_text.dart';
import '../../../functions/fonctions.dart';
import '../../../models/config_sms_Model.dart';
import '../../../models/eleve_model.dart';
import '../../../services/database.dart';

class SendRetardList extends StatefulWidget {
  const SendRetardList({super.key, required this.eleve, required this.classe});

  final List<ElevesModel> eleve;
  final String classe;

  @override
  State<SendRetardList> createState() => _SendRetardListState();
}

class _SendRetardListState extends State<SendRetardList> {
  List<ElevesModel> ListEleves = [];
  bool choix = false;
  DateTime date = DateTime.now();
  String date1 = "";
  List<SmsModel> feedConfig = [];
  SmsSender sender = SmsSender();
  SmsModel verType = SmsModel(idconfig: 5, poste: "", lycee: "");

  String absenceModel = "";
  String retardModel = "";

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
    date1 = formatDate(date);
    ListEleves = widget.eleve;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Retard ou Absences"),
      ),
      body: SafeArea(
        child: Column(children: [
          Container(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                  child: CustomText(
                "Choississez le motif d'Envoi de SMS \n aux Parents de L'élève",
                color: noir(),
                tex: 1.1,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.center,
              ))
            ],
          ),
          Container(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.only(
                left: 25.0, right: 25.0, top: 8, bottom: 8),
            color: grisee(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomText("Retard",
                    color: tealFonce(),
                    tex: 1.2,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w600),
                Expanded(
                  child: Switch(
                    inactiveTrackColor: teal(),
                    inactiveThumbColor: tealFonce(),
                    activeColor: Colors.red,
                    activeTrackColor: Colors.red.withOpacity(0.5),
                    onChanged: (bool value) {
                      setState(() {
                        choix = value;
                      });
                    },
                    value: choix,
                  ),
                ),
                CustomText(
                  "Absence",
                  color: Colors.red,
                  tex: 1.2,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
          Container(
            height: 20,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: (!choix) ? teal() : Colors.red,
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
                  color: Colors.white, tex: TailleText(context).soustitre)),
          Container(
            height: 30,
          ),
          Expanded(
            child: listNomEleves(),
          ),
        ]),
      ),
    );
  }

  listNomEleves() {
    return ListView.builder(
        itemCount: ListEleves.length,
        itemBuilder: (context, index) {
          ElevesModel elem = ListEleves[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
            child: Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: amberFone(), //<-- SEE HERE
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 0.0,
              child: ListTile(
                onTap: () {},
                title: CustomText(
                  " ${elem.nomEleve}  ${elem.prenomEleve} ",
                  tex: 1.1,
                  color: teal(),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        });
  }

  confirm() {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.confirm,
      title: "ENVOI DE MESSAGE",
      text: "Etes vous sur de vouloir envoyer ces messages?",
      loopAnimation: true,
      confirmBtnText: 'OUI',
      cancelBtnText: 'NON',
      barrierDismissible: false,
      confirmBtnColor: bleu(),
      backgroundColor: bleu(),
      onConfirmBtnTap: () async {
        Navigator.pop(context);
        for (var i = 0; i < ListEleves.length; i++) {
          setState(() {
            absenceModel =
                '''** ${verType.lycee} **\n\nL'élève "${ListEleves[i].nomEleve} ${ListEleves[i].prenomEleve}" en classe de  "${widget.classe}" est absent ce jour $date1''';

            retardModel =
                '''** ${verType.lycee} **\n\nL'élève "${ListEleves[i].nomEleve} ${ListEleves[i].prenomEleve}" en classe de  "${widget.classe}" est en retard aux cours $date1 ''';
          });
          SmsMessage message = SmsMessage(
              ListEleves[i].phoneParent, (!choix) ? retardModel : absenceModel);

          message.onStateChanged.listen((state) {
            if (state == SmsMessageState.Sent) {
              debugPrint("SMS is sent!");
            } else if (state == SmsMessageState.Delivered) {
              debugPrint("SMS is delivered!");
            }
          });
          sender.sendSms(message);
        }

        Timer(const Duration(milliseconds: 500), () {
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
}
