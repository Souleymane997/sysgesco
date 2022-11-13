import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sysgesco/controllers/ens_controller.dart';
import 'package:sysgesco/view/screens/enseignant/detailsEns.dart';
import 'package:sysgesco/view/screens/enseignant/newEnseignant.dart';

import '../../../functions/colors.dart';
import '../../../functions/custom_text.dart';
import '../../../functions/fonctions.dart';
import '../../../functions/slidepage.dart';
import '../../../models/enseignant_model.dart';

class EnseignantPages extends StatefulWidget {
  const EnseignantPages({super.key});

  @override
  State<EnseignantPages> createState() => _EnseignantPagesState();
}

class _EnseignantPagesState extends State<EnseignantPages> {
  late Future<List<EnseignantModel>> feedEns;

  bool loading = false;

  loadEns() {
    Future<List<EnseignantModel>> result = Enseignant().listEns();
    setState(() {
      feedEns = result;
    });

    Timer(const Duration(milliseconds: 1000), () {
      setState(() {
        loading = true;
      });
    });
  }

  @override
  void initState() {
    loadEns();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refrech,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Gestion des Enseignants"),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Center(
                  child: CustomText(
                "Listes des Enseignants",
                color: teal(),
                textAlign: TextAlign.center,
              )),
            ),
            Container(
              height: 5,
            ),
            Expanded(child: (loading) ? elemntInList() : pageLoading(context)),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            newFunction(context);
          },
          elevation: 10.0,
          backgroundColor: teal(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget elemntInList() {
    return FutureBuilder<List<EnseignantModel>>(
        future: feedEns,
        builder: (BuildContext context,
            AsyncSnapshot<List<EnseignantModel>> snapshot) {
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
          List<EnseignantModel>? data = snapshot.data;

          return ListView.builder(
              itemCount: data!.length,
              itemBuilder: (context, index) {
                EnseignantModel item = data[index];
                return cardWidget(item);
              });
        });
  }

  Widget cardWidget(EnseignantModel element) {
    return Card(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Container(
        color: Colors
            .transparent, //(element.isSelected) ? grisee() : Colors.transparent,
        padding: const EdgeInsets.only(left: 0.5, right: 0.5),
        child: ListTile(
          onTap: () {
            onTapFunction(context, element);
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
              "${element.nomEns}  ${element.prenomEns}",
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
                    'Contact : ${element.phone}',
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

  Future refrech() async {
    await Future.delayed(const Duration(seconds: 1));

    await loadEns();
  }

  onTapFunction(BuildContext context, EnseignantModel element) async {
    // final res = await Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => ViewElevePage(
    //               eleve: element,
    //             )));
    final res = await Navigator.of(context).push(
      SlideRightRoute(
          child: DetailsEnseignants(
            enseignant: element,
          ),
          page: DetailsEnseignants(
            enseignant: element,
          ),
          direction: AxisDirection.left),
    );

    if (res) refreshList();
  }

  newFunction(BuildContext context) async {
    // final res = await Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => ViewElevePage(
    //               eleve: element,
    //             )));
    final res = await Navigator.of(context).push(
      SlideRightRoute(
          child: const NewEnseignantPages(),
          page: const NewEnseignantPages(),
          direction: AxisDirection.left),
    );

    if (res) refreshList();
  }

  refreshList() {
    Future.delayed(const Duration(milliseconds: 1));
    setState(() {
      loading = false;
      build(context);
    });

    Timer(const Duration(milliseconds: 5), () {
      Future<List<EnseignantModel>> result = Enseignant().listEns();
      setState(() {
        feedEns = result;
        loading = true;
      });
    });
  }
}
