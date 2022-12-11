// ignore_for_file: constant_identifier_names

class Config {
  static const String appName = "SYSGESCO";

  static const apiKey = "RDT563S45E4DF5G6YKOP451"; // ";
  static const String apiURL = "http://192.168.43.139/Api/";

  //* eleves

  static const String GetAllEleve = "/Eleve/getAllEleve";
  static const String GetCountEleve = "/Eleve/getCountEleve";
  static const String GetLastEleve = "/Eleve/getLastEleve";
  static const String InsertEleve = "/Eleve/insertEleve";
  static const String InsertLien = "/Eleve/insertLien";
  static const String EditEleve = "/Eleve/editEleve";
  static const String GetEleve = "/Eleve/getEleve";
  static const String DeleteEleve = "/Eleve/deleteEleve";

  //*

  //* classe

  static const String GetAllClasse = "/Classe/getAllClasse";
  static const String InsertClasse = "/Classe/insertClasse";
  static const String EditClasse = "/Classe/editClasse";
  static const String DeleteClasse = "/Classe/deleteClasse";

  //*

  //* matieres

  static const String GetMatiere = "/Matiere/getMatiere";
  static const String InsertMatiere = "/Matiere/insertMatiere";
  static const String EditMatiere = "/Matiere/editMatiere";
  static const String DeleteMatiere = "/Matiere/deleteMatiere";

  //*

  //* annee

  static const String GetAnnee = "/Annee/getAnnee";
  static const String GetlastAnnee = "/Annee/getLastAnnee";
  static const String InsertAnnee = "/Annee/insertAnnee";
  static const String EditAnnee = "/Annee/editAnnee";
  static const String DeleteAnnee = "/Annee/deleteAnnee";

  //*

  //* trismetre

  static const String GetTrimestre = "/Trimestre/getTrimestre";
  static const String InsertTrimestre = "/Trimestre/insertTrimestre";
  static const String EditTrimestre = "/Trimestre/editTrimestre";
  static const String DeleteTrimestre = "/Trimestre/deleteTrimestre";

  //*

  //* notes

  static const String GetNote = "/Note/getNote";
  static const String GetCountNotesByTrimestre =
      "/Note/getCountNoteByTrimestre";
  static const String InsertNote = "/Note/insertNote";
  static const String EditNote = "/Note/editNote";
  static const String GetNoteID = "/Note/getNoteID";

  //*

  //* enseignant

  static const String GetAllEns = "/Enseignant/getAllEns";
  static const String InsertEns = "/Enseignant/insertEns";
  static const String EditEns = "/Enseignant/editEns";
  static const String DeleteEns = "/Enseignant/deleteEns";

  //*

  //* seance

  static const String GetSeanceByClasse = "/Seance/getSeanceByClasse";
  static const String GetSeanceByProf = "/Seance/getSeanceByProf";
  static const String InsertSeance = "/Seance/insertSeance";

  //*

  //* jour

  static const String GetJour = "/Jour/getJour";
  static const String InsertJour = "/Jour/insertJour";
  static const String EditJour = "/Jour/editJour";
  static const String DeleteJour = "/Jour/deleteJour";

  //*

  //* notes

  static const String GetMoyenne = "/Moyenne/getMoyenne";
  static const String InsertMoyenne = "/Moyenne/insertMoyenne";
  static const String EditMoyenne = "/Moyenne/editMoyenne";

  //*

  //* comptes

  static const String GetCompte = "/Compte/getCompte";
  static const String GetAllCompte = "/Compte/getAllCompte";
  static const String InsertCompte = "/Compte/insertCompte";
  static const String EditCompte = "/Compte/editCompte";
  static const String DeleteCompte = "/Compte/deleteCompte";

  //*

  //

}
