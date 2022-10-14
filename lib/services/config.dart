// ignore_for_file: constant_identifier_names



class Config {
  static const String appName = "SYSGESCO";

  static const apiKey = "RDT563S45E4DF5G6YKOP451"; // ";

    static const String apiURL = "http://192.168.43.139/Api/" ;

  //* eleves

  static const String GetAllEleve = "/Eleve/getAllEleve";
  static const String GetCountEleve = "/Eleve/getCountEleve";
  static const String GetLastEleve = "/Eleve/getLastEleve";
  static const String InsertEleve = "/Eleve/insertEleve";
  static const String InsertLien = "/Eleve/insertLien";

  //*

  //* classe

  static const String GetAllClasse = "/Classe/getAllClasse";

  //*

  //* matieres

  static const String GetMatiere = "/Matiere/getMatiere";

  //*

  //* annee

  static const String GetAnnee = "/Annee/getAnnee";
  static const String GetlastAnnee = "/Annee/getLastAnnee";

  //*

  //* trismetre

  static const String GetTrimestre = "/Trimestre/getTrimestre";

  //*

  //* notes

  static const String GetNote = "/Note/getNote";
  static const String GetCountNotesByTrimestre =
      "/Note/getCountNoteByTrimestre";
  static const String InsertNote = "/Note/insertNote";
  static const String EditNote = "/Note/editNote";
  static const String GetNoteID = "/Note/getNoteID";

  //*

}
