class TrimestreModel {
  String? idTrimestre;
  String? libelleTrimestre;

  TrimestreModel({this.idTrimestre, this.libelleTrimestre});

  TrimestreModel.fromJson(Map<String, dynamic> json) {
    idTrimestre = json['idTrimestre'];
    libelleTrimestre = json['libelleTrimestre'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idTrimestre'] = idTrimestre;
    data['libelleTrimestre'] = libelleTrimestre;

    return data;
  }
}
