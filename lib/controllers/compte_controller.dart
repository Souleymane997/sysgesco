import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import '../functions/fonctions.dart';
import '../models/comptes_models.dart';
import '../services/config.dart';

class Comptes with ChangeNotifier {
  var data = [];

  List<ComptesModels> result = [];
  bool res = false;

  Future<List<ComptesModels>> listCompte() async {
    String lien = await checkLien();
    final client = http.Client();
    final response = await client
        .get(Uri.parse("$lien${Config.apiKey}${Config.GetAllCompte}"));

    try {
      if (response.body.isNotEmpty) {
        data = json.decode(utf8.decode(response.bodyBytes));
        result = data.map((e) => ComptesModels.fromJson(e)).toList();

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

  Future insertComptes(ComptesModels compte) async {
    String lien = await checkLien();
    final client = http.Client();

    final response = await client
        .post(Uri.parse("$lien${Config.apiKey}${Config.InsertCompte}"),
            body: jsonEncode({
              "username": compte.username,
              "password": compte.password,
              "role": compte.role.toString()
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

  Future editComptes(ComptesModels compte) async {
    String lien = await checkLien();
    final client = http.Client();

    final response = await client.put(
        Uri.parse(
            "$lien${Config.apiKey}${Config.EditCompte}/${compte.idCompte.toString()}"),
        body: jsonEncode({
          "username": compte.username,
          "password": compte.password,
          "role": compte.role.toString()
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

  Future<ComptesModels?> oneCompte(
      {required String username, required String password}) async {
    String lien = await checkLien();
    final client = http.Client();
    final response = await client.get(Uri.parse(
        "$lien${Config.apiKey}${Config.GetCompte}/$username/$password"));

    try {
      if (response.body.isNotEmpty) {
        data = json.decode(utf8.decode(response.bodyBytes));
        result = data.map((e) => ComptesModels.fromJson(e)).toList();
        debugPrint(" longueur : ${result.length}");
      } else {
        debugPrint("fectch error");
      }

      notifyListeners();
      // ignore: unused_catch_clause
    } on Exception catch (e) {
      debugPrint("fectch error");
    }

    if (result.isNotEmpty) {
      return result.first;
    }

    return null;
  }

  Future<bool> deleteComptes(ComptesModels elem) async {
    final client = http.Client();
    String lien = await checkLien();

    final response = await client
        .delete(Uri.parse("$lien${Config.apiKey}${Config.DeleteCompte}/${elem.idCompte}"));

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
