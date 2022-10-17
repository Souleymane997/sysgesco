class JourModel {
  String? idJour;
  String? libelleJour;

  JourModel({this.idJour, this.libelleJour});

  JourModel.fromJson(Map<String, dynamic> json) {
    idJour = json['idJour'];
    libelleJour = json['libelleJour'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idJour '] = idJour;
    data['libelleJour '] = libelleJour;

    return data;
  }
}
