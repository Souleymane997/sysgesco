import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:sysgesco/functions/fonctions.dart';
import 'package:sysgesco/models/annee_model.dart';
import 'dart:async';

import '../services/config.dart';

class Annee with ChangeNotifier {
  var data = [];

  List<AnneeModel> result = [];

  String idAnne = "";
 

  // liste des annees
  Future<List<AnneeModel>> listAnnee() async {
    String lien = await checkLien();
    final client = http.Client();
    var response = await client
        .get(Uri.parse(lien + Config.apiKey + Config.GetAnnee));

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
    final response = await client
        .get(Uri.parse(lien + Config.apiKey + Config.GetlastAnnee));

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
}
