import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:sysgesco/models/jour_model.dart';
import 'dart:async';
import '../functions/fonctions.dart';
import '../services/config.dart';

class Jour with ChangeNotifier {
  var data = [];

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
}
