// ignore_for_file: file_names

import 'dart:async';

import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sysgesco/functions/fonctions.dart';
import 'package:sysgesco/models/note_model.dart';
import 'package:sysgesco/view/screens/classe/saisirNote.dart';

import '../../../controllers/note_controller.dart';
import '../../../functions/colors.dart';
import '../../../functions/custom_text.dart';
import '../../../functions/slidepage.dart';
import '../../../models/eleve_model.dart';
import 'editNote.dart';

class DetailsElevePage extends StatefulWidget {
  const DetailsElevePage(
      {super.key, required this.eleve, required this.matiere});

  final ElevesModel eleve;
  final String matiere;

  @override
  State<DetailsElevePage> createState() => _DetailsElevePageState();
}

class _DetailsElevePageState extends State<DetailsElevePage> {
  late ElevesModel element;
  List<NoteModel> feed1 = [];
  List<NoteModel> feed2 = [];
  List<NoteModel> feed3 = [];

  List<String> feedNote1 = [];
  List<String> feedNote2 = [];
  List<String> feedNote3 = [];

  late SharedPreferences? saveClasseID;
  late SharedPreferences? saveLastAnneeID;
  late SharedPreferences? saveMatiereID;

  int countNoteTrimestre1 = 0;
  int countNoteTrimestre2 = 0;
  int countNoteTrimestre3 = 0;

  int eleveID = 0;
  int classeID = 0;
  int anneeID = 0;
  int matiereID = 0;
  int trimestreID = 0;
  String choixMatiere = "";

  final GlobalKey card1 = GlobalKey();
  final GlobalKey card2 = GlobalKey();
  final GlobalKey card3 = GlobalKey();

  bool loading = false;

  loadCountNote() async {
    String res1 =
        await Notes().countNoteOfTrismetre(1, matiereID, anneeID, classeID);
    setState(() {
      countNoteTrimestre1 = int.parse(res1);
    });

    String res2 =
        await Notes().countNoteOfTrismetre(2, matiereID, anneeID, classeID);
    setState(() {
      countNoteTrimestre2 = int.parse(res2);
    });

    String res3 =
        await Notes().countNoteOfTrismetre(3, matiereID, anneeID, classeID);
    setState(() {
      countNoteTrimestre3 = int.parse(res3);
    });
  }

  void checkID() async {
    saveClasseID = await SharedPreferences.getInstance();
    saveLastAnneeID = await SharedPreferences.getInstance();
    saveMatiereID = await SharedPreferences.getInstance();
    setState(() {
      anneeID = (saveLastAnneeID!.getInt('lastAnneeID') ?? 0);
      classeID = (saveClasseID!.getInt('classeID') ?? 0);
      matiereID = (saveMatiereID!.getInt('matiereID') ?? 0);
    });

    feed1 =
        await Notes().listNoteEleve(eleveID, 1, matiereID, anneeID, classeID);

    feed2 =
        await Notes().listNoteEleve(eleveID, 2, matiereID, anneeID, classeID);

    feed3 =
        await Notes().listNoteEleve(eleveID, 3, matiereID, anneeID, classeID);

    Timer(const Duration(milliseconds: 200), () {
      loadCountNote();
      setState(() {
        loading = true;
      });
      
    });
  }

  @override
  void initState() {
    element = widget.eleve;
    setState(() {
      eleveID = int.parse(element.idEleve.toString());
    });

    checkID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Details Eleve "),
          // ListingPage(matiere: mat, classe: value)
        ),
        body: buildBody(),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                SlideRightRoute(
                    child: SaisirNotePage(
                      eleve: element,
                      matiere: choixMatiere,
                    ),
                    page: SaisirNotePage(
                      eleve: element,
                      matiere: choixMatiere,
                    ),
                    direction: AxisDirection.left),
              );
            },
            elevation: 10.0,
            backgroundColor: Colors.teal,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.0),
            ),
            child: const Icon(Icons.add)));
  }

  Widget buildBody() {
    return (loading)
        ? SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Center(
                child: Column(
              children: [
                Container(
                  height: 15,
                ),
                CustomText(
                  "${element.nomEleve}  ${element.prenomEleve}",
                  tex: 1.25,
                  color: gris(),
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
                      child: Icon(
                        Icons.person,
                        color: gris(),
                      ),
                    ),
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
                  widget.matiere,
                  tex: 0.85,
                  color: gris(),
                  fontWeight: FontWeight.w300,
                ),
                Container(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: expandedContain(feed1, card1, 1, countNoteTrimestre1),
                ),
                Container(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: expandedContain(feed2, card2, 2, countNoteTrimestre2),
                ),
                Container(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: expandedContain(feed3, card3, 3, countNoteTrimestre3),
                ),
                Container(
                  height: 25,
                ),
              ],
            )))
        : pageLoading(context);
  }

  Widget expandedContain(
      List<NoteModel> notes, GlobalKey cardKey, int num, int c) {
    return ExpansionTileCard(
      baseColor: Colors.teal.withOpacity(0.2),
      expandedColor: Colors.teal.withOpacity(0.2),
      initiallyExpanded: true,
      borderRadius: const BorderRadius.all(Radius.circular(0.0)),
      key: cardKey,
      elevation: 0.0,
      title: CustomText(
        " TRIMESTRE $num ",
        tex: TailleText(context).soustitre,
        textAlign: TextAlign.left,
        color: noir(),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomText(
          " on a  $c notes dans ce Trimestre",
          tex: TailleText(context).contenu * 0.8,
          textAlign: TextAlign.left,
          color: noir(),
        ),
      ),
      children: <Widget>[
        Container(
          height: 3.0,
        ),
        loadFeedWidget(notes, c, num),
      ],
    );
  }

  Widget loadFeedWidget(List<NoteModel> notes, int c, int num) {
    if (notes.isNotEmpty) {
      int long = notes.length;

      return Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            (long >= 1)
                ? cardWidget(
                    notes[0].notesEleve, int.parse(notes[0].numNote), num)
                : Container(),
            const SizedBox(
              height: 5.0,
            ),
            (long >= 2)
                ? cardWidget(
                    notes[1].notesEleve, int.parse(notes[1].numNote), num)
                : Container(),
            const SizedBox(
              height: 5.0,
            ),
            (long >= 3)
                ? cardWidget(
                    notes[2].notesEleve, int.parse(notes[2].numNote), num)
                : Container(),
            const SizedBox(
              height: 5.0,
            ),
            (long >= 4)
                ? cardWidget(
                    notes[3].notesEleve, int.parse(notes[3].numNote), num)
                : Container(),
            const SizedBox(
              height: 5.0,
            ),
            (long > 5)
                ? cardWidget(
                    notes[4].notesEleve, int.parse(notes[4].numNote), num)
                : Container(),
            const SizedBox(
              height: 5.0,
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomText(
            " Pas de Notes dans ce Trismetre ",
            color: Colors.red,
            fontWeight: FontWeight.w300,
          ),
        ),
      );
    }
  }

//List<String>? feedNote
  Widget cardWidget(String note, int numNote, int numTrismestre) {
    return Card(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: InkWell(
        onTap: () {
          debugPrint("trismetre $numTrismestre numNote $numNote note $note");
          Navigator.of(context).push(
            SlideRightRoute(
                child: EditNotePage(
                  eleve: element,
                  matiere: choixMatiere,
                  note: note,
                  idTrimestre: numTrismestre,
                  numNote: numNote,
                ),
                page: EditNotePage(
                  eleve: element,
                  matiere: choixMatiere,
                  note: note,
                  idTrimestre: numTrismestre,
                  numNote: numNote,
                ),
                direction: AxisDirection.left),
          );
        },
        child: Container(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomText(
              " $note ",
              tex: TailleText(context).soustitre * 0.8,
              color: tealFonce(),
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  conVert(String s) {
    if (s.length < 2) {
      String v = "0$s";
      s = v;
    }
    return s;
  }
}
