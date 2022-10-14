// ignore_for_file: unnecessary_this

class ClasseModel {
  String? idClasse;
  String? libelleClasse;

  ClasseModel({this.idClasse, this.libelleClasse});

  ClasseModel.fromJson(Map<String, dynamic> json) {
    idClasse = json['idClasse'];
    libelleClasse = json['libelleClasse'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idClasse'] = this.idClasse;
    data['libelleClasse'] = this.libelleClasse;

    return data;
  }
}
