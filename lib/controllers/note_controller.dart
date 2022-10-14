import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import '../functions/fonctions.dart';
import '../models/note_model.dart';
import '../services/config.dart';

class Notes with ChangeNotifier {
  var data = [];
  bool res = false;

  List<NoteModel> result = [];
  String countNotebyTrimestre = "";
   String getNoteID = "";
  List<String> listNote = [];

  // iste des eleves
  Future<List<NoteModel>> listNoteEleve(
      int id1, int id2, int id3, int id4, int id5) async {
          String lien = await checkLien();
    final client = http.Client();
    final response = await client.get(Uri.parse(
        "$lien${Config.apiKey}${Config.GetNote}/$id1/$id2/$id3/$id4/$id5/"));

    try {
      if (response.body.isNotEmpty) {
        data = json.decode(utf8.decode(response.bodyBytes));

        result = data.map((e) => NoteModel.fromJson(e)).toList();

        debugPrint(" note chargé avec Succes  : ${data.length}");
      } else {
        debugPrint("fectch error");
      }
      notifyListeners();
      // ignore: unused_catch_clause
    } on Exception catch (e) {
      debugPrint("fectch error");
    }

    return result;
  }



  Future<String> countNoteOfTrismetre(
      int id1, int id2, int id3, int id4) async {
          String lien = await checkLien();
    final client = http.Client();
    final response = await client.get(Uri.parse(
        "$lien${Config.apiKey}${Config.GetCountNotesByTrimestre}/$id1/$id2/$id3/$id4"));

    try {
      if (response.body.isNotEmpty) {
        countNotebyTrimestre = json.decode(utf8.decode(response.bodyBytes));
      } else {
        debugPrint("fectch error");
      }
      notifyListeners();
      // ignore: unused_catch_clause
    } on Exception catch (e) {
      debugPrint("fectch error");
    }

    return countNotebyTrimestre;
  }



  Future<String> getNoteOfID(int id1, int id2, int id3, int id4 ,int id5) async {
    final client = http.Client();
      String lien = await checkLien();
    final response = await client.get(Uri.parse(
        "$lien${Config.apiKey}${Config.GetNoteID}/$id1/$id2/$id3/$id4/$id5"));

    try {
      if (response.body.isNotEmpty) {
        getNoteID = json.decode(utf8.decode(response.bodyBytes));
      } else {
        debugPrint("fectch error");
      }
      notifyListeners();
      // ignore: unused_catch_clause
    } on Exception catch (e) {
      debugPrint("fectch error");
    }

    return getNoteID;
  }

  Future<bool> insertNote(String notesEleve, String dateNote, int id1, int id2,
      int id3, int id4, int id5 ) async {
    final client = http.Client();
      String lien = await checkLien();

    final response = await client.post(
        Uri.parse(
            "$lien${Config.apiKey}${Config.InsertNote}/$id1/$id2/$id3/$id4/$id5"),
        body: jsonEncode({
          "notesEleve": double.parse(notesEleve),
          "dateNote": dateNote.toString(),
        }),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Some token"
        });

    try {
      notifyListeners();


      // ignore: unrelated_type_equality_checks
      if (response.body.contains("true")) {
        debugPrint("hello true");
        return true;
      } else {
        return false;
      }
    } on Exception catch (e) {
      debugPrint("fectch error $e");
    }
    // ignore: unused_catch_clause
    return res;
  }




  Future<bool> editNote(String notesEleve, String dateNote, int idTrimestre,int numNote,int idNote) async {
    final client = http.Client();
      String lien = await checkLien();

    final response = await client.put(
        Uri.parse(
            "$lien${Config.apiKey}${Config.EditNote}/$idNote"),
        body: jsonEncode({
          "notesEleve": double.parse(notesEleve),
          "dateNote": dateNote.toString(),
          "numNote": numNote,
          "idTrimestre": idTrimestre
        }),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Some token"
        });

    try {
      notifyListeners();

      // ignore: unrelated_type_equality_checks
      if (response.body.contains("true")) {
        debugPrint("hello true");
        return true;
      } else {
        return false;
      }
    } on Exception catch (e) {
      debugPrint("fectch error $e");
    }
    // ignore: unused_catch_clause
    return res;
  }


}
