import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:sysgesco/models/trimestre_model.dart';
import 'dart:async';

import '../functions/fonctions.dart';
import '../services/config.dart';

class Trimestre with ChangeNotifier {
  var data = [];

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
}
