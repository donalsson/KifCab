import 'dart:convert';

import 'dart:ffi';

class GammesModel {
  String gamme;
  String idgamme;
  String codegame;
  String libelleg;
  String resumeg;
  String photo;
  String couleurg;
  String descriptiong;
  String datecg;
  String active;
  String publie;

  GammesModel(
    String gamme,
    String idgamme,
    String codegame,
    String libelleg,
    String resumeg,
    String photo,
    String active,
    String descriptiong,
    String couleurg,
    String datecg,
    String type,
    String publie,
  ) {
    this.gamme = gamme;
    this.idgamme = idgamme;
    this.resumeg = resumeg;
    this.photo = photo;
    this.codegame = codegame;
    this.libelleg = libelleg;
    this.active = active;
    this.descriptiong = descriptiong;
    this.couleurg = couleurg;
    this.photo = photo;
    this.datecg = datecg;
    this.publie = publie;
    this.idgamme = idgamme;
  }

  GammesModel.fromJson(Map json)
      : gamme = json['gamme'],
        idgamme = json['id_gamme'],
        codegame = json['code_gamme'],
        libelleg = json['libelle_gamme'],
        resumeg = json['resume_gamme'],
        photo = json['photo'],
        active = json['active'],
        couleurg = json['couleur_gamme'],
        descriptiong = json['description_commerciale_gamme'],
        datecg = json['date_creation'],
        publie = json['publie'];

  Map toJson() {
    return {
      'gamme': gamme,
      'descriptiong': descriptiong,
      'idgamme': idgamme,
      'codegame': codegame,
      'libelleg': libelleg,
      'resumeg': resumeg,
      'photo': photo,
      'active': active,
      'couleurg': couleurg,
      'photo': photo,
      'datecg': datecg,
      'publie': publie
    };
  }

  static Map<String, dynamic> toMap(GammesModel herbergement) => {
        'gamme': herbergement.gamme,
        'idgamme': herbergement.idgamme,
        'codegame': herbergement.codegame,
        'libelleg': herbergement.libelleg,
        'resumeg': herbergement.resumeg,
        'photo': herbergement.photo,
        'active': herbergement.active,
        'descriptiong': herbergement.descriptiong,
        'couleurg': herbergement.couleurg,
        'photo': herbergement.photo,
        'datecg': herbergement.datecg,
        'publie': herbergement.publie
      };

  static String encodeHotels(List<GammesModel> hotelhts) => json.encode(
        hotelhts
            .map<Map<String, dynamic>>((hotelht) => toMap(hotelht))
            .toList(),
      );

  static List<GammesModel> decodeHotels(String hotelhts) =>
      (json.decode(hotelhts) as List<dynamic>)
          .map<GammesModel>((item) => GammesModel.fromJson(item))
          .toList();

  GammesModel.fill(
      {this.gamme,
      this.idgamme,
      this.codegame,
      this.resumeg,
      this.couleurg,
      this.libelleg,
      this.descriptiong,
      this.photo});
}
