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

  // liste des Matieres
  Future<List<MatiereModel>> listMatiere() async {
      String lien = await checkLien();
    final client = http.Client();
    final response = await client
        .get(Uri.parse(lien + Config.apiKey + Config.GetMatiere));

    try {
      if (response.body.isNotEmpty) {
        data = json.decode( utf8.decode(response.bodyBytes));
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
}
