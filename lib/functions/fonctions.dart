import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/eleve_model.dart';
import 'colors.dart';
import 'custom_text.dart';
import 'slidepage.dart';

Widget cardOption1(
    String option, IconData icon, Widget x, BuildContext context) {
  return Column(
    children: [
      Container(
        height: 13.0,
      ),
      InkWell(
        splashColor: Colors.black87.withOpacity(0.5),
        onTap: () {
          // Timer(const Duration(milliseconds: 400), () {
          //   Navigator.of(context).push(
          //     SlideRightRoute(child: x, page: x, direction: AxisDirection.left),
          //   );
          // });
        },
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            children: [
              Card(
                margin: const EdgeInsets.only(left: 15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SizedBox(
                    width: 40.0,
                    height: 40.0,
                    child: Icon(
                      icon,
                      color: gris(),
                      size: 25.0,
                    )),
              ),
              const SizedBox(
                width: 5.0,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.612,
                child: Row(
                  children: [
                    Flexible(
                      child: CustomText(
                        option,
                        tex: TailleText(context).soustitre,
                        color: gris(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.chevron_right,
                      color: gris(),
                    ),
                  )),
            ],
          ),
        ]),
      ),
      Container(
        height: 13.0,
      ),
      const Divider(
        thickness: 1.0,
        height: 1.0,
        endIndent: 10,
        indent: 10,
      ),
    ],
  );
}

PreferredSizeWidget menuAppBar(
    List<ElevesModel> selectList, BuildContext context) {
  return AppBar(
    leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const Icon(Icons.arrow_back)),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(" ${selectList.length}"),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.note_add)),
            Container(
              width: 10,
            ),
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.notifications_active)),
            Container(
              width: 10,
            ),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.reply_all,
                )),
            Container(
              width: 10,
            ),
          ],
        ),
      ],
    ),
  );
}

/* drop dow menu pour le select */
DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
    value: item,
    child: CustomText(
      item,
      color: Colors.black87,
      textAlign: TextAlign.center,
    ));

Widget cardOption(String option, Widget x, BuildContext context ,IconData icon) {
  return Column(
    children: [
      Container(
        height: 13.0,
      ),
      InkWell(
        onTap: () {
          Timer(const Duration(milliseconds: 400), () {
            Navigator.of(context).push(
              SlideRightRoute(child: x, page: x, direction: AxisDirection.left),
            );
          });
        },
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            children: [
              Card(
                margin: const EdgeInsets.only(left: 15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SizedBox(
                    width: 40.0,
                    height: 40.0,
                    child: Icon(icon)),
              ),
              const SizedBox(
                width: 10.0,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.612,
                child: Row(
                  children: [
                    Flexible(
                      child: CustomText(
                        option,
                        tex: TailleText(context).soustitre,
                        color: gris(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.chevron_right,
                      color: gris(),
                    ),
                  )),
            ],
          ),
        ]),
      ),
      Container(
        height: 13.0,
      ),
      const Divider(
        thickness: 1.0,
        height: 1.0,
        endIndent: 10,
        indent: 10,
      ),
    ],
  );
}

cardMenu(String option, Widget x, BuildContext context) {
  return SizedBox(
    width: MediaQuery.of(context).size.width * 0.47,
    child: InkWell(
      onTap: () {
        Navigator.of(context).push(
          SlideRightRoute(child: x, page: x, direction: AxisDirection.left),
        );
      },
      child: Card(
        elevation: 10.0,
        margin: const EdgeInsets.all(15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13.0),
          side: const BorderSide(
            color: Colors.white,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Column(
            children: [
              Image.asset(
                "assets/images/classroom.png",
                width: 80,
                height: 80,
              ),
              Container(
                height: 15,
              ),
              Text(
                option,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: noir(),
                    fontSize: 18 * TailleText(context).contenu,
                    fontWeight: FontWeight.w800),
              )
            ],
          ),
        ),
      ),
    ),
  );
}

Widget pageLoading(BuildContext context) {
  return Center(
      child: Container(
    width: MediaQuery.of(context).size.width,
    margin: const EdgeInsets.all(8),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          color: teal(),
        ),
        Container(
          height: 15.0,
        ),
        CustomText("Chargement des données",
            textAlign: TextAlign.center,
            color: teal(),
            tex: TailleText(context).contenu),
      ],
    ),
  ));
}

String formatDate(DateTime dateX) {
  String date1 = (DateFormat('y/MM/d').format(dateX)).toString();
  debugPrint(date1);

  if (date1[date1.length - 2] == "/") {
    String date =
        "${date1.substring(0, date1.length - 2)}/0${date1.substring(date1.length - 1)}";
    date1 = date;
  }

  debugPrint(date1);
  return date1;
}


// nettoie les contrlleurs
void clearControler(List<TextEditingController> listController) {
  for (var i = 0; i < listController.length; i++) {
    listController[i].text = "";
  }
}

// validation du  formulaire
bool validateAndSave(GlobalKey<FormState> formKey) {
  final form = formKey.currentState;

  if (form!.validate()) {
    form.save();
    return true;
  } else {
    return false;
  }
}


checkLien() async {
  SharedPreferences saveLienHttp = await SharedPreferences.getInstance();
  String chaine = (saveLienHttp.getString('lienHttp') ?? "");

  return chaine;
}

 convert(String chaine) {
    return (chaine.length > 1) ? chaine.toString() : " 0$chaine";
  }



