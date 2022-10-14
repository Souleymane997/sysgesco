import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sysgesco/controllers/eleve_controller.dart';
import '../../../functions/colors.dart';
import '../../../functions/custom_text.dart';
import '../../../functions/fonctions.dart';
import '../../../functions/slidepage.dart';
import '../../../models/eleve_model.dart';
import 'detailsEleve.dart';

class ListingPage extends StatefulWidget {
  const ListingPage({super.key, required this.matiere, required this.classe});

  final String matiere;
  final String classe;

  @override
  State<ListingPage> createState() => _ListingPageState();
}

class _ListingPageState extends State<ListingPage> {
  late Future<List<ElevesModel>> feedEleve;
  List<ElevesModel> selectList = [];
  String choixMatiere = "";
  String choixClasse = "";

  int classeID = 0;
  int anneeID = 0;
  late SharedPreferences? saveClasseID;
  late SharedPreferences? saveLastAnneeID;

  loadEleve() {
    Future<List<ElevesModel>> result = Eleve().listEleve(id1: classeID, id2: anneeID);
    setState(() {
      feedEleve = result;
    });
  }

  bool loading = false;

  void checkID() async {
    saveClasseID = await SharedPreferences.getInstance();
    saveLastAnneeID = await SharedPreferences.getInstance();

    anneeID = (saveLastAnneeID!.getInt('lastAnneeID') ?? 0);
    classeID = (saveClasseID!.getInt('classeID') ?? 0);

    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        loading = true;
      });
      loadEleve();
    });
  }

  @override
  void initState() {
    checkID();
    choixClasse = widget.classe;
    choixMatiere = widget.matiere;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (selectList.isEmpty)
          ? AppBar(
              title: const Text("Notes"),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.search,
                  ),
                  onPressed: () {
                    debugPrint("hello");
                    //searchDialogue();
                  },
                ),
                Container(
                  width: 10,
                )
              ],
            )
          : menuAppBar(selectList, context),
      body: Center(
        child: Column(
          children: [
            Container(
              color: Colors.grey.shade400,
              child: Column(children: [
                Container(
                  height: 15,
                ),
                CustomText(
                  choixClasse,
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
                        width: 20,
                        height: 20,
                        child: Image.asset(
                          "assets/images/classroom.png",
                          fit: BoxFit.fill,
                          color: gris(),
                        )),
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
                  height: 15,
                ),
                CustomText(
                  choixMatiere,
                  tex: 0.85,
                  color: gris(),
                  fontWeight: FontWeight.w600,
                ),
                Container(
                  height: 15,
                ),
              ]),
            ),
            Container(
              height: 5,
            ),
            Expanded(child:(loading)? elemntInList() : pageLoading(context)),
          ],
        ),
      ),
    );
  }


  Widget elemntInList() {
    return FutureBuilder<List<ElevesModel>>(
        future: feedEleve,
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
        color: Colors
            .transparent, //(element.isSelected) ? grisee() : Colors.transparent,
        padding: const EdgeInsets.only(left: 0.5, right: 0.5),
        child: ListTile(
          onTap: () {
            Navigator.of(context).push(
              SlideRightRoute(
                  child: DetailsElevePage(
                    eleve: element,
                    matiere: choixMatiere,
                  ),
                  page: DetailsElevePage(
                    eleve: element,
                    matiere: choixMatiere,
                  ),
                  direction: AxisDirection.left),
            );
            // }
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
}



 // (element.isSelected)
            //     ? Positioned(
            //         bottom: 0.0,
            //         right: -1.0,
            //         child: Center(
            //             child: Icon(Icons.check_circle,
            //                 size: 13.0, color: teal())),
            //       )
            //     : Positioned(
            //         bottom: 0.0,
            //         right: 0.0,
            //         child: Container(),
            //       )


             // onLongPress: (() {
          //   setState(() {
          //     //element.isSelected = true;
          //     if (element.isSelected == true) {
          //       selectList.add(element);
          //       DInfo.toastNetral("on a selectionne ${selectList.length}");
          //     } else if (element.isSelected == false) {
          //       selectList
          //           .removeWhere(((ss) => ss.nomPrenom == element.nomPrenom));
          //       DInfo.toastNetral(
          //           "on a retirer ${element.nomPrenom} de la liste .. il reste ${selectList.length}");
          //     }
          //   });
          // }),


           //if (selectList.isNotEmpty) {
            //element.isSelected = !element.isSelected;
            // setState(() {
            //   if (element.isSelected == true) {
            //     selectList.add(element);
            //     DInfo.toastNetral("on a selectionne ${selectList.length}");
            //   } else if (element.isSelected == false) {
            //     selectList
            //         .removeWhere(((ss) => ss.nomPrenom == element.nomPrenom));
            //     DInfo.toastNetral(
            //         "on a retirer ${element.nomPrenom} de la liste .. il reste ${selectList.length}");
            //   }
            // });
            // } else {