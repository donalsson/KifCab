import 'dart:convert';

import 'dart:ffi';

class UserMod {
  String id_compte;
  String nom;
  String prenom;
  String email;
  String telephone;
  String date_naissance;
  String sexe;
  String localisation;
  String photo;
  String cni;
  String permis;
  String mot_de_passe;
  String description;
  String postulat;
  String date_creation;
  String type;
  String active;
  String publie;
  String admin;
  String profil;
  String flotte;
  String latitude;
  String longitude;

  UserMod(
    String id_compte,
    String nom,
    String prenom,
    String email,
    String telephone,
    String date_naissance,
    String active,
    String localisation,
    String date_creation,
    String sexe,
    String photo,
    String cni,
    String permis,
    String mot_de_passe,
    String description,
    String postulat,
    String type,
    String publie,
    String admin,
    String profil,
    String flotte,
    String latitude,
    String longitude,
  ) {
    this.id_compte = id_compte;
    this.nom = nom;
    this.telephone = telephone;
    this.date_naissance = date_naissance;
    this.prenom = prenom;
    this.email = email;
    this.active = active;
    this.localisation = localisation;
    this.date_creation = date_creation;
    this.sexe = sexe;
    this.photo = photo;
    this.cni = cni;
    this.permis = permis;
    this.mot_de_passe = mot_de_passe;
    this.description = description;
    this.postulat = postulat;
    this.type = type;
    this.publie = publie;
    this.admin = admin;
    this.nom = nom;
    this.flotte = flotte;
    this.profil = profil;
    this.latitude = latitude;
    this.longitude = longitude;
  }

  UserMod.fromJson(Map json)
      : id_compte = json['id_compte'],
        nom = json['nom'],
        prenom = json['prenom'],
        email = json['email'],
        telephone = json['telephone'],
        date_naissance = json['date_naissance'],
        active = json['active'],
        sexe = json['sexe'],
        localisation = json['localisation'],
        date_creation = json['avatar'],
        photo = json['photo'],
        cni = json['cni'],
        permis = json['permis'],
        mot_de_passe = json['mot_de_passe'],
        description = json['description'],
        postulat = json['postulat'],
        type = json['type'],
        publie = json['publie'],
        admin = json['admin'],
        profil = json['profil'],
        flotte = json['flotte'],
        latitude = json['latitude'],
        longitude = json['longitude'];

  Map toJson() {
    return {
      'id_compte': id_compte,
      'date_creation': date_creation,
      'localisation': localisation,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'telephone': telephone,
      'date_naissance': date_naissance,
      'active': active,
      'sexe': sexe,
      'photo': photo,
      'cni': cni,
      'permis': permis,
      'mot_de_passe': mot_de_passe,
      'description': description,
      'postulat': postulat,
      'type': type,
      'publie': publie,
      'admin': admin,
      'profil': profil,
      'flotte': flotte,
      'longitude': longitude,
      'latitude': latitude
    };
  }

  static Map<String, dynamic> toMap(UserMod herbergement) => {
        'id_compte': herbergement.id_compte,
        'nom': herbergement.nom,
        'prenom': herbergement.prenom,
        'email': herbergement.email,
        'telephone': herbergement.telephone,
        'date_naissance': herbergement.date_naissance,
        'active': herbergement.active,
        'date_creation': herbergement.date_creation,
        'localisation': herbergement.localisation,
        'sexe': herbergement.sexe,
        'photo': herbergement.photo,
        'cni': herbergement.cni,
        'permis': herbergement.permis,
        'mot_de_passe': herbergement.mot_de_passe,
        'description': herbergement.description,
        'postulat': herbergement.postulat,
        'type': herbergement.type,
        'publie': herbergement.publie,
        'admin': herbergement.admin,
        'flotte': herbergement.flotte,
        'profil': herbergement.profil,
        'longitude': herbergement.longitude,
        'latitude': herbergement.latitude
      };

  static String encodeHotels(List<UserMod> hotelhts) => json.encode(
        hotelhts
            .map<Map<String, dynamic>>((hotelht) => toMap(hotelht))
            .toList(),
      );

  static List<UserMod> decodeHotels(String hotelhts) =>
      (json.decode(hotelhts) as List<dynamic>)
          .map<UserMod>((item) => UserMod.fromJson(item))
          .toList();

  UserMod.fill(
      {this.id_compte,
      this.nom,
      this.prenom,
      this.telephone,
      this.sexe,
      this.description,
      this.email,
      this.profil,
      this.localisation,
      this.date_naissance});
}
