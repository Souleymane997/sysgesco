// ignore_for_file: file_names, avoid_print

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:sms_advanced/sms_advanced.dart';

import '../../../functions/colors.dart';
import '../../../functions/custom_text.dart';
import '../../../functions/fonctions.dart';
import '../../../models/eleve_model.dart';

class SendRetard extends StatefulWidget {
  const SendRetard({super.key, required this.eleve, required this.classe});

  final ElevesModel eleve;
  final String classe;

  @override
  State<SendRetard> createState() => _SendRetardState();
}

class _SendRetardState extends State<SendRetard> {
  late ElevesModel eleves;
  bool choix = false;
  DateTime date = DateTime.now();
  String date1 = "";

  SmsSender sender = SmsSender();

  String absenceModel = "";
  String retardModel = "";

  @override
  void initState() {
    date1 = formatDate(date);
    eleves = widget.eleve;
    absenceModel =
        '''** Lycée Privé Wend Yam **\n\nL'élève "${eleves.nomEleve} ${eleves.prenomEleve}" en classe de  "${widget.classe}" est absent ce jour $date1''';

    retardModel =
        '''** Lycée Privé Wend Yam **\n\nL'élève "${eleves.nomEleve} ${eleves.prenomEleve}" en classe de  "${widget.classe}" est en retard aux cours $date1 ''';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Retard ou Absences"),
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
                  " ${eleves.nomEleve}  ${eleves.prenomEleve} ",
                  tex: 1.25,
                  color: grisee(),
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
              height: 50,
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
                onPressed: () {
                  SmsMessage message = SmsMessage(eleves.phoneParent,
                      (!choix) ? retardModel : absenceModel);

                  message.onStateChanged.listen((state) {
                    if (state == SmsMessageState.Sent) {
                      debugPrint("SMS is sent!");
                    } else if (state == SmsMessageState.Delivered) {
                      debugPrint("SMS is delivered!");
                    }
                  });
                  sender.sendSms(message);
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
                child: CustomText("Envoyer",
                    color: Colors.white, tex: TailleText(context).soustitre)),
          ]),
        ),
      ),
    );
  }
}
