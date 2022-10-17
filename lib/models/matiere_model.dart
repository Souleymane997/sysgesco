

class MatiereModel {
  String? idMatieres;
  String? libelleMatieres;

  MatiereModel({this.idMatieres, this.libelleMatieres});

  MatiereModel.fromJson(Map<String, dynamic> json) {
    idMatieres = json['idMatieres'];
    libelleMatieres = json['libelleMatieres'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idMatieres'] = idMatieres;
    data['libelleMatieres'] = libelleMatieres;

    return data;
  }
}
