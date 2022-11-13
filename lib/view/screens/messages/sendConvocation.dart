// ignore_for_file: file_names

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

class SendConvocation extends StatefulWidget {
  const SendConvocation({super.key, required this.eleve, required this.classe});

  final ElevesModel eleve;
  final String classe;

  @override
  State<SendConvocation> createState() => _SendConvocationState();
}

class _SendConvocationState extends State<SendConvocation> {
  late ElevesModel eleves;
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
    convocationModel =
        " Le ${verType.poste} du ${verType.lycee} convie les Parents de l'élève ${eleves.nomEleve} ${eleves.prenomEleve} a une importante rencontre le $date1 à $heure1 ";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Convocations"),
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
              children: [
                Expanded(
                    child: CustomText(
                  " Choississez la date de La Rencontre ",
                  color: noir(),
                  tex: 1.1,
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.center,
                ))
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
                    String day = convert(date.day.toString());
                    String month = convert(date.month.toString());
                    String year = convert(date.year.toString());

                    dateController.text = " $day / $month / $year ";
                    //date1 = dateController.text;
                    date1 = DateFormat.yMMMMEEEEd('fr').format(date).toString();
                  });
                }
              },
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 15, right: 15),
                    width: MediaQuery.of(context).size.width * 0.9,
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
            const SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Expanded(
                    child: CustomText(
                  " Choississez l'heure de La Rencontre ",
                  color: noir(),
                  tex: 1.1,
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.center,
                ))
              ],
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
                    String minute = convert(selectedTime.minute.toString());
                    String heure = convert(selectedTime.hour.toString());
                    timeController.text = " $heure : $minute ";
                    heure1 = timeController.text;
                  });
                }
              },
              child: Container(
                margin: const EdgeInsets.only(left: 15, right: 15),
                width: MediaQuery.of(context).size.width * 0.9,
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
                          borderSide: BorderSide(color: Colors.teal, width: 1),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal, width: 0),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                    ),
                  ),
                ),
              ),
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
                  setState(() {
                    convocationModel =
                        " Le ${verType.poste} du ${verType.lycee} convie les Parents de l'élève ${eleves.nomEleve} ${eleves.prenomEleve} a une importante rencontre le $date1 à , $heure1 ";
                  });

                  SmsMessage message =
                      SmsMessage(eleves.phoneParent, convocationModel);
                  debugPrint(convocationModel);

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
