// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../../../functions/custom_text.dart';
import '../../../functions/slidepage.dart';
import '../../menu/apropos.dart';
import '../../menu/compte.dart';
import '../../menu/parametre.dart';
import 'login.dart';


class NavDrawer extends StatefulWidget {
  const NavDrawer({Key? key, required this.choix}) : super(key: key);
  final int choix;

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  @override
  void initState() {
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
          (widget.choix == 1)
              ? ListTile(
                  title: const Text("Mon Compte"),
                  leading: const Icon(Icons.account_circle),
                  onTap: () {
                    Navigator.of(context).push(
                      SlideRightRoute(
                          child: const ComptePage(),
                          page: const ComptePage(),
                          direction: AxisDirection.right),
                    );
                  },
                )
              : const SizedBox(
                  height: 0.0,
                  width: 0.0,
                ),
          (widget.choix == 1)
              ? const Divider(
                  color: Colors.teal,
                )
              : const SizedBox(
                  height: 0.0,
                  width: 0.0,
                ),
          (widget.choix == 1)
              ? ListTile(
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
                )
              : const SizedBox(
                  height: 0.0,
                  width: 0.0,
                ),
          (widget.choix == 1)
              ? const Divider(
                  color: Colors.teal,
                )
              : const SizedBox(
                  height: 0.0,
                  width: 0.0,
                ),
          (widget.choix == 1)
              ? ListTile(
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
                )
              : const SizedBox(
                  height: 0.0,
                  width: 0.0,
                ),
          (widget.choix == 1)
              ? const Divider(
                  color: Colors.teal,
                )
              : const SizedBox(
                  height: 0.0,
                  width: 0.0,
                ),
          (widget.choix == 0)
              ? ListTile(
                  onTap: () {
                    // Navigator.of(context).push(
                    //   SlideRightRoute(
                    //       child: const LoginPage(),
                    //       page: const LoginPage(),
                    //       direction: AxisDirection.right),
                    // );
                  },
                  title: const Text("Se connecter"),
                  leading: const Icon(Icons.login),
                )
              : const SizedBox(
                  height: 0.0,
                  width: 0.0,
                ),
          (widget.choix == 0)
              ? const Divider(
                  color: Colors.teal,
                )
              : const SizedBox(
                  height: 0.0,
                  width: 0.0,
                ),
          (widget.choix == 1)
              ? ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      SlideRightRoute(
                          child: const LoginPage(),
                          page: const LoginPage(),
                          direction: AxisDirection.right),
                    );
                  },
                  title: const Text(
                    "Se deconnecter",
                    style: TextStyle(color: Colors.red),
                  ),
                  leading: const Icon(
                    Icons.login,
                    color: Colors.red,
                  ),
                )
              : const SizedBox(
                  height: 0.0,
                  width: 0.0,
                ),
          (widget.choix == 1)
              ? const Divider(
                  color: Colors.teal,
                )
              : const SizedBox(
                  height: 0.0,
                  width: 0.0,
                ),
        ],
      ),
    );
  }
}
