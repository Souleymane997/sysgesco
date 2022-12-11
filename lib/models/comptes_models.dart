class ComptesModels {
  int? idCompte;
  late String username;
  late String password;
  late int role;

  ComptesModels(
      {this.idCompte,required this.username, required this.password, required this.role});

  ComptesModels.fromJson(Map<String, dynamic> json) {
    idCompte = int.parse(json['idCompte']) ;
    username = json['username'];
    password = json['password'];
    role = int.parse(json['role']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idCompte'] = idCompte;
    data['username'] = username;
    data['password'] = password;
    data['role '] = role;

    return data;
  }
}
