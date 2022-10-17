class SeanceModel {
  String? idSeance;
  String? idClasse;
  String? idJour;
  String? idAnnee;
  String? idEns;
  String? idMatieres;
  String? heureDebut;
  String? heureFin;

  SeanceModel(
      {this.idSeance,
      this.idClasse,
      this.idJour,
      this.idAnnee,
      this.idEns,
      this.idMatieres,
      this.heureDebut,
      this.heureFin});

  SeanceModel.fromJson(Map<String, dynamic> json) {
    idSeance = json['idSeance'];
    idClasse = json['idClasse'];
    idJour = json['idJour'];
    idAnnee = json['idAnnee'];
    idEns = json['idEns'];
    idMatieres = json['idMatieres'];
    heureDebut = json['heureDebut'];
    heureFin = json['heureFin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idSeance'] = idSeance;
    data['idClasse'] = idClasse;
    data['idJour'] = idJour;
    data['idAnnee'] = idAnnee;
    data['idEns'] = idEns;
    data['idMatieres'] = idMatieres;
    data['heureDebut'] = heureDebut;
    data['heureFin'] = heureFin;
    return data;
  }
}

