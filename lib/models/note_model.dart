class NoteModel {
 late String numNote;
  late String notesEleve;

  NoteModel({required this.numNote, required this.notesEleve});

  NoteModel.fromJson(Map<String, dynamic> json) {
    numNote = json['numNote'];
    notesEleve = json['notesEleve'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['numNote'] = numNote;
    data['notesEleve'] = notesEleve;

    return data;
  }
}
