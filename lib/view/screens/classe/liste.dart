import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../controllers/eleve_controller.dart';
import '../../../functions/colors.dart';
import '../../../functions/custom_text.dart';
import '../../../functions/fonctions.dart';
import '../../../models/eleve_model.dart';

class AfficheNote extends StatefulWidget {
  const AfficheNote({super.key, required this.matiere});
  final String matiere;

  @override
  State<AfficheNote> createState() => _AfficheNoteState();
}

class _AfficheNoteState extends State<AfficheNote> {

  late Future<List<ElevesModel>> feedEleve;

  int eleveID = 0;
  int classeID = 0;
  int anneeID = 0;
  int matiereID = 0;
  int trimestreID = 0;
  bool loading = false;
  late SharedPreferences? saveClasseID;
  late SharedPreferences? saveLastAnneeID;
  late SharedPreferences? saveMatiereID;





  void checkID() async {
    saveClasseID = await SharedPreferences.getInstance();
    saveLastAnneeID = await SharedPreferences.getInstance();
    saveMatiereID = await SharedPreferences.getInstance();
    setState(() {
      anneeID = (saveLastAnneeID!.getInt('lastAnneeID') ?? 0);
      classeID = (saveClasseID!.getInt('classeID') ?? 0);
      matiereID = (saveMatiereID!.getInt('matiereID') ?? 0);
    });

      Timer(const Duration(milliseconds: 500), () {
      Future<List<ElevesModel>> result = Eleve().listEleve( id1: classeID, id2: anneeID);
      setState(() {
        feedEleve = result;
        loading = true;
        
      });
    }) ;
  }

  @override
  void initState() {
    checkID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des Eleves "),
        actions: [
                IconButton(
                  icon: const Icon(
                    Icons.search,
                  ),
                  onPressed: () {
                    debugPrint("hello");
                  },
                ),
                Container(
                  width: 10,
                )
              ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.grey.shade400,
              child: Column(children: [
                Container(
                  height: 15,
                ),
                CustomText(
                  widget.matiere,
                  tex: 1.25,
                  color: blanc(),
                  fontWeight: FontWeight.w600,
                ),
                
              ]),
            ),
            Container(
              height: 5,
            ),
            Expanded(child: (loading) ? elemntInList() : pageLoading(context)),
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
            // Navigator.of(context).push(
            //   SlideRightRoute(
            //       child: DetailsElevePage(
            //         eleve: element,
            //         matiere: choixMatiere,
            //       ),
            //       page: DetailsElevePage(
            //         eleve: element,
            //         matiere: choixMatiere,
            //       ),
            //       direction: AxisDirection.left),
            // );
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
