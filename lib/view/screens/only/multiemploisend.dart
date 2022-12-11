// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:async';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_advanced/sms_advanced.dart';

import '../../../controllers/matiere_controller.dart';
import '../../../controllers/seance_controller.dart';
import '../../../functions/colors.dart';
import '../../../functions/custom_text.dart';
import '../../../functions/fonctions.dart';
import '../../../models/eleve_model.dart';
import '../../../models/matiere_model.dart';
import '../../../models/seance_model.dart';

class OnlySendEmploi extends StatefulWidget {
  const OnlySendEmploi({super.key, required this.eleve, required this.classe});
  final List<ElevesModel> eleve;
  final String classe;

  @override
  State<OnlySendEmploi> createState() => _OnlySendEmploiState();
}

class _OnlySendEmploiState extends State<OnlySendEmploi> {
  SmsSender sender = SmsSender();
  List<ElevesModel> listEleves = [];
  List<MatiereModel> feedMatiere = [];

  //* ********************************************************
  String choixClasse = "";
  int classeID = 0;
  int anneeID = 0;
  late SharedPreferences? saveClasseID;
  late SharedPreferences? saveLastAnneeID;

//* ********************************************************
  bool loadPage = false;
//* ********************************************************
//* ********************************************************

  List<SeanceModel> seanceListingLundi = [];
  List<SeanceModel> seanceListingMardi = [];
  List<SeanceModel> seanceListingMercredi = [];
  List<SeanceModel> seanceListingJeudi = [];
  List<SeanceModel> seanceListingVendredi = [];

  String textMessageEmp1 = "LUNDI \n";
  String textMessageEmp2 = "MARDI \n";
  String textMessageEmp3 = "MERCREDI \n";
  String textMessageEmp4 = "JEUDI \n";
  String textMessageEmp5 = "VENDREDI \n";

  charge(List<SeanceModel> list, String text) {
    if (list.isNotEmpty) {
      for (var i = 0; i < list.length; i++) {
        setState(() {
          text =
              "${"$text${list[i].heureDebut} à ${list[i].heureFin} ==> " + searchNombyID(list[i].idMatieres.toString())}\n";
        });
      }
    } else {
      setState(() {
        text = "${text}pas de Programme";
      });
    }

    debugPrint(text);

    return text;
  }

  searchNombyID(String j) {
    for (var i = 0; i < feedMatiere.length; i++) {
      if (j == feedMatiere[i].idMatieres.toString()) {
        return feedMatiere[i].libelleMatieres.toString();
      }
    }
    return "defaut";
  }

  void checkID() async {
    saveClasseID = await SharedPreferences.getInstance();
    saveLastAnneeID = await SharedPreferences.getInstance();
    setState(() {
      classeID = (saveClasseID!.getInt('classeID') ?? 0);
      anneeID = (saveLastAnneeID!.getInt('lastAnneeID') ?? 0);
    });
    debugPrint("idClasse : $classeID  idAnnee : $anneeID");

    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        loadPage = true;
        loadSeance();
      });
    });
  }

  loadSeance() async {
    List<SeanceModel> result1 = await Seance().listSeance(1, classeID, anneeID);
    setState(() {
      debugPrint("eeee");
      seanceListingLundi = result1;
      debugPrint(seanceListingLundi.length.toString());
      Timer(const Duration(milliseconds: 1000), () {
        textMessageEmp1 = charge(seanceListingLundi, textMessageEmp1);
      });
    });

    List<SeanceModel> result2 = await Seance().listSeance(2, classeID, anneeID);
    setState(() {
      seanceListingMardi = result2;
      debugPrint(seanceListingMardi.length.toString());
      Timer(const Duration(milliseconds: 1000), () {
        textMessageEmp2 = charge(seanceListingMardi, textMessageEmp2);
      });
    });

    List<SeanceModel> result3 = await Seance().listSeance(3, classeID, anneeID);
    setState(() {
      seanceListingMercredi = result3;
      debugPrint(seanceListingMercredi.length.toString());
      Timer(const Duration(milliseconds: 1000), () {
        textMessageEmp3 = charge(seanceListingMercredi, textMessageEmp3);
      });
    });

    List<SeanceModel> result4 = await Seance().listSeance(4, classeID, anneeID);
    setState(() {
      seanceListingJeudi = result4;
      debugPrint(seanceListingJeudi.length.toString());
      Timer(const Duration(milliseconds: 1000), () {
        textMessageEmp4 = charge(seanceListingJeudi, textMessageEmp4);
      });
    });

    List<SeanceModel> result5 = await Seance().listSeance(5, classeID, anneeID);
    setState(() {
      seanceListingVendredi = result5;
      debugPrint(seanceListingVendredi.length.toString());
      Timer(const Duration(milliseconds: 1000), () {
        textMessageEmp5 = charge(seanceListingVendredi, textMessageEmp5);
      });
    });
  }

//* load Classe
  loadClasse() async {
    List<MatiereModel> res = await Matiere().listMatiere();
    setState(() {
      feedMatiere = res;
    });
  }
//* ********************************************************

  @override
  void initState() {
    listEleves = widget.eleve;
    choixClasse = widget.classe;
    loadClasse();
    checkID();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Envoi d 'Emploi du Temps "),
      ),
      body: SafeArea(
        child: (loadPage)
            ? Column(children: [
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
                  height: 25,
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
                      confirm();
                    },
                    child: CustomText("Envoyer",
                        color: Colors.white,
                        tex: TailleText(context).soustitre)),
                Container(
                  height: 30,
                ),
                Expanded(
                  child: listNomEleves(),
                ),
              ])
            : pageLoading(context),
      ),
    );
  }

  Future<void> dialogueNote() async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogcontext) => StatefulBuilder(
            builder: (stfContext, stfsetState) => SimpleDialog(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  contentPadding: const EdgeInsets.only(top: 2.0),
                  backgroundColor: Colors.white,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: CircularProgressIndicator(
                        color: teal(),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomText(
                      "Patientez svp ... envoi en cours ",
                      color: teal(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                )));
  }

  listNomEleves() {
    return ListView.builder(
        itemCount: listEleves.length,
        itemBuilder: (context, index) {
          ElevesModel elem = listEleves[index];
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

  envoiEmploi() async {
    for (var i = 0; i < listEleves.length; i++) {
      //sender.sendSms(SmsMessage(listEleves[i].phoneParent, message));
      SmsMessage message1 =
          SmsMessage(listEleves[i].phoneParent, textMessageEmp1);
      sender.sendSms(message1);

      SmsMessage message2 =
          SmsMessage(listEleves[i].phoneParent, textMessageEmp2);
      sender.sendSms(message2);

      SmsMessage message3 =
          SmsMessage(listEleves[i].phoneParent, textMessageEmp3);
      sender.sendSms(message3);

      SmsMessage message4 =
          SmsMessage(listEleves[i].phoneParent, textMessageEmp4);
      sender.sendSms(message4);

      SmsMessage message5 =
          SmsMessage(listEleves[i].phoneParent, textMessageEmp5);
      sender.sendSms(message5);
    }
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
        dialogueNote();
        Timer(const Duration(milliseconds: 2000), () {
          envoiEmploi();
        });

        //sender.sendSms(message);
        Timer(const Duration(milliseconds: 2000), () {
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
