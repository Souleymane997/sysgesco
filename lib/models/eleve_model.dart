// ignore_for_file: unnecessary_this

class ElevesModel {
  String? idEleve;
  String? nomEleve;
  String? prenomEleve;
  String? matriculeEleve;
  String? dateNaissance;
  String? phoneParent;

  ElevesModel(
      {this.idEleve,
      this.nomEleve,
      this.prenomEleve,
      this.dateNaissance,
      this.phoneParent,
      this.matriculeEleve});

  ElevesModel.fromJson(Map<String, dynamic> json) {
    idEleve = json['idEleve'];
    nomEleve = json['nomEleve'];
    prenomEleve = json['prenomEleve'];
    dateNaissance = json['dateNaissance'];
    matriculeEleve = json['matriculeEleve'];
    phoneParent = json['phoneParent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idEleve'] = this.idEleve;
    data['nomEleve'] = this.nomEleve;
    data['prenomEleve'] = this.prenomEleve;
    data['dateNaissance'] = this.dateNaissance;
    data['matriculeEleve'] = this.matriculeEleve;
    data['phoneParent'] = this.phoneParent;
    return data;
  }
}
