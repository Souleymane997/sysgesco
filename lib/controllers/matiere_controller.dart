import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:sysgesco/models/matiere_model.dart';
import 'dart:async';
import '../functions/fonctions.dart';
import '../services/config.dart';

class Matiere with ChangeNotifier {
  var data = [];
  List<MatiereModel> result = [];
  bool res = false;

  // liste des Matieres
  Future<List<MatiereModel>> listMatiere() async {
    String lien = await checkLien();
    final client = http.Client();
    final response =
        await client.get(Uri.parse(lien + Config.apiKey + Config.GetMatiere));

    try {
      if (response.body.isNotEmpty) {
        data = json.decode(utf8.decode(response.bodyBytes));
        result = data.map((e) => MatiereModel.fromJson(e)).toList();
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

  Future<bool> insertMatiere(MatiereModel matiere) async {
    String lien = await checkLien();
    final client = http.Client();

    final response = await client
        .post(Uri.parse("$lien${Config.apiKey}${Config.InsertMatiere}"),
            body: jsonEncode({
              "libelleMatieres": matiere.libelleMatieres,
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

  Future<bool> editMatiere(MatiereModel matiere) async {
    final client = http.Client();
    String lien = await checkLien();

    final response = await client.put(
        Uri.parse(
            "$lien${Config.apiKey}${Config.EditMatiere}/${matiere.idMatieres}"),
        body: jsonEncode({
          "libelleMatieres": matiere.libelleMatieres,
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

  Future<bool> deleteMatiere(MatiereModel matiere) async {
    final client = http.Client();
    String lien = await checkLien();

    final response = await client.put(Uri.parse(
        "$lien${Config.apiKey}${Config.DeleteMatiere}/${matiere.idMatieres}"));

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
