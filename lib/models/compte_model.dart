class CompteModel {
  late String username;
  late String password;
  late int role;

  CompteModel(
      {required this.username, required this.password, required this.role});

  Map<String, dynamic> toMap() {
    return {'username': username, 'password': password, 'role': role};
  }

  factory CompteModel.fromMap(Map<String, dynamic> map) => CompteModel(
      username: map['username'], password: map['password'], role: map['role']);
}
