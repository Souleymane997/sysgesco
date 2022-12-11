class MoyenneModel {
  int? idMoyenne;
  late int idEleve;
  late int idTrimestre;
  late int idClasse;
  late int idAnnee;
  late String moyenneEleve;

  MoyenneModel(
      {this.idMoyenne,
      required this.idEleve,
      required this.idTrimestre,
      required this.moyenneEleve,
      required this.idClasse,
      required this.idAnnee});

  MoyenneModel.fromJson(Map<String, dynamic> json) {
    idMoyenne = json['idMoyenne'];
    idEleve = json['idEleve'];
    idTrimestre = json['idTrimestre'];
    idAnnee = json['idAnnee'];
    idClasse = json['idClasse'];
    moyenneEleve = json['moyenneEleve'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idMoyenne'] = idMoyenne;
    data['idEleve'] = idEleve;
    data['idTrimestre'] = idTrimestre;
    data['idAnnee'] = idAnnee;
    data['idClasse'] = idClasse;
    data['moyenneEleve'] = moyenneEleve;

    return data;
  }
}
