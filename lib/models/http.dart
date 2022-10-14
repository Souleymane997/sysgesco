class HttpModel {
  int? idHttp;
  late String cheminHttp;

  HttpModel({this.idHttp, required this.cheminHttp});

  Map<String, dynamic> toMap() {
    return {'idHttp': idHttp, 'cheminHttp': cheminHttp};
  }

  factory HttpModel.fromMap(Map<String, dynamic> map) =>
      HttpModel(idHttp: map['idHttp'], cheminHttp: map['cheminHttp']);
}
