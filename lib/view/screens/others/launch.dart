import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import '../../../functions/custom_text.dart';
import '../../../models/http.dart';
import '../../../services/database.dart';
import 'login.dart';

class Launch extends StatefulWidget {
  const Launch({Key? key}) : super(key: key);

  @override
  State<Launch> createState() => _LaunchState();
}

class _LaunchState extends State<Launch> {
  late SharedPreferences? saveLienHttp;
  late List<HttpModel> feedHtpp;

  void checkLastAnneID() async {
    saveLienHttp = await SharedPreferences.getInstance();
    feedHtpp = await AppDatabase.instance.listHttp();
    String chaine = (saveLienHttp!.getString('lienHttp') ?? "");

    if (chaine.isEmpty) {
      saveLienHttp!.setString('lienHttp', feedHtpp[0].cheminHttp);
      chaine = (saveLienHttp!.getString('lienHttp') ?? "");
    }
    debugPrint("lien Http : $chaine");
  }

  void checkLogin() async {
    Timer(
        const Duration(seconds: 3),
        () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LoginPage()))
            });
  }

  @override
  void initState() {
    checkLastAnneID();
    checkLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.teal[300],
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(height: MediaQuery.of(context).size.height * 0.30),
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(75.0),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/logo.png'),
                            fit: BoxFit.contain,
                          )),
                    ),
                  ),
                  Container(height: MediaQuery.of(context).size.height * 0.3),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 10),
                    child: CustomText(
                      ' SYSGESCO ',
                      tex: 1.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  progressCircular() async {
    Timer(
        const Duration(milliseconds: 50),
        () => {
              const CircularProgressIndicator(
                color: Colors.white,
              ),
            });
  }
}
