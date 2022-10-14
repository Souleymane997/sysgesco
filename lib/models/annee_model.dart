
class AnneeModel {
  String? idAnnee;
  String? libelleAnnee;

 AnneeModel({this.idAnnee, this.libelleAnnee});

  AnneeModel.fromJson(Map<String, dynamic> json) {
    idAnnee = json['idAnnee'];
    libelleAnnee = json['libelleAnnee'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idAnnee'] = idAnnee;
    data['libelleAnnee'] = libelleAnnee;

    return data;
  }
}