import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:sysgesco/models/seance_model.dart';
import 'dart:async';

import '../functions/fonctions.dart';
import '../services/config.dart';

class Seance with ChangeNotifier {
  var data = [];

  List<SeanceModel> result = [];
  bool res = false;

  // iste des eleves
  Future<List<SeanceModel>> listSeance(int id1, int id2, int id3) async {
    String lien = await checkLien();
    final client = http.Client();
    final response = await client.get(Uri.parse(
        "$lien${Config.apiKey}${Config.GetSeanceByClasse}/$id1/$id2/$id3"));

    try {
      if (response.body.isNotEmpty) {
        data = json.decode(utf8.decode(response.bodyBytes));
        result = data.map((e) => SeanceModel.fromJson(e)).toList();

        debugPrint(" Classe chargé avec Succes .longueur : ${result.length}");
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

  Future<List<SeanceModel>> listSeanceProf(int id1, int id2, int id3) async {
    String lien = await checkLien();
    final client = http.Client();
    final response = await client.get(Uri.parse(
        "$lien${Config.apiKey}${Config.GetSeanceByProf}/$id1/$id2/$id3"));

    try {
      if (response.body.isNotEmpty) {
        data = json.decode(utf8.decode(response.bodyBytes));
        result = data.map((e) => SeanceModel.fromJson(e)).toList();

        debugPrint(" Classe chargé avec Succes .longueur : ${result.length}");
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

  Future<bool> insertSeance(SeanceModel seance) async {
    String lien = await checkLien();
    final client = http.Client();

    final response = await client
        .post(Uri.parse("$lien${Config.apiKey}${Config.InsertSeance}"),
            body: jsonEncode({
              "idClasse": seance.idClasse,
              "idJour": seance.idJour,
              "idAnnee": seance.idAnnee,
              "idEns": seance.idEns,
              "idMatieres": seance.idMatieres,
              "heureDebut": seance.heureDebut,
              "heureFin": seance.heureFin
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
