// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:sms_advanced/sms_advanced.dart';

import '../../../functions/colors.dart';
import '../../../functions/custom_text.dart';
import '../../../functions/fonctions.dart';
import '../../../models/config_sms_Model.dart';
import '../../../models/eleve_model.dart';
import '../../../services/database.dart';

class SendConvocationList extends StatefulWidget {
  const SendConvocationList(
      {super.key, required this.eleve, required this.classe});

  final List<ElevesModel> eleve;
  final String classe;

  @override
  State<SendConvocationList> createState() => _SendConvocationListState();
}

class _SendConvocationListState extends State<SendConvocationList> {
  late List<ElevesModel> eleves;
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  List<SmsModel> feedConfig = [];
  SmsModel verType = SmsModel(idconfig: 5, poste: "", lycee: "");

  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime date = DateTime.now();

  String date1 = "";
  String heure1 = "";
  String convocationModel = "";

  SmsSender sender = SmsSender();

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
    initializeDateFormatting();
    date1 = formatDate(date);
    heure1 = " ${selectedTime.hour} h ${selectedTime.minute} ";
    eleves = widget.eleve;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Convocations"),
      ),
      body: SafeArea(
        child: Column(children: [
          Container(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                  child: Column(
                children: [
                  CustomText(
                    "Date",
                    color: noir(),
                    tex: 1.1,
                    fontWeight: FontWeight.w700,
                    textAlign: TextAlign.center,
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
                          String day = convert(date.day.toString());
                          String month = convert(date.month.toString());
                          String year = convert(date.year.toString());

                          dateController.text = " $day / $month / $year ";
                          //date1 = dateController.text;
                          date1 = DateFormat.yMMMMEEEEd('fr')
                              .format(date)
                              .toString();
                        });
                      }
                    },
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 15, right: 15),
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
                                  return " entrer une date de rencontre svp !! ";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                labelText: "Date de la rencontre",
                                hintText: "Date de la rencontre",
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
                ],
              )),
              Expanded(
                  child: Column(
                children: [
                  CustomText(
                    "Heure",
                    color: noir(),
                    tex: 1.1,
                    fontWeight: FontWeight.w700,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () async {
                      TimeOfDay? timeOfDay = await showTimePicker(
                          context: context,
                          initialTime: selectedTime,
                          initialEntryMode: TimePickerEntryMode.dial,
                          cancelText: "retour",
                          confirmText: "valider");

                      if (timeOfDay != null) {
                        debugPrint(timeOfDay.toString());
                        setState(() {
                          selectedTime = timeOfDay;
                          String minute =
                              convert(selectedTime.minute.toString());
                          String heure = convert(selectedTime.hour.toString());
                          timeController.text = " $heure" "H $minute ";
                          heure1 = timeController.text;
                        });
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 15, right: 15),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: TextFormField(
                          maxLines: 1,
                          enabled: false,
                          controller: timeController,
                          onSaved: (onSavedval) {
                            timeController.text = onSavedval!;
                          },
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                timeController.text.isEmpty) {
                              debugPrint(timeController.text);
                              return " entrer une heure svp !! ";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: "Heure de la Rencontre",
                            hintText: "Heure de la Rencontre",
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
                  ),
                ],
              ))
            ],
          ),
          Container(
            height: 50,
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
        itemCount: eleves.length,
        itemBuilder: (context, index) {
          ElevesModel elem = eleves[index];
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

        for (var i = 0; i < eleves.length; i++) {
          setState(() {
            convocationModel =
                "${verType.poste} du ${verType.lycee} convie les Parents de l'élève ${eleves[i].nomEleve} ${eleves[i].prenomEleve} a une importante rencontre le $date1 à $heure1 ";
          });

          SmsMessage message =
              SmsMessage(eleves[i].phoneParent, convocationModel);
          debugPrint(convocationModel);

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
