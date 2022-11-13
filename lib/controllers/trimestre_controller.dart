import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:sysgesco/models/trimestre_model.dart';
import 'dart:async';

import '../functions/fonctions.dart';
import '../services/config.dart';

class Trimestre with ChangeNotifier {
  var data = [];
  bool res = false;
  List<TrimestreModel> result = [];

  // iste des eleves
  Future<List<TrimestreModel>> listTrimestre() async {
    final client = http.Client();
    String lien = await checkLien();
    final response =
        await client.get(Uri.parse(lien + Config.apiKey + Config.GetTrimestre));

    try {
      if (response.body.isNotEmpty) {
        data = json.decode(utf8.decode(response.bodyBytes));
        result = data.map((e) => TrimestreModel.fromJson(e)).toList();

        debugPrint(
            " trimestre chargé avec Succes .longueur : ${result.length}");
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

  Future<bool> insertTrimestre(TrimestreModel tri) async {
    String lien = await checkLien();
    final client = http.Client();

    final response = await client
        .post(Uri.parse("$lien${Config.apiKey}${Config.InsertTrimestre}"),
            body: jsonEncode({
              "libelleTrimestre": tri.libelleTrimestre,
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

  Future<bool> editTrimestre(TrimestreModel tri) async {
    final client = http.Client();
    String lien = await checkLien();
    final response = await client.put(
        Uri.parse("$lien${Config.apiKey}${Config.EditTrimestre}/${tri.idTrimestre}"),
        body: jsonEncode({
          "libelleTrimestre": tri.libelleTrimestre,
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

  Future<bool> deleteTrimestre(TrimestreModel tri) async {
    final client = http.Client();
    String lien = await checkLien();

    final response = await client.put(Uri.parse(
        "$lien${Config.apiKey}${Config.DeleteTrimestre}/${tri.idTrimestre}"));

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
