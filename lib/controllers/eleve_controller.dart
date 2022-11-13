import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import '../functions/fonctions.dart';
import '../models/eleve_model.dart';
import '../services/config.dart';

class Eleve with ChangeNotifier {
  var data = [];

  List<ElevesModel> result = [];
  String countEleves = "";
  bool res = false;
  String idEleve = "";

  // iste des eleves
  Future<List<ElevesModel>> listEleve(
      {required int id1, required int id2, String? query}) async {
    String lien = await checkLien();
    final client = http.Client();
    final response = await client
        .get(Uri.parse("$lien${Config.apiKey}${Config.GetAllEleve}/$id1/$id2"));

    try {
      if (response.body.isNotEmpty) {
        data = json.decode(utf8.decode(response.bodyBytes));
        result = data.map((e) => ElevesModel.fromJson(e)).toList();

        debugPrint(" longueur : ${result.length}");
      } else {
        debugPrint("fectch error");
      }

      if (query != null) {
        query = query.toLowerCase();
        result = result
            .where((element) =>
                element.nomEleve.toString().toLowerCase().contains(query!) ||
                element.prenomEleve.toString().toLowerCase().contains(query))
            .toList();
      }
      notifyListeners();
      // ignore: unused_catch_clause
    } on Exception catch (e) {
      debugPrint("fectch error");
    }

    return result;
  }

  Future<String> countEleve(int id1, int id2) async {
    String lien = await checkLien();
    final client = http.Client();
    final response = await client.get(
        Uri.parse("$lien${Config.apiKey}${Config.GetCountEleve}/$id1/$id2"));

    try {
      if (response.body.isNotEmpty) {
        countEleves = json.decode(utf8.decode(response.bodyBytes));
      } else {
        debugPrint("fectch error");
      }
      notifyListeners();
      // ignore: unused_catch_clause
    } on Exception catch (e) {
      debugPrint("fectch error");
    }

    return countEleves;
  }

  Future<bool> insertEleve(ElevesModel eleve) async {
    String lien = await checkLien();
    final client = http.Client();

    final response = await client
        .post(Uri.parse("$lien${Config.apiKey}${Config.InsertEleve}"),
            body: jsonEncode({
              "nomEleve": eleve.nomEleve,
              "prenomEleve": eleve.prenomEleve,
              "dateNaissance": eleve.dateNaissance,
              "matriculeEleve": eleve.matriculeEleve,
              "phoneParent": eleve.phoneParent
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

  Future<bool> insertLien(int id1, int id2, int id3) async {
    String lien = await checkLien();
    final client = http.Client();

    final response = await client.post(
        Uri.parse("$lien${Config.apiKey}${Config.InsertLien}"),
        body: jsonEncode({"idEleve": id1, "idClasse": id2, "idAnnee": id3}),
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

  Future<String> lastEleve() async {
    String lien = await checkLien();
    final client = http.Client();
    final response =
        await client.get(Uri.parse(lien + Config.apiKey + Config.GetLastEleve));

    try {
      if (response.body.isNotEmpty) {
        idEleve = json.decode(response.body);
      } else {
        debugPrint("fectch error");
      }
      notifyListeners();
      // ignore: unused_catch_clause
    } on Exception catch (e) {
      debugPrint("fectch error");
    }

    return idEleve;
  }

  Future editEleve(ElevesModel eleve) async {
    String lien = await checkLien();
    final client = http.Client();

    final response = await client.put(
        Uri.parse("$lien${Config.apiKey}${Config.EditEleve}/${eleve.idEleve}"),
        body: jsonEncode({
          "nomEleve": eleve.nomEleve,
          "prenomEleve": eleve.prenomEleve,
          "dateNaissance": eleve.dateNaissance,
          "matriculeEleve": eleve.matriculeEleve,
          "phoneParent": eleve.phoneParent
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

  // iste des eleves
  Future<ElevesModel?> oneEleve({required int id1}) async {
    String lien = await checkLien();
    final client = http.Client();
    final response = await client
        .get(Uri.parse("$lien${Config.apiKey}${Config.GetEleve}/$id1"));

    try {
      if (response.body.isNotEmpty) {
        data = json.decode(utf8.decode(response.bodyBytes));
        result = data.map((e) => ElevesModel.fromJson(e)).toList();

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

  // iste des eleves
  Future<bool> deleteEleve({required int id}) async {
    String lien = await checkLien();
    final client = http.Client();
    final response = await client
        .get(Uri.parse("$lien${Config.apiKey}${Config.DeleteEleve}/$id"));

    try {
      notifyListeners();
      // ignore: unrelated_type_equality_checks
      if (response.body.contains("true")) {
        debugPrint("hello true");
        return true;
      } else {
        return false;
      }
      // ignore: unused_catch_clause
    } on Exception catch (e) {
      debugPrint("fectch error");
    }

    return res;
  }
}
