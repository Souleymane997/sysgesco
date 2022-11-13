import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sysgesco/functions/dialoguetoast.dart';
import '../../../controllers/eleve_controller.dart';
import '../../../functions/colors.dart';
import '../../../functions/custom_text.dart';
import '../../../functions/fonctions.dart';
import '../../../functions/slidepage.dart';
import '../../../models/eleve_model.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../only/multiconvosend.dart';
import '../only/multiemploisend.dart';
import '../only/multinotesend.dart';
import '../only/multiretardsend.dart';
import 'eleve.dart';

class ListeElevePage extends StatefulWidget {
  const ListeElevePage({super.key, required this.classe});
  final String classe;
  @override
  State<ListeElevePage> createState() => _ListeElevePageState();
}

class _ListeElevePageState extends State<ListeElevePage> {
  late Future<List<ElevesModel>> feedEleve;
  late Future<List<ElevesModel>> feedSearchEleve;
  bool boarding = true;
  int count = 0;
  int eleveID = 0;
  int classeID = 0;
  int anneeID = 0;
  int trimestreID = 0;
  bool loading = false;
  late SharedPreferences? saveClasseID;
  late SharedPreferences? saveLastAnneeID;

  bool showSearch = false;
  String changed = '';
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController editingController = TextEditingController();

  List<ElevesModel> selectList = [];

  void checkID() async {
    saveClasseID = await SharedPreferences.getInstance();
    saveLastAnneeID = await SharedPreferences.getInstance();

    setState(() {
      anneeID = (saveLastAnneeID!.getInt('lastAnneeID') ?? 0);
      classeID = (saveClasseID!.getInt('classeID') ?? 0);
    });

    Future<List<ElevesModel>> result =
        Eleve().listEleve(id1: classeID, id2: anneeID);

    Timer(const Duration(milliseconds: 1500), () {
      setState(() {
        feedEleve = result;
        loading = true;
      });
    });
  }

  @override
  void initState() {
    debugPrint(widget.classe.toString());
    checkID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (selectList.isEmpty)
          ? AppBar(
              title: const Text("Liste des Eleves "),
              actions: [
                IconButton(
                  icon: (!showSearch)
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
                  onPressed: () {
                    debugPrint("show zone search");
                    setState(() {
                      showSearch = !showSearch;
                      changed = "";
                      editingController.text = "";
                      boarding = true;
                    });
                  },
                ),
                Container(
                  width: 10,
                )
              ],
            )
          : menuAppBar(selectList, context),
      body: SafeArea(
        child: Column(
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
                              left: MediaQuery.of(context).size.width * 0.05,
                              right: MediaQuery.of(context).size.width * 0.05),
                          child: TextField(
                            controller: editingController,
                            onChanged: (value) {
                              changed = value;
                              if (changed.isNotEmpty) {
                                setState(() {
                                  feedSearchEleve = Eleve().listEleve(
                                      id1: classeID,
                                      id2: anneeID,
                                      query: changed);
                                  boarding = false;
                                });
                              } else {
                                setState(() {
                                  boarding = true;
                                });
                              }
                            },
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 0.0),
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
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
                              hintText: " rechercher un élève ",
                              // border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(),
            Container(
              height: 15.0,
            ),
            Expanded(child: (loading) ? elemntInList() : pageLoading(context)),
          ],
        ),
      ),
      floatingActionButton:
          SpeedDial(icon: Icons.send, backgroundColor: amberFone(), children: [
        SpeedDialChild(
          child: SizedBox(
              width: 30,
              height: 20,
              child: Image.asset(
                "assets/images/await.png",
                color: blanc(),
              )),
          label: 'Retard & Absence',
          backgroundColor: Colors.red,
          onTap: () {
            if (selectList.isNotEmpty) {
              debugPrint("entrrer");
              Navigator.of(context).push(
                SlideRightRoute(
                    child: SendRetardList(
                      eleve: selectList,
                      classe: widget.classe,
                    ),
                    page: SendRetardList(
                      eleve: selectList,
                      classe: widget.classe,
                    ),
                    direction: AxisDirection.left),
              );
            } else {
              DInfo.toastError("selectionner un élève");
            }
          },
        ),
        SpeedDialChild(
          child: SizedBox(
              width: 30,
              height: 20,
              child: Image.asset(
                "assets/images/invitation.png",
                color: blanc(),
              )),
          label: 'Convocation',
          backgroundColor: tealFonce(),
          onTap: () {
            if (selectList.isNotEmpty) {
              debugPrint("entrrer");
              Navigator.of(context).push(
                SlideRightRoute(
                    child: SendConvocationList(
                      eleve: selectList,
                      classe: widget.classe,
                    ),
                    page: SendConvocationList(
                      eleve: selectList,
                      classe: widget.classe,
                    ),
                    direction: AxisDirection.left),
              );
            } else {
              DInfo.toastError("selectionner un élève");
            }
          },
        ),
        SpeedDialChild(
          child: SizedBox(
              width: 30,
              height: 20,
              child: Image.asset(
                "assets/images/calendar.png",
                color: blanc(),
              )),
          label: 'Emploi du temps',
          backgroundColor: bleu(),
          onTap: () {
            if (selectList.isNotEmpty) {
              Navigator.of(context).push(
                SlideRightRoute(
                    child: OnlySendEmploi(
                      eleve: selectList,
                      classe: widget.classe,
                    ),
                    page: OnlySendEmploi(
                      eleve: selectList,
                      classe: widget.classe,
                    ),
                    direction: AxisDirection.left),
              );
            } else {
              DInfo.toastError("selectionner un élève");
            }
          },
        ),
        SpeedDialChild(
          child: SizedBox(
              width: 30,
              height: 20,
              child: Image.asset(
                "assets/images/nt.png",
                color: blanc(),
              )),
          label: 'Notes',
          backgroundColor: amberFone(),
          onTap: () {
            if (selectList.isNotEmpty) {
              debugPrint("entrrer");
              Navigator.of(context).push(
                SlideRightRoute(
                    child: SendNotePageList(
                      eleve: selectList,
                      classe: widget.classe,
                    ),
                    page: SendNotePageList(
                      eleve: selectList,
                      classe: widget.classe,
                    ),
                    direction: AxisDirection.left),
              );
            } else {
              DInfo.toastError("selectionner un élève");
            }
          },
        ),
      ]),
    );
  }

  Widget elemntInList() {
    return FutureBuilder<List<ElevesModel>>(
        future: (boarding) ? feedEleve : feedSearchEleve,
        builder:
            (BuildContext context, AsyncSnapshot<List<ElevesModel>> snapshot) {
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
          List<ElevesModel>? data = snapshot.data;

          return ListView.builder(
              itemCount: data!.length,
              itemBuilder: (context, index) {
                ElevesModel item = data[index];

                return cardWidget(item);
              });
        });
  }

  Widget cardWidget(ElevesModel element) {
    return Card(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Container(
        padding: const EdgeInsets.only(left: 0.5, right: 0.5),
        color: (!addElement(element))
            ? tealClaire().withOpacity(0.4)
            : Colors.transparent,
        child: ListTile(
          onTap: () {
            if (selectList.isNotEmpty) {
              if (addElement(element)) {
                setState(() {
                  selectList.add(element);
                });
              } else {
                setState(() {
                  selectList.remove(element);
                });
              }
            } else {
              // Navigator.of(context).push(
              //   SlideRightRoute(
              // child: ViewElevePage(
              //   eleve: element,
              // ),
              //       page: ViewElevePage(
              //         eleve: element,
              //       ),
              //       direction: AxisDirection.left),
              // );

              onTapFunction(context, element);
            }
          },
          onLongPress: () {
            if (addElement(element)) {
              setState(() {
                selectList.add(element);
              });
            }
          },
          leading: Stack(children: [
            CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Center(
                  child: Icon(
                Icons.account_circle,
                size: 40,
                color: gris(),
              )),
            ),
          ]),
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomText(
              "${element.nomEleve}  ${element.prenomEleve}",
              tex: TailleText(context).soustitre * 0.8,
              color: noir(),
              textAlign: TextAlign.left,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomText(
                    'Contact Parents : ${element.phoneParent}',
                    tex: TailleText(context).contenu * 0.8,
                    color: noir(),
                    textAlign: TextAlign.left,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool addElement(ElevesModel eleves) {
    for (var i = 0; i < selectList.length; i++) {
      if (eleves.idEleve.toString() == selectList[i].idEleve.toString()) {
        return false;
      }
    }
    return true;
  }

  refreshList() {
    Future.delayed(const Duration(milliseconds: 1));
    setState(() {
      loading = false;
      build(context);
    });

    Timer(const Duration(milliseconds: 5), () {
      Future<List<ElevesModel>> result =
          Eleve().listEleve(id1: classeID, id2: anneeID);
      setState(() {
        feedEleve = result;
        loading = true;
      });
    });
  }

  onTapFunction(BuildContext context, ElevesModel element) async {
    // final res = await Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => ViewElevePage(
    //               eleve: element,
    //             )));

    final res = await Navigator.of(context).push(
      SlideRightRoute(
          child: ViewElevePage(
            eleve: element,
          ),
          page: ViewElevePage(
            eleve: element,
          ),
          direction: AxisDirection.left),
    );


    if (res) refreshList();
  }
}
