import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import '../functions/fonctions.dart';
import '../services/config.dart';

class Moyenne with ChangeNotifier {
  String data = "";
  bool res = false;

  String getNoteID = "";
  late String getMoyenne;

  // iste des eleves
  Future<String?> moyenneEleve(
      {required int idEleve,
      required int idTri,
      required int idMat,
      required int idAnnee,
      required int idClasse}) async {
    String lien = await checkLien();
    final client = http.Client();
    final response = await client.get(Uri.parse(
        "$lien${Config.apiKey}${Config.GetMoyenne}/$idEleve/$idTri/$idMat/$idAnnee/$idClasse/"));

    try {
      if (response.body.isNotEmpty) {
        data = json.decode(utf8.decode(response.bodyBytes)).toString();

        if (data != "null") {
          getMoyenne = data;
        } else {
          return "";
        }

        debugPrint("Moyenne chargé avec Succes  : ${data.length}");
      } else {
        debugPrint("fectch error");
      }
      notifyListeners();
      // ignore: unused_catch_clause
    } on Exception catch (e) {
      debugPrint("fectch error");
    }

    return getMoyenne;
  }

  Future<bool> insertMoyenne(
      String moyenneEleve, int id1, int id2, int id3, int id4, int id5) async {
    final client = http.Client();
    String lien = await checkLien();

    final response = await client.post(
        Uri.parse(
            "$lien${Config.apiKey}${Config.InsertMoyenne}/$id1/$id2/$id3/$id4/$id5"),
        body: jsonEncode({
          "moyenneEleve": double.parse(moyenneEleve),
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

  Future<bool> editNote(String notesEleve, String dateNote, int idTrimestre,
      int numNote, int idNote) async {
    final client = http.Client();
    String lien = await checkLien();

    final response = await client
        .put(Uri.parse("$lien${Config.apiKey}${Config.EditNote}/$idNote"),
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
