// ignore_for_file: unused_element

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sysgesco/controllers/annee_controller.dart';
import 'package:sysgesco/models/annee_model.dart';
import '../../../controllers/classe_controller.dart';
import '../../../functions/colors.dart';
import '../../../functions/custom_text.dart';
import '../../../functions/dialoguetoast.dart';
import '../../../functions/fonctions.dart';
import '../../../functions/slidepage.dart';
import '../../../models/classe_model.dart';
import '../../../models/http.dart';
import '../../../services/config.dart';
import '../classe/classe.dart';
import '../classe/nouveaueleve.dart';
import '../emploi/emploi.dart';
import '../enseignant/enseignant.dart';
import '../messages/message.dart';
import '../scolarite/scolarite.dart';
import 'navDrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<ClasseModel>> feedClasse;
  List<AnneeModel> feedAnnee = [];
  late Future<List<ClasseModel>> feedSearchClasse;
  late List<HttpModel> feedHtpp;
  bool exit = true;
  bool loading = false;
  ClasseModel newClasse = ClasseModel();

  late SharedPreferences? saveLastAnneeID;
  late SharedPreferences? saveLienHttp;

  bool boarding = true;

  bool showSearch = false;
  String changed = '';
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController editingController = TextEditingController();

  final listAnnee = ['-- choisir une annee --'];
  String value = '-- choisir une annee --';
  int idValue = 0;

  call() {
    loadClasse();
    Timer(const Duration(milliseconds: 2000), () {
      setState(() {
        loading = true;
      });
    });
  }

  @override
  void initState() {
    checkLastAnneID();
    call();
    super.initState();
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
      child: RefreshIndicator(
        onRefresh: refrech,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.teal,
              title: const Text("Accueil"),
              actions: [
                IconButton(
                    onPressed: () {
                      searchAnnee(context);
                    },
                    icon: const Icon(Icons.filter_center_focus)),
                Container(
                  width: 20,
                ),
                InkWell(
                  onTap: () {
                    debugPrint("show zone search");
                    setState(() {
                      showSearch = !showSearch;
                      changed = "";
                      editingController.text = "";
                      boarding = true;
                    });
                  },
                  child: (!showSearch)
                      ? const Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 25.0,
                        )
                      : const Icon(
                          Icons.cancel,
                          color: Colors.white,
                          size: 25.0,
                        ),
                ),
                Container(
                  width: 20,
                )
              ],
            ),
            drawer: const NavDrawer(),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 8.0,
                  ),
                  (showSearch)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.12,
                                    right: MediaQuery.of(context).size.width *
                                        0.12),
                                child: TextField(
                                  controller: editingController,
                                  onChanged: (value) {
                                    changed = value;
                                    if (changed.isNotEmpty) {
                                      setState(() {
                                        feedSearchClasse =
                                            Classe().listClasse(query: changed);
                                        boarding = false;
                                      });
                                    } else {
                                      setState(() {
                                        boarding = true;
                                      });
                                    }
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 0.0),
                                    border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0))),
                                    prefixIcon: const Icon(Icons.search),
                                    suffixIcon: changed.isNotEmpty
                                        ? GestureDetector(
                                            child: const Icon(Icons.close),
                                            onTap: () {
                                              setState(() {
                                                editingController.clear();
                                                changed = '';
                                                boarding = true;
                                              });

                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                            },
                                          )
                                        : null,
                                    hintText: " rechercher une Classe",
                                    // border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  Container(
                    height: 5.0,
                  ),
                  (loading)
                      ? Expanded(child: gridClasse())
                      : Center(child: pageLoading(context)),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                dashBordDialog();
              },
              elevation: 10.0,
              backgroundColor: Colors.amber[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('assets/images/grid.png'),
                  fit: BoxFit.contain,
                )),
              ),
            ),
          ),
        ),
      ),
    );
  }

  loadClasse() {
    Future<List<ClasseModel>> result = Classe().listClasse();

    setState(() {
      feedClasse = result;
    });
  }

  void checkLastAnneID() async {
    saveLastAnneeID = await SharedPreferences.getInstance();
    saveLienHttp = await SharedPreferences.getInstance();

    String res = await Annee().lastAnneeID();
    debugPrint("resultat : $res");

    int newInt = (saveLastAnneeID!.getInt('lastAnneeID') ?? 0);
    String chaine = (saveLienHttp!.getString('lienHttp') ?? "");

    if (res != newInt.toString()) {
      saveLastAnneeID!.setInt('lastAnneeID', int.parse(res.toString()));
      newInt = (saveLastAnneeID!.getInt('lastAnneeID') ?? 0);
    }

    debugPrint("idlast : $newInt");
    debugPrint("lien Http : $chaine");

    Timer(const Duration(milliseconds: 500), () {
      loadClasse();
      loadAnnee();
    });
  }

  Widget gridClasse() {
    return FutureBuilder<List<ClasseModel>>(
        future: (boarding) ? feedClasse : feedSearchClasse,
        builder:
            (BuildContext context, AsyncSnapshot<List<ClasseModel>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text("No Connection"),
            );
          }

          if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No data"),
            );
          }

          List<ClasseModel>? data = snapshot.data;
          return GridView.builder(
            padding: const EdgeInsets.all(25),
            itemCount: data!.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 200,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                crossAxisCount: 2),
            itemBuilder: (BuildContext context, int index) {
              String classe = data[index].libelleClasse.toString();

              return cardMenu(
                  classe, VoirPlusPage(choix: 1, classe: data[index]), context);
            },
          );
        });
  }

/* boite de Dialogue de Dashbord*/
  Future<void> dashBordDialog() async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => SimpleDialog(
          elevation: 5.0,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          contentPadding: const EdgeInsets.all(0),
          children: [containDashbord()],
        ),
      ),
    );
  }

  Widget containDashbord() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          image: const DecorationImage(
            image: AssetImage("assets/caroussel/1.jpg"),
            fit: BoxFit.cover,
          )),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black87.withOpacity(0.70),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                Expanded(
                    child: CustomText(
                  "Tableau de Bord",
                  tex: 1.3,
                  fontWeight: FontWeight.w700,
                  color: amberFone(),
                )),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.close,
                      color: blanc(),
                    )),
              ],
            ),
            Divider(
              color: blanc(),
              endIndent: 10,
              indent: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                rowDashbord(
                    "assets/images/student.png",
                    "Nouveau",
                    const NouveauPage(),
                    "assets/images/classroom.png",
                    "Classes   ",
                    VoirPlusPage(
                      choix: 0,
                      classe: newClasse,
                    )),
                Container(
                  height: 10,
                ),
                rowDashbord(
                    "assets/images/sms.png",
                    "   Messages   ",
                    const MessagePage(),
                    "assets/images/planning.png",
                    "Emploi du temps",
                    const EmploiDuTemps()),
                Container(
                  height: 10,
                ),
                rowDashbord(
                    "assets/images/scol.png",
                    "   Enseignants   ",
                    const EnseignantPages(),
                    "assets/images/school.png",
                    "   Scolarité   ",
                    const ScolaritePage()),
                Container(
                  height: 15,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget containBord(String chemin, String nom, Widget x) {
    return Expanded(
      child: Center(
        child: InkWell(
          onTap: () {
            debugPrint("hello");
            Navigator.of(context).push(
              SlideRightRoute(child: x, page: x, direction: AxisDirection.left),
            );
          },
          child: Column(
            children: [
              Card(
                elevation: 8.0,
                color: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  side: const BorderSide(
                    color: Colors.white,
                  ),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.15,
                  height: MediaQuery.of(context).size.width * 0.15,
                  decoration: BoxDecoration(
                    color: Colors.black87.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: blanc(),
                    ),
                  ),
                  child: Center(
                      child: ImageIcon(
                    AssetImage(chemin),
                    color: blanc(),
                    size: 35,
                  )),
                ),
              ),
              CustomText(
                nom,
                tex: 0.75,
                color: amberFone(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget rowDashbord(String chemin1, String nom1, Widget x1, String chemin2,
      String nom2, Widget x2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        containBord(chemin1, nom1, x1),
        containBord(chemin2, nom2, x2),
      ],
    );
  }

  /* boite de Dialogue de Classe  */
  Future<void> searchAnnee(BuildContext parentContext) async {
    return await showDialog(
        context: parentContext,
        barrierDismissible: false,
        builder: (dialogcontext) => StatefulBuilder(
            builder: (stfContext, stfsetState) => SimpleDialog(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  contentPadding: const EdgeInsets.only(top: 2.0),
                  backgroundColor: Colors.white,
                  title: Row(
                    children: [
                      Expanded(
                        child: CustomText(
                          "Choisir une Année Scolaire",
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                          tex: TailleText(context).titre,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.close,
                            color: teal(),
                          )),
                    ],
                  ),
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                        margin: const EdgeInsets.only(left: 15, right: 15),
                        padding: const EdgeInsets.only(left: 15),
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.4,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10)),
                        child: DropdownButton<String>(
                            underline: Container(),
                            icon: const Icon(Icons.arrow_drop_down,
                                color: Colors.blueGrey),
                            value: value,
                            isExpanded: true,
                            items: listAnnee.map(buildMenuItem).toList(),
                            iconSize: 30,
                            iconEnabledColor: Colors.blueGrey,
                            onChanged: ((value) {
                              stfsetState(() {
                                this.value = value!;
                              });
                              setState(() {
                                this.value = value!;
                              });
                            }))),
                    const SizedBox(
                      height: 25,
                    ),
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.teal,
                              padding:
                                  const EdgeInsets.only(left: 12, right: 12),
                              shadowColor: Colors.teal.shade300,
                              elevation: 5.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            onPressed: () {
                              if (value == listAnnee[0]) {
                                DInfo.toastError("Faites un Choix svp !!");
                              } else {
                                setState(() {});
                                Navigator.of(context).pop();
                                searchId();
                              }
                            },
                            child: CustomText(
                              "soumettre",
                              color: Colors.white,
                              tex: 0.85,
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                )));
  }

  searchId() {
    for (var i = 0; i < feedAnnee.length; i++) {
      if (value == feedAnnee[i].libelleAnnee.toString()) {
        setState(() {
          idValue = int.parse(feedAnnee[i].idAnnee.toString());
        });
      }
    }
    saveLastAnneeID!.setInt('lastAnneeID', int.parse(idValue.toString()));
    int newInt = (saveLastAnneeID!.getInt('lastAnneeID') ?? 0);
    debugPrint("idlast111 : $newInt");
  }

  loadAnnee() async {
    List<AnneeModel> result = await Annee().listAnnee();
    setState(() {
      feedAnnee = result;
    });

    if (listAnnee.length > 1) {
      listAnnee.clear();
      listAnnee.add('-- choisir une annee --');
    }

    for (var i = 0; i < feedAnnee.length; i++) {
      setState(() {
        listAnnee.add(feedAnnee[i].libelleAnnee.toString());
      });
    }
  }

  Future refrech() async {
    await Future.delayed(const Duration(seconds: 1));

    checkLastAnneID();
    call();
  }
}
