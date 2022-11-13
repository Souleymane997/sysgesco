import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:sysgesco/models/jour_model.dart';
import 'dart:async';
import '../functions/fonctions.dart';
import '../services/config.dart';

class Jour with ChangeNotifier {
  var data = [];
  bool res = false;
  List<JourModel> result = [];

  // liste des Matieres
  Future<List<JourModel>> listJour() async {
    String lien = await checkLien();
    final client = http.Client();
    final response =
        await client.get(Uri.parse(lien + Config.apiKey + Config.GetJour));

    try {
      if (response.body.isNotEmpty) {
        data = json.decode(utf8.decode(response.bodyBytes));
        result = data.map((e) => JourModel.fromJson(e)).toList();
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

  Future<bool> insertJour(JourModel jour) async {
    String lien = await checkLien();
    final client = http.Client();

    final response = await client
        .post(Uri.parse("$lien${Config.apiKey}${Config.InsertJour}"),
            body: jsonEncode({
              "libelleJour": jour.libelleJour,
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

  Future<bool> editJour(JourModel jour) async {
    final client = http.Client();
    String lien = await checkLien();

    final response = await client.put(
        Uri.parse("$lien${Config.apiKey}${Config.EditJour}/${jour.idJour}"),
        body: jsonEncode({
          "libelleJour": jour.libelleJour,
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

  Future<bool> deleteJour(JourModel jour) async {
    final client = http.Client();
    String lien = await checkLien();

    final response = await client.put(
        Uri.parse("$lien${Config.apiKey}${Config.DeleteJour}/${jour.idJour}"));

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
