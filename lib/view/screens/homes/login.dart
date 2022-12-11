// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sysgesco/controllers/compte_controller.dart';
import 'package:sysgesco/functions/dialoguetoast.dart';
import 'package:sysgesco/functions/fonctions.dart';
import 'package:sysgesco/models/compte_model.dart';
import 'package:sysgesco/models/comptes_models.dart';
import '../../../functions/colors.dart';
import '../../../functions/custom_text.dart';
import '../../../functions/slidepage.dart';
import '../../../services/config.dart';
import '../../../services/database.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late Future<List<CompteModel>> feedCompte;

  bool isHidden = true;
  bool isInAsynCall = false;
  late int choix;

  late SharedPreferences? saveDataUser;
  late SharedPreferences loginData;
  late bool newUser;
  bool exit = true;

  CompteModel actifCompt = CompteModel(username: "", password: "", role: 0);
  ComptesModels actifComptes =
      ComptesModels(username: "", password: "", role: 0);

  int trouve = 0;

  void checkLogin() async {
    saveDataUser = await SharedPreferences.getInstance();
    loginData = await SharedPreferences.getInstance();
    newUser = (loginData.getBool('login') ?? true);

    if (newUser == false) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    }
  }

  @override
  void initState() {
    checkLogin();
    feedCompte = AppDatabase.instance.listCompte();
    super.initState();
  }

  @override
  void dispose() {
    userController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                contentPadding:
                    const EdgeInsets.only(top: 10.0, left: 0.0, right: 0.0),
                title: CustomText(Config.appName,
                    tex: TailleText(context).titre,
                    color: teal(),
                    fontWeight: FontWeight.w800,
                    textAlign: TextAlign.center),
                content: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Divider(
                        thickness: 1.0,
                        height: 2.0,
                        color: grisee(),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 5.0, 5.0, 10.0),
                        child: Row(
                          children: [
                            Flexible(
                              child: CustomText(
                                "Voulez vous quitter l'application ? ",
                                tex: TailleText(context).soustitre,
                                color: noir(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                actions: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 1.0),
                        shadowColor: amberFone(),
                        elevation: 3.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context, false);
                        setState(() {
                          exit = false;
                        });
                      },
                      child: CustomText(
                        "NON",
                        color: teal(),
                        tex: TailleText(context).contenu,
                      )),
                  const SizedBox(width: 7.5),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: teal(),
                        backgroundColor: teal(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 1.0),
                        shadowColor: teal(),
                        elevation: 3.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context, true);
                        SystemNavigator.pop();
                        setState(() {
                          exit = true;
                        });
                      },
                      child: CustomText(
                        "OUI",
                        color: blanc(),
                        tex: TailleText(context).contenu,
                      )),
                  const SizedBox(width: 2.5),
                ],
              );
            });
        return exit;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.teal.shade100,
          body: SafeArea(
            child: SingleChildScrollView(child: loginContainer()),
          ),
        ),
      ),
    );
  }

  Widget loginContainer() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 7.5,
                ),
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
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10, top: 20),
              child: CustomText(
                ' SYSGESCO ',
                tex: TailleText(context).titre * 1.8,
                color: Colors.teal,
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextFormField(
                          cursorColor: Colors.teal,
                          onChanged: (value) {},
                          controller: userController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return " entrer un identifiant !! ";
                            }
                            return null;
                          },
                          maxLines: 1,
                          onSaved: (onSavedval) {
                            userController.text = onSavedval!;
                          },
                          style: const TextStyle(color: Colors.teal),
                          decoration: const InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.teal, width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(70.0))),
                              hintText: "identifiant",
                              prefixIcon: Icon(
                                Icons.account_circle,
                                color: Colors.teal,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(70.0)))),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Container(
                        padding: const EdgeInsets.all(5.0),
                        child: TextFormField(
                          maxLines: 1,
                          controller: passwordController,
                          onSaved: (onSavedval) {
                            passwordController.text = onSavedval!;
                          },
                          obscureText: isHidden,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'entrer votre mot de passe SVP !!';
                            }
                            return null;
                          },
                          style: const TextStyle(color: Colors.teal),
                          decoration: InputDecoration(
                              focusedBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.teal, width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(70.0))),
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Colors.teal,
                              ),
                              hintText: 'Mot de passe',
                              suffixIcon: IconButton(
                                color:
                                    (isHidden) ? Colors.blueGrey : Colors.teal,
                                icon: Icon(isHidden
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    isHidden = !isHidden;
                                  });
                                },
                              ),
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(70.0)))),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 15.0),
                          shadowColor: Colors.blueGrey,
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        onPressed: () async {
                          if (validateAndSave()) {
                            dialogueNote(context, "verification en cours...");

                            if (await searchUser(userController.text.toString(),
                                passwordController.text.toString())) {
                              if (trouve == 2) {
                                saveDataUser!.setInt("role", actifCompt.role);
                                debugPrint(actifCompt.role.toString());
                              } else {
                                saveDataUser!.setInt("role", actifComptes.role);
                                debugPrint(actifComptes.role.toString());
                              }

                              setState(() {
                                isInAsynCall = false;
                                loginData.setBool('login', false);
                              });

                              Timer(const Duration(seconds: 3), () {
                                DInfo.toastSuccess("vous êtes connectés");
                                Navigator.of(context).push(
                                  SlideRightRoute(
                                      child: const HomePage(),
                                      page: const HomePage(),
                                      direction: AxisDirection.left),
                                );
                              });
                            } else {
                              Navigator.pop(context);
                              DInfo.toastError(
                                  "Identifiant ou Mot de passe Incorrect !!");
                            }
                          } else {
                            DInfo.toastError("Remplissez les champs svp?");
                          }
                        },
                        child: CustomText("Se connecter",
                            color: Colors.white,
                            tex: TailleText(context).soustitre)),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  //* verifie les champs de saisie

  bool validateAndSave() {
    final form = _formKey.currentState;

    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> searchUser(String username, String password) async {
    CompteModel? compte =
        await AppDatabase.instance.oneCompte(username, password);

    if (compte != null) {
      if (compte.username == username && compte.password == password) {
        setState(() {
          trouve = 2;
        });

        actifCompt = compte;
        return true;
      }
    } else {
      ComptesModels? c =
          await Comptes().oneCompte(username: username, password: password);

      if (c != null) {
        debugPrint("entttt");
        if (c.username == username && c.password == password) {
          setState(() {
            trouve = 1;
          });
          actifComptes = c;
          return true;
        }
      }
    }

    return false;
  }
}
