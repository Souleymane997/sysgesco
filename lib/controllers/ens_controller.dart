import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:sysgesco/models/enseignant_model.dart';
import 'dart:async';

import '../functions/fonctions.dart';
import '../services/config.dart';

class Enseignant with ChangeNotifier {
  var data = [];

  List<EnseignantModel> result = [];
  String countEnseignant = "";
  bool res = false;
  String idEns = "";

  // iste des eleves
  Future<List<EnseignantModel>> listEns({String? query}) async {
    String lien = await checkLien();
    final client = http.Client();
    final response =
        await client.get(Uri.parse("$lien${Config.apiKey}${Config.GetAllEns}"));

    try {
      if (response.body.isNotEmpty) {
        data = json.decode(utf8.decode(response.bodyBytes));
        result = data.map((e) => EnseignantModel.fromJson(e)).toList();

        debugPrint(" longueur : ${result.length}");
      } else {
        debugPrint("fectch error");
      }

      if (query != null) {
        query = query.toLowerCase();
        result = result
            .where((element) =>
                element.nomEns.toString().toLowerCase().contains(query!) ||
                element.prenomEns.toString().toLowerCase().contains(query))
            .toList();
      }
      notifyListeners();
      // ignore: unused_catch_clause
    } on Exception catch (e) {
      debugPrint("fectch error");
    }

    return result;
  }

  Future<bool> insertEns(EnseignantModel ens) async {
    String lien = await checkLien();
    final client = http.Client();

    final response =
        await client.post(Uri.parse("$lien${Config.apiKey}${Config.InsertEns}"),
            body: jsonEncode({
              "nomEns": ens.nomEns,
              "prenomEns": ens.prenomEns,
              "dateNaissance": ens.dateNaissance,
              "phone": ens.phone
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
