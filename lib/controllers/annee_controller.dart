import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:sysgesco/functions/fonctions.dart';
import 'package:sysgesco/models/annee_model.dart';
import 'dart:async';

import '../services/config.dart';

class Annee with ChangeNotifier {
  var data = [];
  bool res = false;
  List<AnneeModel> result = [];

  String idAnne = "";

  // liste des annees
  Future<List<AnneeModel>> listAnnee() async {
    String lien = await checkLien();
    final client = http.Client();
    var response =
        await client.get(Uri.parse(lien + Config.apiKey + Config.GetAnnee));

    try {
      if (response.body.isNotEmpty) {
        data = json.decode(response.body);
        result = data.map((e) => AnneeModel.fromJson(e)).toList();

        debugPrint(" longueur : ${result.length}");
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

  Future<String> lastAnneeID() async {
    String lien = await checkLien();
    final client = http.Client();
    final response =
        await client.get(Uri.parse(lien + Config.apiKey + Config.GetlastAnnee));

    try {
      if (response.body.isNotEmpty) {
        idAnne = json.decode(response.body);
      } else {
        debugPrint("fectch error");
      }
      notifyListeners();
      // ignore: unused_catch_clause
    } on Exception catch (e) {
      debugPrint("fectch error");
    }

    return idAnne;
  }

  Future<bool> insertAnnee(AnneeModel annee) async {
    String lien = await checkLien();
    final client = http.Client();

    final response = await client
        .post(Uri.parse("$lien${Config.apiKey}${Config.InsertAnnee}"),
            body: jsonEncode({
              "libelleAnnee": annee.libelleAnnee,
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

  Future<bool> editAnnee(AnneeModel annee) async {
    final client = http.Client();
    String lien = await checkLien();

    final response = await client.put(
        Uri.parse("$lien${Config.apiKey}${Config.EditAnnee}/${annee.idAnnee}"),
        body: jsonEncode({
          "libelleAnnee": annee.libelleAnnee,
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

  Future<bool> deleteAnnee(AnneeModel annee) async {
    final client = http.Client();
    String lien = await checkLien();

    final response = await client.put(Uri.parse(
        "$lien${Config.apiKey}${Config.DeleteAnnee}/${annee.idAnnee}"));

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
