import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:sysgesco/models/classe_model.dart';
import 'dart:async';

import '../functions/fonctions.dart';
import '../services/config.dart';

class Classe with ChangeNotifier {
  var data = [];
  bool res = false;
  List<ClasseModel> result = [];

  // iste des eleves
  Future<List<ClasseModel>> listClasse({String? query}) async {
    String lien = await checkLien();
    final client = http.Client();
    final response =
        await client.get(Uri.parse(lien + Config.apiKey + Config.GetAllClasse));

    try {
      if (response.body.isNotEmpty) {
        data = json.decode(utf8.decode(response.bodyBytes));
        result = data.map((e) => ClasseModel.fromJson(e)).toList();

        debugPrint(" Classe chargé avec Succes .longueur : ${result.length}");
      } else {
        debugPrint("fectch error");
      }

      if (query != null) {
        query = query.toLowerCase();
        result = result
            .where((element) =>
                element.libelleClasse.toString().toLowerCase().contains(query!))
            .toList();
      }
      notifyListeners();
      // ignore: unused_catch_clause
    } on Exception catch (e) {
      debugPrint("fectch error");
    }

    return result;
  }

  Future<bool> insertClasse(ClasseModel classe) async {
    String lien = await checkLien();
    final client = http.Client();

    final response = await client
        .post(Uri.parse("$lien${Config.apiKey}${Config.InsertClasse}"),
            body: jsonEncode({
              "libelleClasse": classe.libelleClasse,
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

  Future<bool> editClasse(ClasseModel classe) async {
    final client = http.Client();
    String lien = await checkLien();

    final response = await client.put(
        Uri.parse(
            "$lien${Config.apiKey}${Config.EditClasse}/${classe.idClasse}"),
        body: jsonEncode({
          "libelleClasse": classe.libelleClasse,
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

  Future<bool> deleteClasse(ClasseModel classe) async {
    final client = http.Client();
    String lien = await checkLien();

    final response = await client.put(Uri.parse(
        "$lien${Config.apiKey}${Config.DeleteClasse}/${classe.idClasse}"));

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
