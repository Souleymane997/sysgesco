// ignore_for_file: file_names

import 'dart:async';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sysgesco/functions/fonctions.dart';
import '../../../functions/custom_text.dart';
import '../../../functions/slidepage.dart';
import '../../menu/apropos.dart';
import '../../menu/compte.dart';
import '../../menu/parametre.dart';
import 'login.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({
    Key? key,
  }) : super(key: key);

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  SharedPreferences? loginData;
  late SharedPreferences? saveDataUser;

  int statut = 0;

  void checkUserLogin() async {
    loginData = await SharedPreferences.getInstance();
    saveDataUser = await SharedPreferences.getInstance();

    setState(() {
      statut = saveDataUser!.getInt("role") ?? -1;
    });
  }

  @override
  void initState() {
    checkUserLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.teal,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/logo.png'),
                          fit: BoxFit.contain,
                        )),
                  ),
                  Container(
                    height: 8,
                  ),
                  CustomText(
                    "SYSGESCO",
                    color: Colors.white,
                    tex: 1.3,
                    textAlign: TextAlign.left,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
            ),
          ),
          (statut == 1 || statut == 0)
              ? ListTile(
                  title: const Text("Gestion de Compte"),
                  leading: const Icon(Icons.account_circle),
                  onTap: () {
                    Navigator.of(context).push(
                      SlideRightRoute(
                          child: const AjoutComptePage(),
                          page: const AjoutComptePage(),
                          direction: AxisDirection.right),
                    );
                  },
                )
              : const SizedBox(
                  height: 0.0,
                  width: 0.0,
                ),
          (statut == 1 || statut == 0)
              ? const Divider(
                  color: Colors.teal,
                )
              : const SizedBox(
                  height: 0.0,
                  width: 0.0,
                ),
          (statut == 1 || statut == 0)? ListTile(
            title: const Text("Paramètres"),
            leading: const Icon(Icons.settings),
            onTap: () {
              Navigator.of(context).push(
                SlideRightRoute(
                    child: const ParametrePage(),
                    page: const ParametrePage(),
                    direction: AxisDirection.right),
              );
            },
          ) : Container(),
          (statut == 1 || statut == 0)? const Divider(
            color: Colors.teal,
          ) : Container(),
          ListTile(
            title: const Text("A propos"),
            leading: const Icon(Icons.info),
            onTap: () {
              Navigator.of(context).push(
                SlideRightRoute(
                    child: const AproposPage(),
                    page: const AproposPage(),
                    direction: AxisDirection.right),
              );
            },
          ),
          const Divider(
            color: Colors.teal,
          ),
          ListTile(
            onTap: () {
              confirm();
            },
            title: const Text(
              "Se deconnecter",
              style: TextStyle(color: Colors.red),
            ),
            leading: const Icon(
              Icons.login,
              color: Colors.red,
            ),
          ),
          const Divider(
            color: Colors.teal,
          ),
        ],
      ),
    );
  }

  confirm() {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.confirm,
      title: "Deconnexion",
      text: "Etes vous sur de vouloir vous deconnecter ?",
      loopAnimation: true,
      confirmBtnText: 'OUI',
      cancelBtnText: 'NON',
      barrierDismissible: false,
      confirmBtnColor: Colors.red,
      backgroundColor: Colors.red ,
      onConfirmBtnTap: () async {
        Navigator.pop(context);
        dialogueNote(context, "deconnexion en cours");

        Timer(const Duration(milliseconds: 1500 ), () {
          loginData!.setBool('login', true);
          Navigator.of(context).push(
            SlideRightRoute(
                child: const LoginPage(),
                page: const LoginPage(),
                direction: AxisDirection.right),
          );
        });
      },
      onCancelBtnTap: () {
        Navigator.pop(context);
      },
    );
  }
}
