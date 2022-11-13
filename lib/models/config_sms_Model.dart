// ignore_for_file: file_names

class SmsModel {
  int? idconfig;
  late String poste;
  late String lycee;

  SmsModel({this.idconfig,required this.poste, required this.lycee});

  Map<String, dynamic> toMap() {
    return {'idconfig':idconfig,'poste': poste, 'lycee': lycee};
  }

  factory SmsModel.fromMap(Map<String, dynamic> map) =>
      SmsModel(idconfig: map['idconfig'],poste: map['poste'], lycee: map['lycee']);
}
