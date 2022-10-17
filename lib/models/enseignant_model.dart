// ignore_for_file: unnecessary_this

class EnseignantModel {
  String? idEns;
  String? nomEns;
  String? prenomEns;
  String? dateNaissance;
  String? phone;

  EnseignantModel(
      {this.idEns,
      this.nomEns,
      this.prenomEns,
      this.dateNaissance,
      this.phone
      });

  EnseignantModel.fromJson(Map<String, dynamic> json) {
    idEns = json['idEns'];
    nomEns = json['nomEns'];
    prenomEns = json['prenomEns'];
    dateNaissance = json['dateNaissance'];
    phone = json['phone'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['idEns'] = this.idEns;
    data['nomEns'] = this.nomEns;
    data['prenomEns'] = this.prenomEns;
    data['dateNaissance'] = this.dateNaissance;
    data['phone'] = this.phone;
    return data;
  }
}
